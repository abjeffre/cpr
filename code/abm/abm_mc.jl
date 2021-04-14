#packages
using(Distributed)

Threads.nthreads()
addprocs(40)

@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD)

#Load code
@everywhere include("cpr\\code\\abm\\cpr_setup.jl")
@everywhere include("cpr\\code\\abm\\cpr_lim.jl")


S =expand_grid( [1800],         #Population Size
                [6, 60],        #ngroups
                [[3, 2]],       #lattice, will be replaced below
                [1, 1500],      #Variance
                [0,1],          #Degradability
                [.5,1],         #Defensibility
                [false,.9],     #Experiment_leak
                [false,.9],     #experiment_punish
                [1],            #experiment_group
                [false, true]   #cmls
                )


#give the larger lattice to when we have many groups
#Also decrease the variance
for i in 1:size(S)[1]
    if S[i,2].==60
        S[i,3] =[6,10]
        S[i,8] =[1,2,3,4,5,6]
    end
end

#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, v, dg, df, el, ep, eg, c)
    cpr_abm(n = n,
            nsim = 30,
            ngroups = ng,
            lattice = l,
            var_forest = v,
            degradability = dg,
            defensibility = df,
            experiment_leak = el,
            experiment_punish = ep,
            experiment_group = eg,
            cmls = c )
end

#run the code
abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7], S[:,8], S[:,9], S[:,10])

#save the code
save("cpr\\data\\abm\\abm_dat_lg.jld" , abm_dat)
