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

S =expand_grid( [300, 3000],     #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [0, 0.01],       #travel cost
                [0.5,1],         #tech
                [.07, .7],       #labor
                [0.1, .25],      #limit seed values
                [.015, .0015],   #Punish Cost
                [50000],         #max forest
                [0.0001,.9],     #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled,
                [0.01, 0.9]      #outgroup
                )



for i in 1:size(S)[1]
    if S[i,1].== 300  S[i,9] = 5000 end
    if S[i,1].== 3000
            S[i,2] = 20
            S[i,3] =[4,5]
            S[i,12] = [1,2,3,4,5]
            S[i,13] = 5
    end
end



#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, og)
    cpr_abm(nrounds = 1000,
            nsim = 20,
            fine_start = .1,
            var_forest = 100,
            n = n,
            ngroups = ng,
            lattice = l,
            travel_cost = tc,
            tech = te,
            labor = la,
            harvest_limit = ls,
            punish_cost = pc,
            max_forest = mf,
            experiment_leak = el,
            experiment_punish1 = ep,
            experiment_punish2 = ep,
            experiment_group = eg,
            groups_sampled =gs,
            outgroup = og
            )
end
#Verify
check = false

if check == true
    for i = 1:128
        println(i)
        abm_dat = g(S[i,1], S[i,2], S[i,3], S[i,4], S[i,5], S[i,6], S[i,7], S[i,8],
         S[i,9], S[i,10], S[i,11], S[i,12], S[i,13], S[i,14])
    end
end

temp=collect(1:size(S)[1])
S1 = S[findall(x->isodd(x), temp), :]
abm_dat = pmap(g, S1[:,1], S1[:,2], S1[:,3], S1[:,4], S1[:,5], S1[:,6], S1[:,7],
 S1[:,8], S1[:,9], S1[:,10] , S1[:,11], S1[:,12] , S1[:,13],  S1[:,14])

@JLD2.save("abm_dat_small_fine_lkS.jld2", abm_dat, S1)



temp=collect(1:size(S)[1])
S2 = S[findall(x->iseven(x), temp), :]
abm_dat = pmap(g, S2[:,1], S2[:,2], S2[:,3], S2[:,4], S2[:,5], S2[:,6], S2[:,7],
 S2[:,8], S2[:,9], S2[:,10] , S2[:,11], S2[:,12] , S2[:,13],  S2[:,14])

@JLD2.save("abm_dat_large_fine_lkS.jld2", abm_dat, S2)
