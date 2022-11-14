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
@everywhere include("abm_politics.jl")



S =expand_grid([false, true],                   #pun2_on
                [false, true],                  #seized
                [false, true],                  #leak
                [false, true],                  #zeros
                [false, true],                  #og
                ["wealth", "poor", false],      #power
                [false, true],                  #fine2
                [false, true],                  #group_learn
                ["wealth", "income"]            #glearn_strat
)



#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(p1, s, l, z, p,og, f2, gl, gs)
    cpr_abm(
    ngroups = 15,
    n = 150*15,
    tech = 4,
    wages = .05,
    price = 1,
    max_forest=7500*15,
    nrounds = 3000,
    nsim =5,
    regrow = .01,
    labor = .7,
    lattice =[5,3],
    var_forest = 0,
    pun1_on = true,
    pun2_on =p1,
    outgroup = 0.01,
    harvest_var = .07,
    defensibility = 1,
    seized_on = s,
    leak = l,
    zero = z,
    og_on = og,
    power = p,
    fines1_on = true,
    fines2_on = f2,
    verbose = false,
    fine_start = 1,
    fine_var = .2,
    group_learn = gl,
    glearn_strat = gs,
    monitor_tech = [1,1]
)
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9])

@JLD2.save("feature_sweep.jld2", abm_dat, S)
