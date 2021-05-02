#load in at home/jeffrey_andrews/
#call include("cpr/code/abm/abm_env_server.jl")

using(Distributed)

Threads.nthreads()

@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD2)
@everywhere using(Random)
@everywhere using(Dates)

#Load code
@everywhere include("cpr_setup.jl")
@everywhere include("abm_red.jl")


S =expand_grid( [300],              #Population Size
                [2, 20],            #ngroups
                [[1, 2]],           #lattice, will be replaced below
                [.01 ,0.05],        #Regrowth
                [1, 150],           #Variance
                [0,1],              #Degradability
                [.5, 1],            #Defensibility
                [0.  .9],            #Experiment_leak
                [0],                #experiment_punish
                [1],                #experiment_group
                [false],            #cmls
                [true],             #social learning
                [true],             #leakage
                [true],             #self policing
                [1650,16500],      #max forest
                [false, true],      #Polution
                [false, true],      #ecosystem serivices
                )



for i in 1:size(S)[1]
    if (S[i,5].== 150) & (S[i,15].== 16500) S[i,5] = 1500 end
    if S[i,2].==20
        S[i,3] =[4,5]
        S[i,1] =3000
        if S[i, 15] .== 1650 S[i, 15] = 16501 end #small hack for getting sizes right
        if S[i, 5].==750 S[i, 5]=7500 end
        if S[i, 15].==16500
                S[i, 15] = 165000
                if S[i, 5].==1500 S[i, 5]=15000 end
        end

        if S[i,8] .== .9
                S[i,10] =[1,2,3,4]
                S[i,9] =.9
        end
    end
end



#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, rg, v, dg, df, el, ep, eg, c, sl, lk, sp, mf, po, ec)
    cpr_abm(n = n,
            nrounds = 2000,
            nsim = 10,
            harvest_limit = .1,
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
            max_forest = mf,
            pollution = po,
            ecosys = ec)
end

#Verify
check = false

if check == true
    for i = 1:256
        println(i)
        abm_dat = g(S2[i,1], S2[i,2], S2[i,3], S2[i,4], S2[i,5], S2[i,6], S2[i,7], S2[i,8],
         S2[i,9], S2[i,10], S2[i,11], S2[i,12], S2[i,13], S2[i,14], S2[i,15], S2[i,16], S2[i,17])
    end
end

S2=S[iseven.(collect(1:512)), :]

abm_dat = pmap(g, S2[:,1], S2[:,2], S2[:,3], S2[:,4], S2[:,5], S2[:,6], S2[:,7],
 S2[:,8], S2[:,9], S2[:,10] , S2[:,11], S2[:,12], S2[:,13], S2[:,14], S2[:,15], S2[:, 16], S2[:, 17])

 @JLD2.save("abm_dat_envWS2.jld2", abm_dat, S2)
 @JLD2.save("abm_dat_env2.jld2", abm_dat)
