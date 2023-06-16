# using Plots.PlotMeasures

# out = []
# ngroups =2
# for i in 0.5:.5:15
#     c = cpr_abm(degrade = 1, n=100*ngroups, ngroups = ngroups, lattice = [1,2],
#         max_forest = 100000*ngroups, tech = .00001, wages = 1, price = 3, nrounds = 1000, leak = false,
#          learn_group_policy =false, invasion = false, nsim = 1, experiment_punish2 =1, experiment_limit = i,
#         experiment_group = collect(1:ngroups), control_learning = false, back_leak = true, outgroup = .0,
#         full_save = true, genetic_evolution = false, glearn_strat = "income",
#         )
#     push!(out, c)
# end


# pay=[out[i][:payoffR][end,1,1] for i in 1:length(out)]
# limit=[out[i][:limit][end,1,1] for i in 1:length(out)]
# Threshold=plot(limit, pay, xlab = "MAH", ylab = "Payoff", c =:black, label = "")
# vline!([3.33, 3.33], title = "(l)", titlelocation = :left, titlefontsize = 15, grid = false)
