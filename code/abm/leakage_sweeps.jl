
using(Distributed)
@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD2)
@everywhere using(Random)
@everywhere using(Dates)
@everywhere using(Statistics)

@everywhere include("setup_utilies.jl")
@everywhere include("abm_ag.jl")



S =expand_grid( [300],              #Population Size
                [2],                #ngroups
                [[1, 2]],           #lattice, will be replaced below
                [0],                #travel cost
                collect(.1:.45:4),  #tech
                [.1, .5, .9],       #labor
                [0.1],              #limit seed values
                [.15],              #Punish Cost
                [350000],           #max forest
                [0.001,.9],         #experiment leakage
                [0],                #experiment punish
                [1],                #experiment_group
                [1],                #groups_sampled
                [1],                #Defensibility
                [1],                #var forest
                10 .^(collect(range(-2, stop = 1, length = 20))),      #price
                [.025],             #regrowth
                [[1, 1]],           #degrade
                10 .^(collect(range(-4, stop = 0, length = 20))),       #wages
                [false, true]       #Ag Sector
                )





#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg, as)
    cpr_abm(nrounds = 500,
            nsim = 10,
            fine_start = nothing,
            leak = false,
            pun1_on = false,
            pun2_on = false,
            experiment_effort = 1,
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
            wages = wg,
            ag_sector = as
            )
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19], S[:, 20])

@JLD2.save("leak_tech.jld2", abm_dat, S)

##############################################################################
################## Labor #####################################################


S =expand_grid( [300],              #Population Size
                [2],                #ngroups
                [[1, 2]],           #lattice, will be replaced below
                [0],                #travel cost
                [1],                #tech
                collect(0.01:.1:1), #labor
                [0.1],              #limit seed values
                [.15],              #Punish Cost
                [350000],           #max forest
                [0.001,.9],         #experiment leakage
                [0],                #experiment punish
                [1],                #experiment_group
                [1],                #groups_sampled
                [1],                #Defensibility
                [1],                #var forest
                10 .^(collect(range(-2, stop = 1, length = 20))),      #price
                [.025],             #regrowth
                [[1, 1]],           #degrade
                10 .^(collect(range(-4, stop = 0, length = 20))),       #wages
                [false, true]       #Ag Sector
                )



abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
S[:,16], S[:,17], S[:,18], S[:,19], S[:, 20])

@JLD2.save("leak_labor.jld2", abm_dat, S)


###############################################################################
######################## LEAKAGE ##############################################


S =expand_grid( [300],           #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                10 .^(collect(range(-2, stop =2, length = 10))),             #travel cost
                [1],   #tech
                [.1, .5, .9],     #labor
                [0.1],           #limit seed values
                [.0015],         #Punish Cost
                [350000],        #max forest
                [0.001,.9],      #experiment leakage
                [0],             #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [1],             #var forest
                10 .^(collect(range(-2, stop = 1, length = 20))),          #price
                [.01],           #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-4, stop = 0, length = 20))),       #wages
                [false, true]     #Ag Sector
                )





#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg, as)
    cpr_abm(nrounds = 500,
            nsim = 10,
            fine_start = nothing,
            leak = true,
            pun1_on = false,
            pun2_on = false,
            back_leak = true,
            experiment_effort = 1,
            kmax_data = [350000, 175000],
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
            wages = wg,
            ag_sector = as
            )
end

abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
S[:,16], S[:,17], S[:,18], S[:,19], S[:, 20])

@JLD2.save("leak_travel.jld2", abm_dat, S)


################################################################################
######################## Punish 1 ##############################################



S =expand_grid( [300],           #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [10],            #travel cost
                [1],             #tech
                [.1, .5, .9],    #labor
                [0.1],           #limit seed values
                10 .^(collect(range(-2, stop =2, length = 10))),         #Punish Cost
                [350000],        #max forest
                [0.001,.9],      #experiment leakage
                [0],             #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [1],             #var forest
                10 .^(collect(range(-2, stop = 1, length = 20))),          #price
                [.01],           #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-4, stop = 0, length = 20))),       #wages
                [false, true]     #Ag Sector
                )





#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg, as)
    cpr_abm(nrounds = 500,
            nsim = 10,
            fine_start = nothing,
            leak = false,
            pun1_on = true,
            pun2_on = false,
            back_leak = false,
            experiment_effort = 1,
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
            wages = wg,
            ag_sector = as
            )
end

abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
S[:,16], S[:,17], S[:,18], S[:,19], S[:, 20])

@JLD2.save("leak_pun1.jld2", abm_dat, S)




