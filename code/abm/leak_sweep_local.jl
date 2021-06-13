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

S =expand_grid( [300, 1350],     #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [0, 0.01],       #travel cost
                [.15,1.5],       #tech
                [.35,.7],        #labor
                [0.1],           #limit seed values
                [.015, .0015],   #Punish Cost
                [2500*4.5, 5000*4.5],      #max forest
                [0.001,.9],      #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1, 4],          #Defensibility
                [60, 600],       #var forest
                [1,10],          #price
                [.01, 0.05],        #regrowth
                [[1, 1], [10, 10]], #degrade
                [.015, .15]         #wages
                )



for i in 1:size(S)[1]
    if S[i,1].== 300
            if  S[i,9] ==2500*4.5  S[i,9] = 2500 end
            if  S[i,9] ==5000*4.5  S[i,9] = 5000 end
            if  S[i,9] ==10000*4.5  S[i,9] = 10000 end
    end
    if S[i,1].== 1350
            S[i,2] = 9
            S[i,3] =[3,3]
            S[i,12] = [1,3,7,9]
            S[i,13] = 3
            if S[i,15] == 10 S[i,15]=60 end
            if S[i,15] == 100 S[i,15]=600 end
    end
end



#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 2,
            fine_start = nothing,
            leak = true,
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
            defensibility = df,
            var_forest = vf,
            price = pr,
            regrow = rg,
            degrade=dg,
            wages = wg

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
 S1[:,8], S1[:,9], S1[:,10] , S1[:,11], S1[:,12] , S1[:,13],  S1[:,14], S1[:,15],
 S1[:,16], S1[:,17], S1[:,18], S1[:,19])

@JLD2.save("abm_dat_small_lkS.jld2", abm_dat, S1)



temp=collect(1:size(S)[1])
S2 = S[findall(x->iseven(x), temp), :]
abm_dat = pmap(g, S2[:,1], S2[:,2], S2[:,3], S2[:,4], S2[:,5], S2[:,6], S2[:,7],
 S2[:,8], S2[:,9], S2[:,10] , S2[:,11], S2[:,12] , S2[:,13],  S2[:,14], S2[:,15],
 S2[:,16],  S2[:,17], S2[:,18], S2[:,19])

@JLD2.save("abm_dat_large_lkS.jld2", abm_dat, S2)



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

S =expand_grid( [300, 1350],     #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [0],             #travel cost
                [.15,1.5],         #tech
                [.35,.7],        #labor
                [0.1],           #limit seed values
                [.015],   #Punish Cost
                [2500*4.5, 5000*4.5],      #max forest
                [0.001,.9],      #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],          #Defensibility
                [10, 100],       #var forest
                [1,10],          #price
                [.01, 0.05],     #regrowth
                [[1, 1], [10, 10]], #degrade
                [.015, .15]       #wages
                )



for i in 1:size(S)[1]
    if S[i,1].== 300
            if  S[i,9] ==2500*4.5  S[i,9] = 2500 end
            if  S[i,9] ==5000*4.5  S[i,9] = 5000 end
            if  S[i,9] ==10000*4.5  S[i,9] = 10000 end
    end
    if S[i,1].== 1350
            S[i,2] = 9
            S[i,3] =[3,3]
            S[i,12] = [1,3,7,9]
            S[i,13] = 3
            if S[i,15] == 10 S[i,15]=60 end
            if S[i,15] == 100 S[i,15]=600 end
    end
end



#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 2,
            fine_start = nothing,
            leak = false,
            pun1_on = false,
            pun2_on = false,
            verbose = false,
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
            defensibility = df,
            var_forest = vf,
            price = pr,
            regrow = rg,
            degrade=dg,
            wages = wg

            )
end
#Verify
check = false

if check == true
    for i = 1:128
        println(i)
        abm_dat = g(S[i,1], S[i,2], S[i,3], S[i,4], S[i,5], S[i,6], S[i,7], S[i,8],
         S[i,9], S[i,10], S[i,11], S[i,12], S[i,13], S[i,14], S[i,15],  S[i,16],  S[i,17],  S[i,18],
          S[i,19])
    end
end

temp=collect(1:size(S)[1])
S1 = S[findall(x->isodd(x), temp), :]
abm_dat = pmap(g, S1[:,1], S1[:,2], S1[:,3], S1[:,4], S1[:,5], S1[:,6], S1[:,7],
 S1[:,8], S1[:,9], S1[:,10] , S1[:,11], S1[:,12] , S1[:,13],  S1[:,14], S1[:,15],
 S1[:,16], S1[:,17], S1[:,18], S1[:,19])

@JLD2.save("abm_dat_small_lkS_nlp1p2.jld2", abm_dat, S1)



