#####################################################
############## Sweeps ###############################

using(Distributed)
@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD2)
@everywhere using(Random)
@everywhere using(Dates)
@everywhere using(Statistics)
@everywhere include("cpr/code/abm/setup_utilies.jl")
@everywhere include("cpr/code/abm/abm_invpun.jl")



#########################################
############## LABOR ####################
S =expand_grid( [300],           #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [0],             #travel cost
                [1],             #tech
                collect(0.1:0.1:1), #labor
                [10],           #limit seed values
                [.0015],         #Punish Cost
                [420000],        #max forest
                [0.000,.9],      #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [0],             #var forest
                10 .^(collect(range(-3, stop = 1, length = 20))),          #price
                [.025],          #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-3, stop = 1, length = 20)))       #wages
                )




#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 1,
            fine_start = nothing,
            leak = false,
            pun1_on = false,
            pun2_on = false,
            back_leak = false,
            harvest_var = 2.5,
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
            wages = wg

            )
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])

@JLD2.save("abmDatLabor.jld2", abm_dat, S)


#########################################
############# Leakage ###################


S =expand_grid( [300],           #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                 10 .^(collect(range(-4, stop =1, length = 10))),             #travel cost
                [1],             #tech
                [.7],            #labor
                [10],           #limit seed values
                [.0015],         #Punish Cost
                [420000],         #max forest
                [0.0001,.9],      #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [0],             #var forest
                10 .^(collect(range(-3, stop = 1, length = 20))),          #price
                [.025],          #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-3, stop = 1, length = 20)))       #wages
                )
#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 1,
            fine_start = nothing,
            leak = true,
            pun1_on = false,
            pun2_on = false,
            back_leak = true,
            harvest_var = 2.5,
            experiment_effort = 1,
            n = n,
            ngroups = ng,
            lattice = l,
            travel_cost = tc,
            tech = te,
            labor = la,
            harvest_limit = ls,
            punish_cost = pc,
            kmax_data = [210000*1.5,210000],
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


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])

@JLD2.save("abmDatLeak.jld2", abm_dat, S)


#######################################
########## Punish 1 ###################


S =expand_grid( [300],           #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [.0001],         #travel cost
                [1],             #tech
                [.7],            #labor
                [10],           #limit seed values
                10 .^(collect(range(-5, stop =1, length = 6))),     #Punish Cost
                [420000],        #max forest
                [0.000,.9],      #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [0],             #var forest
                10 .^(collect(range(-3, stop = 1, length = 20))),          #price
                [.025],          #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-3, stop = 1, length = 20)))       #wages
                )




#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 5,
            fine_start = nothing,
            leak = false,
            pun1_on = true,
            pun2_on = false,
            harvest_var = 2.5,
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
            wages = wg
            )
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])

@JLD2.save("abmDatP1.jld2", abm_dat, S)

###########################
######  Punish 2 ##########

S =expand_grid( [300],           #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [.0001],         #travel cost
                [1],             #tech
                [.7],            #labor
                [2],             #limit seed values
                10 .^(collect(range(-5, stop =1, length = 6))),     #Punish Cost
                [420000],      #max forest
                [0.0001,.9],      #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [0],             #var forest
                10 .^(collect(range(-3, stop = 1, length = 20))),          #price
                [.025],          #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-3, stop = 1, length = 20)))       #wages
                )




# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 5,
            fine_start = nothing,
            leak = false,
            pun1_on = false,
            pun2_on = true,
            full_save = true,
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
            wages = wg
            )
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])
 
 @JLD2.save("abmDatP2.jld2", abm_dat, S)



 
#####################################
######  FULL TWO GROUP ##############
@everywhere include("cpr/code/abm/abm_invpun.jl")


S =expand_grid( [300],           #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [.0001],         #travel cost
                [1],             #tech
                [.7],            #labor
                [1.5],             #limit seed values
                10 .^(collect(range(-5, stop =1, length = 6))),     #Punish Cost
                [420000],      #max forest
                [0.000,.9],      #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [0],             #var forest
                10 .^(collect(range(-3, stop = 1, length = 20))),          #price
                [.025],          #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-3, stop = 1, length = 20)))       #wages
                )




# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 5,
            fine_start = nothing,
            leak = false,
            pun1_on = true,
            pun2_on = true,
            full_save = true,
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
            wages = wg
            )
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])
 
 @JLD2.save("abmDatP1P2.jld2", abm_dat, S)



#####################################
######  FULL MULTI GROUP ##############
@everywhere include("cpr/code/abm/abm_invpun.jl")

S =expand_grid( [150*9],         #Population Size
                [9],            #ngroups
                [[3, 3]],        #lattice, will be replaced below
                [.0001],         #travel cost
                [1],             #tech
                [.7],            #labor
                [1.5],             #limit seed values
                10 .^(collect(range(-5, stop =1, length = 6))),       #Punish Cost
                [210000*9],      #max forest
                [0.0001,.9],     #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [3],             #groups_sampled
                [1],             #Defensibility
                [0],             #var forest
                10 .^(collect(range(-3, stop = 1, length = 20))),          #price
                [.025],          #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-3, stop = 1, length = 20))),       #wages,
                [.5] # outgroup punishment experiment 
                )

S[:,11] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,11] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,20] = ifelse.(S[:,10].==.0001, .0001, .9)


# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 10,
            fines1_on = false,
            fines2_on = false,
            leak = true,
            pun1_on = true,
            pun2_on = true,
            full_save = true,
            control_learning = false,
            experiment_limit = ls,
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
            wages = wg
            )
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])
 
 @JLD2.save("abmDatFull.jld2", abm_dat, S)

 


##################################################################
######  FULL MULTI GROUP WITH LEARNING FROM CONTROL ##############
@everywhere include("cpr/code/abm/abm_invpun.jl")

S =expand_grid( [150*9],         #Population Size
                [9],            #ngroups
                [[3, 3]],        #lattice, will be replaced below
                [.0001],         #travel cost
                [1],             #tech
                [.7],            #labor
                [1.5],             #limit seed values
                10 .^(collect(range(-5, stop =1, length = 6))),       #Punish Cost
                [210000*9],      #max forest
                [0.0001,.9],     #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [3],             #groups_sampled
                [1],             #Defensibility
                [0],             #var forest
                10 .^(collect(range(-3, stop = 1, length = 20))),          #price
                [.025],          #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-3, stop = 1, length = 20))),       #wages,
                [.5] # outgroup punishment experiment 
                )

S[:,11] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,11] = ifelse.(S[:,10].==.0001, .0001, .9)
S[:,20] = ifelse.(S[:,10].==.0001, .0001, .9)


# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 10,
            fines1_on = false,
            fines2_on = false,
            leak = true,
            pun1_on = true,
            pun2_on = true,
            full_save = true,
            control_learning = true,
            experiment_limit = ls,
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
            wages = wg
            )
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])
 
 @JLD2.save("abmDatFullLearning.jld2", abm_dat, S)

 

 

##################################################################
######  FULL MULTI GROUP WITH LEARNING FROM CONTROL ##############
@everywhere include("cpr/code/abm/abm_invpun.jl")

S =expand_grid( [150*9],         #Population Size
                [9],            #ngroups
                [[3, 3]],        #lattice, will be replaced below
                [.0001],         #travel cost
                [1],             #tech
                [.7],            #labor
                [1.5],             #limit seed values
                10 .^(collect(range(-5, stop =1, length = 6))),       #Punish Cost
                [210000*9],      #max forest
                [0.0001,.9],     #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [3],             #groups_sampled
                [1],             #Defensibility
                [0],             #var forest
                10 .^(collect(range(-3, stop = 1, length = 20))),          #price
                [.025],          #regrowth
                [[1, 1]],        #degrade
                10 .^(collect(range(-3, stop = 1, length = 20))),       #wages,
                [.5] # outgroup punishment experiment 
                )


# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 3,
            fines1_on = false,
            fines2_on = false,
            leak = true,
            pun1_on = true,
            pun2_on = true,
            full_save = true,
            control_learning = false,
            experiment_limit = ls,
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
            wages = wg
            )
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])
 
 @JLD2.save("abmDatFullPemnbajld2", abm_dat, S)

 