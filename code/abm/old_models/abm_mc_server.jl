#packages
using(Distributed)

Threads.nthreads()
addprocs(40)

@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD2)

#Load code
#@everywhere cd("cpr\\code\\abm")
@everywhere include("cpr_setup.jl")
@everywhere include("cpr_lim.jl")


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
        S[i,9] =[1,2,3,4,5,6]
    end
end

#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, v, dg, df, el, ep, eg, c)
    cpr_abm(n = n,
            nrounds = 2000,
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

#Verify
check = false

if check == true
    for i = 1:128
        println(i)
        abm_dat = g(S[i,1], S[i,2], S[i,3], S[i,4], S[i,5], S[i,6], S[i,7], S[i,8], S[i,9], S[i,10])
    end
end
#run the code
abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7], S[:,8], S[:,9], S[:,10])



#save the code
save("abm_dat_lg.jld2", abm_dat)