################################################################################
######################## Punish 2 ##############################################



S =expand_grid( [300],           #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [10],            #travel cost
                [1],             #tech
                [.1, .5, .9],    #labor
                [5],           #limit seed values
                10 .^(collect(range(-2, stop =2, length = 10))),         #Punish Cost
                [350000],        #max forest
                [0.001,.9],      #experiment leakage
                [0],             #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [1],             #var forest
                10 .^(collect(range(-2, stop = 1, length = 20))),          #price
                [.01],           #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-4, stop = 0, length = 20))),       #wages
                [false, true]     #Ag Sector
                )





#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg, as)
    cpr_abm(nrounds = 500,
            nsim = 10,
            fine_start = nothing,
            leak = false,
            pun1_on = false,
            pun2_on = true,
            back_leak = false,
            harvest_var = 1,
            experiment_effort = 1,
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
            wages = wg,
            ag_sector = as
            )
end

abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
S[:,16], S[:,17], S[:,18], S[:,19], S[:, 20])

@JLD2.save("leak_pun2.jld2", abm_dat, S)







##################################################################################
######################## ALL Labor .1 #############################################



S =expand_grid( [150*12],        #Population Size
                [12],             #ngroups
                [[3, 4]],        #lattice, will be replaced below
                [10],            #travel cost
                [1],             #tech
                [.1],            #labor
                [5],           #limit seed values
                10 .^(collect(range(-2, stop =2, length = 10))),         #Punish Cost
                [350000*6],        #max forest
                [0.001,.9],      #experiment leakage
                [0],             #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [1],             #var forest
                10 .^(collect(range(-2, stop = 1, length = 20))),          #price
                [.01],           #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-4, stop = 0, length = 20))),       #wages
                [false, true]     #Ag Sector
                )





#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg, as)
    cpr_abm(nrounds = 500,
            nsim = 10,
            fine_start = nothing,
            leak = true,
            pun1_on = true,
            pun2_on = true,
            back_leak = true,
            experiment_effort = 1,
            harvest_var = 1,
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
            wages = wg,
            ag_sector = as
            )
end

abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
S[:,16], S[:,17], S[:,18], S[:,19], S[:, 20])

@JLD2.save("leak_all1.jld2", abm_dat, S)




##################################################################################
######################## ALL Labor .5 #############################################



S =expand_grid( [150*12],        #Population Size
                [12],             #ngroups
                [[3, 4]],        #lattice, will be replaced below
                [.1],            #travel cost
                [1],             #tech
                [.5],            #labor
                [5],           #limit seed values
                10 .^(collect(range(-2, stop =2, length = 10))),         #Punish Cost
                [350000*6],        #max forest
                [0.001,.9],      #experiment leakage
                [0],             #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [1],             #var forest
                10 .^(collect(range(-2, stop = 1, length = 20))),          #price
                [.01],           #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-4, stop = 0, length = 20))),       #wages
                [false, true]     #Ag Sector
                )





#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg, as)
    cpr_abm(nrounds = 500,
            nsim = 10,
            fine_start = nothing,
            leak = true,
            pun1_on = true,
            pun2_on = true,
            back_leak = false,
            experiment_effort = 1,
            harvest_var = 1,
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
            wages = wg,
            ag_sector = as
            )
end

abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
S[:,16], S[:,17], S[:,18], S[:,19], S[:, 20])

@JLD2.save("leak_all5.jld2", abm_dat, S)



##################################################################################
######################## ALL Labor .9 #############################################



S =expand_grid( [150*12],        #Population Size
                [12],             #ngroups
                [[3, 4]],        #lattice, will be replaced below
                [10],            #travel cost
                [1],             #tech
                [.9],            #labor
                [5],           #limit seed values
                10 .^(collect(range(-2, stop =2, length = 10))),         #Punish Cost
                [350000*6],        #max forest
                [0.001,.9],      #experiment leakage
                [0],             #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [1],             #var forest
                10 .^(collect(range(-2, stop = 1, length = 20))),          #price
                [.01],           #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-4, stop = 0, length = 20))),       #wages
                [false, true]     #Ag Sector
                )





#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg, as)
    cpr_abm(nrounds = 500,
            nsim = 10,
            fine_start = nothing,
            leak = true,
            pun1_on = true,
            pun2_on = true,
            back_leak = true,
            experiment_effort = 1,
            harvest_var = 1,
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
            wages = wg,
            ag_sector = as
            )
end

abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
S[:,16], S[:,17], S[:,18], S[:,19], S[:, 20])

@JLD2.save("leak_all9.jld2", abm_dat, S)
