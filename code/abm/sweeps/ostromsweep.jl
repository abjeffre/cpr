

using(Distributed)
@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD2)
@everywhere using(Random)
@everywhere using(Dates)
@everywhere using(Statistics)
@everywhere include("cpr/code/abm/setup_utilies.jl")
@everywhere include("cpr/code/abm/abm_invpun.jl")


S =expand_grid( [150*9],                                                #Population Size
                [9],                                                    #ngroups
                [[3, 3]],                                               #lattice, will be replaced below
                10 .^(collect(range(-5, stop =1, length = 3))),         #travel cost
                10 .^(collect(range(-5, stop =1, length = 3))),         #Punish Cost
                collect(range(.1, stop =2, length = 4)),                #Defensibility
                10 .^(collect(range(-3, stop = 1, length = 10))),       #price
                10 .^(collect(range(-3, stop = 1, length = 10))),       #wages,
                [0.5, 1, 1.5],   #tech
                [210000*9],      #max forest
                [.7],            #labor
                [1.5],           #limit seed values
                [.025],          #regrowth
                [[1, 1] [2,.9]], #degrade
                )


# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, pc, df, p, w, t, mf, lb, sv, rg, dg )
    cpr_abm(nrounds = 500,
            nsim = 5,
            fines1_on = false,
            fines2_on = false,
            leak = true,
            pun1_on = true,
            pun2_on = true,
            full_save = true,
            control_learning = false,
            harvest_var = 1,
            n = n,
            ngroups = ng,
            lattice = l,
            travel_cost = tc,
            tech = t,
            labor = lb,
            harvest_limit = sv,
            punish_cost = pc,
            max_forest = mf,
            groups_sampled =3,
            defensibility = df,
            var_forest = 0,
            price = p,
            regrow = rg,
            degrade=dg,
            wages = w
            )
end


abm_dat = pmap(g, S[1:2,1], S[1:2,2], S[1:2,3], S[1:2,4], S[1:2,5], S[1:2,6], S[1:2,7],
 S[1:2,8], S[1:2,9], S[1:2,10] , S[1:2,11], S[1:2,12] , S[1:2,13],  S[1:2,14])
 
 @JLD2.save("abmDatFull.jld2", abm_dat, S)



######################################################################
################# LEAKAGE TRAVEL #####################################

S =expand_grid( [150*9],                                                #Population Size
                [9],                                                    #ngroups
                [[3, 3]],                                               #lattice, will be replaced below
                [.1],         #travel cost
                [.1],         #Punish Cost
                [1],                #Defensibility
                [.06],       #price
                [1.3],       #wages,
                [1],   #tech
                [210000*9],      #max forest
                [.7],            #labor
                [1.5],           #limit seed values
                [.025],          #regrowth
                [[1, 1]],   #degrade
                collect(range(0, stop=1, length = 10))
                )


# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, pc, df, p, w, t, mf, lb, sv, rg, dg, el )
    cpr_abm(nrounds = 500,
            nsim = 5,
            fines1_on = false,
            fines2_on = false,
            leak = true,
            pun1_on = true,
            pun2_on = true,
            full_save = true,
            control_learning = false,
            harvest_var = 0,
            n = n,
            ngroups = ng,
            lattice = l,
            travel_cost = 0.0,
            tech = 1,
            labor = .7,
            harvest_limit = 1.5,
            punish_cost = .1,
            max_forest = mf,
            groups_sampled =3,
            defensibility = 1,
            var_forest = 0,
            price = .06,
            regrow = .025,
            degrade=[1,1],
            wages = 1.3,
            experiment_leak = el,
            experiment_effort =1,
            experiment_group =1
            )
end


abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13], S[:,14],  S[:,15])
 
 @JLD2.save("ostromleak.jld2", abm_dat, S)