temp=collect(1:size(S)[1])
S2 = S[findall(x->iseven(x), temp), :]
abm_dat = pmap(g, S2[:,1], S2[:,2], S2[:,3], S2[:,4], S2[:,5], S2[:,6], S2[:,7],
 S2[:,8], S2[:,9], S2[:,10] , S2[:,11], S2[:,12] , S2[:,13],  S2[:,14], S2[:,15],
 S2[:,16],  S2[:,17], S2[:,18], S2[:,19])

@JLD2.save("abm_dat_large_lkS_nlp1p2.jld2", abm_dat, S2)




#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 2,
            fine_start = nothing,
            leak = true,
            pun1_on = false,
            pun2_on = false,
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
            defensibility = df,
            var_forest = vf,
            price = pr,
            regrow = rg,
            degrade=dg,
            wages = wg

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
 S1[:,8], S1[:,9], S1[:,10] , S1[:,11], S1[:,12] , S1[:,13],  S1[:,14], S1[:,15],
 S1[:,16], S1[:,17], S1[:,18], S1[:,19])

@JLD2.save("abm_dat_small_lkS_np1p2.jld2", abm_dat, S1)



temp=collect(1:size(S)[1])
S2 = S[findall(x->iseven(x), temp), :]
abm_dat = pmap(g, S2[:,1], S2[:,2], S2[:,3], S2[:,4], S2[:,5], S2[:,6], S2[:,7],
 S2[:,8], S2[:,9], S2[:,10] , S2[:,11], S2[:,12] , S2[:,13],  S2[:,14], S2[:,15],
 S2[:,16],  S2[:,17], S2[:,18], S2[:,19])

@JLD2.save("abm_dat_large_lkS_np1p2.jld2", abm_dat, S2)






S =expand_grid( [300, 1350],     #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [0],             #travel cost
                [.15,1.5],         #tech
                [.35,.7],        #labor
                [0.1],           #limit seed values
                [0.015, .0015],          #Punish Cost
                [2500*4.5, 5000*4.5],      #max forest
                [0.001,.9],      #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1, 4],          #Defensibility
                [10, 100],       #var forest
                [1,10],          #price
                [.01, 0.05],     #regrowth
                [[1, 1], [10, 10]], #degrade
                [.015, .15]       #wages
                )



for i in 1:size(S)[1]
    if S[i,1].== 300
            if  S[i,9] ==2500*4.5  S[i,9] = 2500 end
            if  S[i,9] ==5000*4.5  S[i,9] = 5000 end
            if  S[i,9] ==10000*4.5  S[i,9] = 10000 end
    end
    if S[i,1].== 1350
            S[i,2] = 9
            S[i,3] =[3,3]
            S[i,12] = [1,3,7,9]
            S[i,13] = 3
            if S[i,15] == 10 S[i,15]=60 end
            if S[i,15] == 100 S[i,15]=600 end
    end
end




#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 2,
            fine_start = nothing,
            leak = true,
            pun1_on = true,
            pun2_on = false,
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
            defensibility = df,
            var_forest = vf,
            price = pr,
            regrow = rg,
            degrade=dg,
            wages = wg

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
 S1[:,8], S1[:,9], S1[:,10] , S1[:,11], S1[:,12] , S1[:,13],  S1[:,14], S1[:,15],
 S1[:,16], S1[:,17], S1[:,18], S1[:,19])

@JLD2.save("abm_dat_small_lkS_np1.jld2", abm_dat, S1)



temp=collect(1:size(S)[1])
S2 = S[findall(x->iseven(x), temp), :]
abm_dat = pmap(g, S2[:,1], S2[:,2], S2[:,3], S2[:,4], S2[:,5], S2[:,6], S2[:,7],
 S2[:,8], S2[:,9], S2[:,10] , S2[:,11], S2[:,12] , S2[:,13],  S2[:,14], S2[:,15],
 S2[:,16],  S2[:,17], S2[:,18], S2[:,19])

@JLD2.save("abm_dat_large_lkS_np1.jld2", abm_dat, S2)





#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 2,
            fine_start = nothing,
            leak = true,
            pun1_on = false,
            pun2_on = true,
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
            defensibility = df,
            var_forest = vf,
            price = pr,
            regrow = rg,
            degrade=dg,
            wages = wg

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
 S1[:,8], S1[:,9], S1[:,10] , S1[:,11], S1[:,12] , S1[:,13],  S1[:,14], S1[:,15],
 S1[:,16], S1[:,17], S1[:,18], S1[:,19])

@JLD2.save("abm_dat_small_lkS_np2.jld2", abm_dat, S1)



temp=collect(1:size(S)[1])
S2 = S[findall(x->iseven(x), temp), :]
abm_dat = pmap(g, S2[:,1], S2[:,2], S2[:,3], S2[:,4], S2[:,5], S2[:,6], S2[:,7],
 S2[:,8], S2[:,9], S2[:,10] , S2[:,11], S2[:,12] , S2[:,13],  S2[:,14], S2[:,15],
 S2[:,16],  S2[:,17], S2[:,18], S2[:,19])

@JLD2.save("abm_dat_large_lkS_np2.jld2", abm_dat, S2)
