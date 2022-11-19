using(Distributed)

Threads.nthreads()
addprocs(15)

@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD2)
@everywhere using(Random)
@everywhere using(Dates)

#Load code
@everywhere cd("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm")
@everywhere include("C:\\Users\\jeffr\\Documents\\work\\functions\\load.jl")
@everywhere include("abm_fine.jl")

S =expand_grid( [300, 900],     #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [0, 0.01],       #travel cost
                [1,1.5],         #tech
                [.5, 1],       #labor
                [0.1, .25],      #limit seed values
                [.015, .0015],   #Punish Cost
                [15000],         #max forest
                [0.03,.5],        #experiment limit
                [0.01],           #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled,
                [.5, 2],         #Defensibility
                [100, 1000])      #var forest



for i in 1:size(S)[1]
    if S[i,1].== 300  S[i,9] = 5000 end
    if S[i,10] .==.03 S[i,11] = .9 end
    if S[i,1].== 900
            S[i,2] = 6
            S[i,3] =[3,2]
            S[i,12] = [1,3,5]
            S[i,13] = 1
            if S[i,15] == 100 S[i,15]=300 end
            if S[i,15] == 1000 S[i,15]=3000 end
    end
end



#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf)
    cpr_abm(nrounds = 500,
            nsim = 2,
            fine_start = nothing,
            experiment_effort = .5
            n = n,
            ngroups = ng,
            lattice = l,
            travel_cost = tc,
            tech = te,
            labor = la,
            harvest_limit = ls,
            punish_cost = pc,
            max_forest = mf,
            experiment_limit = el,
            experiment_punish1 = ep,
            experiment_punish2 = ep,
            experiment_group = eg,
            groups_sampled =gs,
            defensibility = df,
            var_forest = vf,
            )
end
#Verify
check = false

if check == true
    for i = 1:128
        println(i)
        abm_dat = g(S[i,1], S[i,2], S[i,3], S[i,4], S[i,5], S[i,6], S[i,7], S[i,8],
         S[i,9], S[i,10], S[i,11], S[i,12], S[i,13], S[i,14], S[i,15])
    end
end

temp=collect(1:size(S)[1])
S1 = S[findall(x->isodd(x), temp), :]
abm_dat = pmap(g, S1[:,1], S1[:,2], S1[:,3], S1[:,4], S1[:,5], S1[:,6], S1[:,7],
 S1[:,8], S1[:,9], S1[:,10] , S1[:,11], S1[:,12] , S1[:,13],  S1[:,14],  S1[:,15])

@JLD2.save("abm_dat_small_limkS.jld2", abm_dat, S1)



temp=collect(1:size(S)[1])
S2 = S[findall(x->iseven(x), temp), :]
abm_dat = pmap(g, S2[:,1], S2[:,2], S2[:,3], S2[:,4], S2[:,5], S2[:,6], S2[:,7],
 S2[:,8], S2[:,9], S2[:,10] , S2[:,11], S2[:,12] , S2[:,13],  S2[:,14], S2[:,15])

@JLD2.save("abm_dat_large_limkS.jld2", abm_dat, S2)
