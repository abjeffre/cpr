######################################################################################### 
############### DRIVERS OF LEAKAGE ######################################################

########################## HETEROGENITY IN PATCH SIZE #######################################
a=cpr_abm(n = 150*2, max_forest = 2*410000, ngroups =2, nsim = 1, nrounds = 1000,
lattice = [1,2], harvest_limit = 16.168, regrow = .025, pun1_on = false, pun2_on = false, wages = 0.007742636826811269,
 price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
punish_cost = 0.00650525196229018395, labor = .7, zero = true,
travel_cost = 0.003, full_save = true, kmax_data = [410000, 210000],
learn_group_policy = true)


seq = collect(210000:10000:640000)

out = []
for i in seq
    b=cpr_abm(n = 150*2, max_forest = 2*410000, ngroups =2, nsim = 1, nrounds = 1000,
    lattice = [1,2], harvest_limit = 16.168, regrow = .025, pun1_on = false, pun2_on = false, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true,
    travel_cost = 0.003, full_save = true, kmax_data = [i, 210000],
    learn_group_policy = true)
    push!(out, b)
end


plot(a[:leakage][:,:,1])
plot(b[:leakage][:,:,1])

leakage=[mean(out[i][:leakage][:,2,1]) for i in 1:length(out)]
heterogenity=scatter(seq, leakage, label = false, xlab = "Heterogenity in patch size", ylab = "Roving Banditry", c = :firebrick)
xticks!([minimum(seq), maximum(seq)], ["High", "Low"])
######################### STRINGENT POLICIES #############################

out2 = []
seq = collect(1:1:20)
for i in seq
    b=cpr_abm(n = 150*2, max_forest = 2*410000, ngroups =2, nsim = 1, nrounds = 500,
    lattice = [1,2], harvest_limit = 16.168, regrow = .025, pun1_on = false, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, 
    travel_cost = 0.003, full_save = true, kmax_data = [210000, 210000], 
    experiment_limit = i, experiment_effort = 1, 
    learn_group_policy = true)
    push!(out2, b)
end

leakage2=[mean(out2[i][:leakage][:,1,1]) for i in 1:length(out2)]

heterogenity=scatter(20 .-seq, leakage2, label = false, xlab = "Policy Stringency", ylab = "Roving Banditry")


######################## TRAVEL COSTS #########################################

out3 = []
seq = collect(0.00001:0.00002:0.001)
for i in seq
    b=cpr_abm(n = 150*2, max_forest = 2*410000, ngroups =2, nsim = 1, nrounds = 500,
    lattice = [1,2], harvest_limit = 16.168, regrow = .025, pun1_on = false, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true, 
    travel_cost = i, full_save = true, kmax_data = [210000, 210000], 
    learn_group_policy = true)
    push!(out3, b)
end

leakage3=[mean(out3[i][:leakage][250:500,2,1]) for i in 1:length(out3)]
travel_costs=scatter(seq, leakage3, label = false, xlab = "TRAVEL COST", ylab = "Roving Banditry")


