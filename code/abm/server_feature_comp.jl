#####################################################
############## Heatmaps #############################

using(Distributed)
@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD2)
@everywhere using(Random)
@everywhere using(Dates)
@everywhere using(Statistics)
@everywhere using(StatsFuns)

@everywhere include("setup_utilies.jl")
@everywhere include("abm_gradiated.jl")



S =expand_grid(
                [false, true],                          # Seized 
                [false, true],                          # Og
                [false, true],                          # Fine2
                ["wealth", "income", "env", false],     # Glearn_strat
                ["equal", "min", "max"],                # Policy weight
                ["income", "wealth"]                    # Learn Strategy
                )

#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(s, og, f2, grs, pw, lt)
    cpr_abm(
    ngroups = 15,
    n = 150*15,
    tech = 1,
    wages = .1,
    price = 1,
    max_forest=10000*15,
    nrounds = 1000,
    nsim =5,
    regrow = .01,
    labor = .7,
    lattice =[5,3],
    var_forest = 0,
    pun1_on = true,
    pun2_on =true,
    travel_cost = .00001,
    outgroup = 0.01,
    harvest_var = .07,
    defensibility = 1,
    seized_on = s,
    leak = true,
    zero = true,
    og_on = og,
    fines_on = true,
    fines1_on = true,
    fines_evolve = true,
    fines2_on = f2,
    verbose = false,
    fine_start = .1,
    fine_var = .2,
    glearn_strat = grs,
    monitor_tech = [1,1],
    harvest_type = "individual",
    policy_weight = pw,
    learn_type = lt
)
end

abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6])

@JLD2.save("feature_comp_sweep.jld2", abm_dat, S)
