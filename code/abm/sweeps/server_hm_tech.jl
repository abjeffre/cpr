#####################################################
############## Heatmaps #############################

using(Distributed)
@everywhere using(Distributions)
@everywhere using(DataFrames)
@everywhere using(JLD2)
@everywhere using(Random)
@everywhere using(Dates)
@everywhere using(Statistics)

@everywhere include("setup_utilies.jl")
@everywhere include("abm_rewrite2.jl")



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
            nsim = 5,
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
 S[:,16], S[:,17], S[:,18], S[:,19])

@JLD2.save("leak_tech.jld2", abm_dat, S)


#
#
# #set up a smaller call function that allows for only a sub-set of pars to be manipulated
# @everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
#     cpr_abm(nrounds = 500,
#             nsim = 5,
#             fine_start = nothing,
#             leak = true,
#             pun1_on = false,
#             pun2_on = false,
#             experiment_effort = 1,
#             n = n,
#             ngroups = ng,
#             lattice = l,
#             travel_cost = tc,
#             tech = te,
#             labor = la,
#             harvest_limit = ls,
#             punish_cost = pc,
#             max_forest = mf,
#             experiment_leak = el,
#             experiment_punish1 = ep,
#             experiment_punish2 = ep,
#             experiment_group = eg,
#             groups_sampled =gs,
#             defensibility = df,
#             var_forest = vf,
#             price = pr,
#             regrow = rg,
#             degrade=dg,
#             wages = wg
#
#             )
# end
#
#
# abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
#  S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
#  S[:,16], S[:,17], S[:,18], S[:,19])
#
# @JLD2.save("abm_dat_effort_hm_leak.jld2", abm_dat, S)
#
#
#
#
#
# #set up a smaller call function that allows for only a sub-set of pars to be manipulated
# @everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
#     cpr_abm(nrounds = 500,
#             nsim = 5,
#             fine_start = nothing,
#             leak = true,
#             experiment_effort = 1,
#             pun1_on = true,
#             pun2_on = false,
#             n = n,
#             ngroups = ng,
#             lattice = l,
#             travel_cost = tc,
#             tech = te,
#             labor = la,
#             harvest_limit = ls,
#             punish_cost = pc,
#             max_forest = mf,
#             experiment_leak = el,
#             experiment_punish1 = ep,
#             experiment_punish2 = ep,
#             experiment_group = eg,
#             groups_sampled =gs,
#             defensibility = df,
#             var_forest = vf,
#             price = pr,
#             regrow = rg,
#             degrade=dg,
#             wages = wg
#
#             )
# end
#
#
# abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
#  S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
#  S[:,16], S[:,17], S[:,18], S[:,19])
#
# @JLD2.save("abm_dat_effort_hm_leakp1.jld2", abm_dat, S)
#
#
#
#
# #set up a smaller call function that allows for only a sub-set of pars to be manipulated
# @everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
#     cpr_abm(nrounds = 500,
#             nsim = 5,
#             fine_start = nothing,
#             leak = true,
#             pun1_on = true,
#             pun2_on = true,
#             experiment_effort = 1,
#             n = n,
#             ngroups = ng,
#             lattice = l,
#             travel_cost = tc,
#             tech = te,
#             labor = la,
#             harvest_limit = ls,
#             punish_cost = pc,
#             max_forest = mf,
#             experiment_leak = el,
#             experiment_punish1 = ep,
#             experiment_punish2 = ep,
#             experiment_group = eg,
#             groups_sampled =gs,
#             defensibility = df,
#             var_forest = vf,
#             price = pr,
#             regrow = rg,
#             degrade=dg,
#             wages = wg
#
#             )
# end
#
#
# abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
#  S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
#  S[:,16], S[:,17], S[:,18], S[:,19])
#
# @JLD2.save("abm_dat_effort_hm_leakp1p2.jld2", abm_dat, S)
