# LOAD Function 

include("cpr/code/abm/abm_group_policy.jl")


###################################################################
############### Figure 1 ##########################################
using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
using ColorSchemes
using Distributed
using DataFrames
using Serialization
using Distributed

######################## TRAVEL COSTS #########################################

# Note here we increase the forest size to ensure it does collapse and is sustainaed at some non-zero equilibria
out3 = []
seq = collect(10:1:25)
for i in seq
    b=cpr_abm(n = 75*2, max_forest = 2*201000, ngroups =2, nsim = 1, nrounds = 500,
    lattice = [1,2], harvest_limit = 7.5, regrow = .025, pun1_on = false, pun2_on = true, wages = 0.1,
    price = 1, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.1, labor = .7, zero = true, 
    travel_cost = i, full_save = true, 
    learn_group_policy = true)
    push!(out3, b)
    println(i)
end

leakage3=[mean(out3[i][:leakage][250:500,2,1]) for i in 1:length(out3)]
travel_costs=plot(seq, leakage3,  label = false, xlab = "Travel Costs", ylab = "Roving Banditry", c = :black)
xticks!([minimum(seq), maximum(seq)], ["Low", "High"], ylim = (0, 1))

savefig(travel_costs, "SI2f1.pdf")



#########################################################################
#################### OSTROM SI 1 ########################################

# Alternate bsm

# Sharing 

data_sharing =cpr_abm(n = 75*9, max_forest = 105000*9, ngroups = 9, nsim = 10, nrounds = 1000,
    lattice = [3,3], harvest_limit = 3.0, regrow = .01, pun1_on = true, pun2_on = true, wages = 0.1,
    price = 1, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.1, labor = .7, zero = true,
    travel_cost = 0.1, full_save = true, learn_group_policy = true, bsm = "collective")


sharing =plot(data_sharing[:punish][1:500,:,1], label = "", xlab = "Time", , ylim = (0, 1), ylab = "Support for Borders", c = :black, alpha = .1, title = "(a)", titlelocation = :left, titlefontsize = 15)
    [plot!(data_sharing[:punish][1:500,:,i], label = "", xlab = "Time", ylab = "Support for Borders", c = :black, alpha = .1) for i in 2:10]
    


data_self =cpr_abm(n = 75*9, max_forest = 105000*9, ngroups = 9, nsim = 10, nrounds = 1000,
    lattice = [3,3], harvest_limit = 3.0, regrow = .01, pun1_on = true, pun2_on = true, wages = 0.1,
    price = 1, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.1, labor = .7, zero = true,
    travel_cost = 0.1, full_save = true, learn_group_policy = true, bsm = "individual")

wages =plot(data_self[:punish][1:500,:,1], label = "", xlab = "Time", ylim = (0, 1), ylab = "Support for Borders", c = :black, alpha = .1, title = "(b)", titlelocation = :left, titlefontsize = 15)
    [plot!(data_self[:punish][1:500,:,i], label = "", xlab = "Time", ylab = "Support for Borders", c = :black, alpha = .1) for i in 2:10]


SI2F2 = plot(sharing, wages , size = (800, 400), left_margin = 35px, bottom_margin = 35px, top_margin = 10px, right_margin = 20px)


savefig(SI2F2, "SI2f2.pdf")

