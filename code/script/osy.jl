#Give OSY the parameters you want maximized and figure 
@everywhere function getOSY(;labor,
     wages,
     tech=1,
     price,
     max_forest,
     regrow,
     n,
    ncores =1)
    # Set up multi-core processing
    nps = nprocs()
    additional_cores = ncores -nps
    addprocs(additional_cores)
    @everywhere include("functions/utility.jl")
    @everywhere include("cpr/code/abm/load_submod.jl")
    @everywhere include("cpr/code/abm/abm_group_policy.jl")
    # Build Paramaters
    S=collect(0.001:0.01:1.0)
    nS = length(S)
    labor1 = fill(labor, nS)
    wages1 = fill(wages, nS)
    tech1 = fill(tech, nS)
    price1 = fill(price, nS)
    max_forest1 = fill(max_forest, nS)
    regrow1 = fill(regrow, nS)
    n1 = fill(n, nS)
    # set up a smaller call function that allows for only a sub-set of pars to be manipulated
    @everywhere function temp(S, labor, wages, tech, price, max_forest, regrow, n)
        cpr_abm(n = n, ngroups = 2, lattice = (1,2), max_forest = max_forest, regrow = regrow,
        leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01,
        wages = wages, price = price, tech = tech, labor = labor, fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
        nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_effort = S, compress_data = false)
    end
    msy=pmap(temp, S[:], labor1, wages1, tech1, price1, max_forest1, regrow1, n1)
    a=[mean(msy[q][:payoffR][700:end,1,1]) for q in 1:length(msy)]
    
    #Clean up cores
    rmprocs(procs()[(nps+1):(additional_cores+nps)])
    ind = findmax(a)[2]
    return(print("Optimal sustainable yeild effort = ", S[ind],", harvest = ", mean(msy[ind][:harvest][900:end,1,1]), " and payoff is = ", mean(msy[ind][:payoffR][900:end,1,1]),
    "and stock is ",  mean(msy[ind][:stock][900:end,1,1])))
end

# Example
# getOSY(labor = .7, wages = .2, price = 1, tech = 1, max_forest = 1400*60,  regrow = .025, n = 60, ncores = 4)

