#load in at home/jeffrey_andrews/
#call include("cpr/code/abm/abm_env.jl")


using(Distributed)

Threads.nthreads()

@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD2)
@everywhere using(Random)
@everywhere using(Dates)

#Load code
@everywhere include("cpr/code/abm/cpr_setup.jl")
@everywhere include("cpr/code/abm/cpr_sep.jl")


S =expand_grid( [900],               #Population Size
                [6, 60],                #ngroups
                [[3, 2]],           #lattice, will be replaced below
                [.01 ,0.05],         #Regrowth
                [1, 1500],          #Variance
                [0,1],              #Degradability
                [.5, 1],            #Defensibility
                [0.  9],            #Experiment_leak
                [0],                #experiment_punish
                [1],                #experiment_group
                [false],            #cmls
                [true],             #social learning
                [true],              #leakage
                [true],               #self policing
                [10000]              #max forest
                )

for i in 1:size(S)[1]
    if S[i,2].==60
        S[i,3] =[6,10]
        S[i,1] =9000
        S[i, 15]=100000
        if S[i, 5].==1500 S[i, 5]=15000 end
        if S[i,8] .==9
                S[i,10] =[1,2,3,4,5,6]
                S[i,9] =.9
        end
    end
end

#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, rg, v, dg, df, el, ep, eg, c, sl, lk, sp, mf)
    cpr_abm(n = n,
            nrounds = 2000,
            nsim = 30,
            ngroups = ng,
            lattice = l,
            regrow = rg,
            var_forest = v,
            degradability = dg,
            defensibility = df,
            experiment_leak = el,
            experiment_punish1 = ep,
            experiment_group = eg,
            cmls = c,
            social_learning = sl,
            leak = lk,
            self_policing = sp,
            max_forest = mf )
end

#Verify
check = false

if check == true
    for i = 1:2
        println(i)
        abm_dat = g(S[i,1], S[i,2], S[i,3], S[i,4], S[i,5], S[i,6], S[i,7], S[i,8],
         S[i,9], S[i,10], S[i,11], S[i,12], S[i,13], S[i,14], S[i,15])
    end
end

abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12], S[:,13], S[:,15])

@JLD2.save("\\cpr\\data\\abm\\abm_dat_envWS.jld2", abm_dat, S)
@JLD2.save("\\cpr\\data\\abm\\abm_dat_env.jld2", abm_dat)
