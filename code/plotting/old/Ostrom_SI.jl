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

# Note here we increase the forest size to ensure it does collapse and is sustainaed at some non-invasion equilibria
out3 = []
seq = collect(10:1:25)
for i in seq
    b=cpr_abm(n = 75*2, max_forest = 2*201000, ngroups =2, nsim = 1, nrounds = 500,
    lattice = [1,2], harvest_limit = 7.5, regrow = .025, pun1_on = false, pun2_on = true, wages = 0.1,
    price = 1, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.1, labor = .7, invasion = true, 
    travel_cost = i, full_save = true, 
    learn_group_policy = true)
    push!(out3, b)
    println(i)
end

leakage3=[mean(out3[i][:leakage][250:500,2,1]) for i in 1:length(out3)]




#########################################################################
#################### OSTROM SI 1 ########################################

# Alternate bsm

# Sharing 

data_sharing =cpr_abm(n = 75*9, max_forest = 105000*9, ngroups = 9, nsim = 10, nrounds = 1000,
    lattice = [3,3], harvest_limit = 3.0, regrow = .01, pun1_on = true, pun2_on = true, wages = 0.1,
    price = 1, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.1, labor = .7, invasion = true,
    travel_cost = 0.1, full_save = true, learn_group_policy = true, bsm = "collective")


sharing =plot(data_sharing[:punish][1:500,:,1], label = "", xlab = "Time", ylim = (0, 1), ylab = "Support for Borders", c = :black, alpha = .1, title = "(a)", titlelocation = :left, titlefontsize = 15)
[plot!(data_sharing[:punish][1:500,:,i], label = "", xlab = "Time", ylab = "Support for Borders", c = :black, alpha = .1) for i in 2:10]
    


data_self =cpr_abm(n = 75*9, max_forest = 105000*9, ngroups = 9, nsim = 10, nrounds = 1000,
    lattice = [3,3], harvest_limit = 3.0, regrow = .01, pun1_on = true, pun2_on = true, wages = 0.1,
    price = 1, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.1, labor = .7, invasion = true,
    travel_cost = 0.1, full_save = true, learn_group_policy = true, bsm = "individual")

wages =plot(data_self[:punish][1:500,:,1], label = "", xlab = "Time", ylim = (0, 1), ylab = "Support for Borders", c = :black, alpha = .1, title = "(b)", titlelocation = :left, titlefontsize = 15)
    [plot!(data_self[:punish][1:500,:,i], label = "", xlab = "Time", ylab = "Support for Borders", c = :black, alpha = .1) for i in 2:10]


SI2F2 = plot(sharing, wages , size = (800, 400), left_margin = 35px, bottom_margin = 35px, top_margin = 10px, right_margin = 20px)


savefig(SI2F2, "SI2f2.pdf")










# travel_costs=scatter(seq, leakage3, label = false, xlab = "TRAVEL COST", ylab = "Roving Banditry")


# ###########################################################
# ############## OSTROM SI GROUP SIZE #######################



# S =expand_grid( collect(2:1:16), # Ngroups
#                 [150],           # Population size
#                 [210000],        # Max Forest
#                 [[1, 2]],        # lattice, will be replaced below
#                 [100],             # Nsim
#                 [1])

# S[:,2] = S[:,2] .* S[:,1]
# S[:,3] = S[:,3] .* S[:,1]
# S[:,4] = [[1, S[i,1]] for i in 1:size(S)[1]]
# S[:,5] = [collect(1:1:S[i,1]) for i in 1:size(S)[1]]

# # S[:,5]=S[:,5].*reverse(collect(2:2:20)*5)./10

# # getOSY(labor = .7, wages = .007742636826811269, price = 0027825594022071257, tech = 1, max_forest = 1400*60,  regrow = .025, n = 60, ncores = 4)


# @everywhere function g(ng, n, mf, l, eg) 
#     cpr_abm(n = n, max_forest = mf, ngroups = ng, nsim = 100, nrounds = 10000,
#     lattice = l, harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
#     price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
#     punish_cost = 0.00220525196229018395, labor = .7, invasion = true, leak = false, harvest_var_ind = 1, learn_type = "wealth", 
#     travel_cost = 0.003, full_save = true, learn_group_policy = true, experiment_group = eg, experiment_punish2 =1, control_learning = true)
# end

# abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5])

# #@JLD2.save("SI_n_groups.jld2", abm_dat, S)
# using Pkg
# Pkg.add("JLD2")
# using JLD2

# file = jldopen("C:/users/jeffr/Documents/Work/cpr/data/abm/SI_n_groups.jld2", "abm_dat")
# @JLD2.load("Y:/eco_andrews/Projects/CPR/data/abm/SI_n_groups.jld2")
# using FileIO
# load("C:/users/jeffr/Documents/Work/cpr/data/abm/SI_n_groups.jld2")

# using Serialization
# abm_dat=deserialize("C:/users/jeffr/Documents/Work/cpr/data/abm/test.dat")



# # This code just checks the raw frequnecy of the trait. 
# out = []
# for i in 1:length(abm_dat)
#    ok=[mean(Float64.(abm_dat[i][:limit][9000:10000, :, j]), dims = 1)  for j in 1:size(abm_dat[i][:limit])[3]]   
#    push!(out, reduce(vcat, reduce(vcat, ok)))
# end

# a=scatter(fill(1, length(out[1])).+rand(length(out[1]))*.2 , out[1], label = false)
# for i in 2:length(out)
#     scatter!(fill(i, length(out[i])).+rand(length(out[i]))*.2, out[i], label = false)
# end
# a


