#load in at home/jeffrey_andrews/
#call include("cpr/code/abm/env_server_zero.jl")

using(Distributed)

Threads.nthreads()

@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD2)
@everywhere using(Random)
@everywhere using(Dates)

#Load code
@everywhere include("setup_utilies.jl")
print("loaded setup")
@everywhere include("abm_zero.jl")


tech_data1 = Float64[]
 for i in 0.00001:.00001:1 push!(tech_data1, cdf(Beta(1, 1), i)) end
tech_data1 =tech_data1*1.5


tech_data2 = Float64[]
 for i in 0.00001:.00001:1 push!(tech_data2, cdf(Beta(10, 10), i)) end
tech_data2 =tech_data2*1.5


print("loaded tech")
S =expand_grid( [3000],              #Population Size
                [20],            #ngroups
                [[4, 5]],           #lattice, will be replaced below
                [.01, 0.05],        #Regrowth
                [1, 500000],        #Variance
                [[1, 1],[5, 2]],    #Degradability
                [.5, 1],            #Defensibility
                [0,  .9],           #Experiment_leak
                [0],                #experiment_punish
                [[1,2,3,4]],                #experiment_group
                [false],            #cmls
                [true],             #social learning
                [true],             #leakage
                [true],             #self policing
                [2000000],          #max forest
                [false, true],      #Polution
                [false, true],      #ecosystem serivices
                [0, .15],            #volatitlity
                [tech_data1, tech_data2],
                [nothing]             #volatility beta
                )

D =expand_grid( [3000],              #Population Size
                [20],            #ngroups
                [[4, 5]],           #lattice, will be replaced below
                [.01, 0.05],        #Regrowth
                [1, 500000],        #Variance
                [[1, 1],[5, 2]],    #Degradability
                [.5, 1],            #Defensibility
                [0,  .9],           #Experiment_leak
                [0],                #experiment_punish
                [[1,2,3,4]],                #experiment_group
                [false],            #cmls
                [true],             #social learning
                [true],             #leakage
                [true],             #self policing
                [2000000],          #max forest
                [false, true],      #Polution
                [false, true],      #ecosystem serivices
                [.15],             #volatitlity
                [tech_data1, tech_data2],
                [[1, 1], [10, 10]]
                )

print("loaded grids")





#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, rg, v, dg, df, el, ep, eg, c, sl, lk, sp, mf, po, ec, vol, te, vb)
    cpr_abm(n = n,
            nrounds = 100000,
            nsim = 20,
            harvest_limit = .1,
            ngroups = ng,
            lattice = l,
            regrow = rg,
            var_forest = v,
            degrade = dg,
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
            ecosys = ec,
            volatility = vol,
            tech_data = te,
            vol_beta = vb,
            eco_C = 0.1,
            pol_C =0.2)
end


print("functions built grids")
#Verify
check = false

if check == true
    for i = 1:1024
        println(i)
        abm_dat = g(S[i,1], S[i,2], S[i,3], S[i,4], S[i,5], S[i,6], S[i,7], S[i,8],
         S[i,9], S[i,10], S[i,11], S[i,12], S[i,13], S[i,14], S[i,15], S[i,16],
          S[i,17], S[i,18], S[i,19], S[i, 20])
    end
end



abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12], S[:,13], S[:,14], S[:,15], S[:, 16], S[:, 17],
  S[:,18], S[:,19], S[:,20])

 @JLD2.save("abm_dat_envZS.jld2", abm_dat, S)


print("round 2 begins")


abm_dat2 = pmap(g, D[:,1], D[:,2], D[:,3], D[:,4], D[:,5], D[:,6], D[:,7],
 D[:,8], D[:,9], D[:,10] , D[:,11], D[:,12], D[:,13], D[:,14], D[:,15], D[:, 16], D[:, 17],
 D[:,18], D[:,19], D[:,20])

 @JLD2.Dave("abm_dat_envZD.jld2", abm_dat2, D)