# # This code check the frequncy of limit if the mean of punish2 is over 0.1
# out = []
# for i in 1:length(abm_dat)
#    ok=[mean(Float64.(abm_dat[i][:limit][9000:10000, :, j]), dims = 1)[mean(Float64.(abm_dat[i][:punish2][9000:10000, :, j]), dims = 1) .>.9]  for j in 1:size(abm_dat[i][:limit])[3]]   
#    push!(out, reduce(vcat, reduce(vcat, ok)))
# end

# a=scatter(fill(1, length(out[1])).+rand(length(out[1]))*.2 , out[1], label = false)
# for i in 2:length(out)
#     scatter!(fill(i, length(out[i])).+rand(length(out[i]))*.2, out[i], label = false)
# end
# a
# hline!([8.75, 8.75], label = "MAY at OSY")
# limit = copy(a)

# # This checks the stock level with the same constraint
# out = []
# for i in 1:length(abm_dat)
#    ok=[mean(Float64.(abm_dat[i][:stock][9000:10000, :, j]), dims = 1)[mean(Float64.(abm_dat[i][:punish2][9000:10000, :, j]), dims = 1) .>.1]  for j in 1:size(abm_dat[i][:limit])[3]]   
#    push!(out, reduce(vcat, reduce(vcat, ok)))
# end

# a=scatter(fill(1, length(out[1])).+rand(length(out[1]))*.2 , out[1], label = false)
# for i in 2:length(out)
#     scatter!(fill(i, length(out[i])).+rand(length(out[i]))*.2, out[i], label = false)
# end
# a
# hline!([.509, .509], label = "stock at OSY")
# stock = copy(a)


# # This checks payoff

# out = []
# for i in 1:length(abm_dat)
#    ok=[mean(Float64.(abm_dat[i][:payoffR][9000:10000, :, j]), dims = 1)  for j in 1:size(abm_dat[i][:limit])[3]]   
#    push!(out, reduce(vcat, reduce(vcat, ok)))
# end

# a=scatter(fill(1, length(out[1])).+rand(length(out[1]))*.2 , out[1], label = false, c = :deepskyblue3)
# for i in 2:length(out)
#     scatter!(fill(i, length(out[i])).+rand(length(out[i]))*.2, out[i], label = false, c = :deepskyblue3)
# end
# a
# hline!([0.0243, 0.0243], label = false, c =:firebrick)
# u=[mean(out[i]) for i in 1:10]
# μ = [u u][:,1]
# ub = [mean(out[i])+std(out[i])*2 for i in 1:10]
# lb = [mean(out[i])-std(out[i])*2 for i in 1:10]
# PI=[ub lb]
# plot!([μ μ],  fillrange=[PI[:,1] PI[:,2]], fillalpha=.3, c=:orange, label = false) 
# a
# plot!()
# payoff = copy(a)




# # This checks the ROI
# out = []
# for i in 1:length(abm_dat)
#    ok=[(mean(Float64.(abm_dat[i][:harvest][9000:end, :, j]), dims = 1) ./ mean(Float64.(abm_dat[i][:effort][9000:10000, :, j]), dims = 1))[mean(Float64.(abm_dat[i][:punish2][9000:10000, :, j]), dims = 1) .>.1]  for j in 1:size(abm_dat[i][:limit])[3]]   
#    push!(out, reduce(vcat, reduce(vcat, ok)))
# end

# a=scatter(fill(1, length(out[1])).+rand(length(out[1]))*.2 , out[1], label = false)
# for i in 2:length(out)
#     scatter!(fill(i, length(out[i])).+rand(length(out[i]))*.2, out[i], label = false)
# end

# hline!([8.75/.59, 8.75/.59], label = "ROI at OSY")

# u=[mean(out[i]) for i in 1:10]
# μ = [u u][:,1]
# ub = [mean(out[i])+std(out[i])*2 for i in 1:10]
# lb = [mean(out[i])-std(out[i])*2 for i in 1:10]
# PI=[ub lb]
# plot!([μ μ],  fillrange=[PI[:,1] PI[:,2]], fillalpha=.3, c=:orange, label = false) 
# a
# plot!()
# payoff = copy(a)


# # This checks the harvest
# out = []
# for i in 1:length(abm_dat)
#    ok=[(mean(Float64.(abm_dat[i][:harvest][1000:end, :, j]), dims = 1))[mean(Float64.(abm_dat[i][:punish2][9000:10000, :, j]), dims = 1) .>.1]  for j in 1:size(abm_dat[i][:limit])[3]]   
#    push!(out, reduce(vcat, reduce(vcat, ok)))
# end

# a=scatter(fill(1, length(out[1])).+rand(length(out[1]))*.2 , out[1], label = false, c = :deepskyblue3)
# for i in 2:length(out)
#     scatter!(fill(i, length(out[i])).+rand(length(out[i]))*.2, out[i], label = false, c = :deepskyblue3)
# end
# a
# hline!([8.75, 8.75], label = "Harvest at OSY", c = :firebrick)

# u=[mean(out[i]) for i in 1:10]
# μ = [u u][:,1]
# ub = [mean(out[i])+std(out[i])*2 for i in 1:10]
# lb = [mean(out[i])-std(out[i])*2 for i in 1:10]
# PI=[ub lb]
# plot!([μ μ],  fillrange=[PI[:,1] PI[:,2]], fillalpha=.3, c=:orange, label = false) 
# a
# plot!()
# payoff = copy(a)

# travel_costs=plot(seq, leakage3,  label = false, xlab = "Travel Costs", ylab = "Roving Banditry", c = :black)
# xticks!([minimum(seq), maximum(seq)], ["Low", "High"], ylim = (0, 1))

# savefig(travel_costs, "SI2f1.pdf")
