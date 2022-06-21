# LOAD Function 

include("cpr/code/abm/abm_group_policy.jl")

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


###########################################################
############## OSTROM SI GROUP SIZE #######################



S =expand_grid( collect(2:2:50), # Ngroups
                [150],           # Population size
                [210000],        # Max Forest
                [[1, 2]],        # lattice, will be replaced below
                [100]             # Nsim
                )

S[:,2] = S[:,2] .* S[:,1]
S[:,3] = S[:,3] .* S[:,1]
S[:,4] = [[2, Int(1 .*S[i,1]/2)] for i in 1:size(S)[1]]

# S[:,5]=S[:,5].*reverse(collect(2:2:20)*5)./10

# getOSY(labor = .7, wages = .007742636826811269, price = 0027825594022071257, tech = 1, max_forest = 1400*60,  regrow = .025, n = 60, ncores = 4)


@everywhere function g(ng, n, mf, l, ns) 
    cpr_abm(n = n, max_forest = mf, ngroups = ng, nsim = ns, nrounds = 10000,
    lattice = l, harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00220525196229018395, labor = .7, zero = true, leak = false, harvest_var_ind = 1, learn_type = "wealth", 
    travel_cost = 0.003, full_save = true, learn_group_policy = true, glearn_strat="wealth")
end

abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], Int.(S[:,5]))

#@JLD2.save("SI_n_groups.jld2", abm_dat, S)

using JLD2
@JLD2.load("Y:/eco_andrews/Projects/CPR/data/abm/SI_n_groups.jld2")



# This code just checks the raw frequnecy of the trait. 
out = []
for i in 1:length(abm_dat)
   ok=[mean(Float64.(abm_dat[i][:punish2][9000:10000, :, j]), dims = 1)  for j in 1:size(abm_dat[i][:limit])[3]]   
   push!(out, reduce(vcat, reduce(vcat, ok)))
end

a=scatter(fill(1, length(out[1])).+rand(length(out[1]))*.2 , out[1], label = false)
for i in 2:length(out)
    scatter!(fill(i, length(out[i])).+rand(length(out[i]))*.2, out[i], label = false)
end
a


# This code check the frequncy of limit if the mean of punish2 is over 0.1
out = []
for i in 1:length(abm_dat)
   ok=[mean(Float64.(abm_dat[i][:limit][9000:10000, :, j]), dims = 1)[mean(Float64.(abm_dat[i][:punish2][9000:10000, :, j]), dims = 1) .>.9]  for j in 1:size(abm_dat[i][:limit])[3]]   
   push!(out, reduce(vcat, reduce(vcat, ok)))
end

a=scatter(fill(1, length(out[1])).+rand(length(out[1]))*.2 , out[1], label = false)
for i in 2:length(out)
    scatter!(fill(i, length(out[i])).+rand(length(out[i]))*.2, out[i], label = false)
end
a
hline!([8.75, 8.75], label = "MAY at OSY")
limit = copy(a)

# This checks the stock level with the same constraint
out = []
for i in 1:length(abm_dat)
   ok=[mean(Float64.(abm_dat[i][:stock][9000:10000, :, j]), dims = 1)[mean(Float64.(abm_dat[i][:punish2][9000:10000, :, j]), dims = 1) .>.1]  for j in 1:size(abm_dat[i][:limit])[3]]   
   push!(out, reduce(vcat, reduce(vcat, ok)))
end

a=scatter(fill(1, length(out[1])).+rand(length(out[1]))*.2 , out[1], label = false)
for i in 2:length(out)
    scatter!(fill(i, length(out[i])).+rand(length(out[i]))*.2, out[i], label = false)
end
a
hline!([.509, .509], label = "stock at OSY")
stock = copy(a)


# This checks payoff

out = []
for i in 1:length(abm_dat)
   ok=[mean(Float64.(abm_dat[i][:payoffR][9000:10000, :, j]), dims = 1)  for j in 1:size(abm_dat[i][:limit])[3]]   
   push!(out, reduce(vcat, reduce(vcat, ok)))
end

a=scatter(fill(1, length(out[1])).+rand(length(out[1]))*.2 , out[1], label = false, c = :deepskyblue3)
for i in 2:length(out)
    scatter!(fill(i, length(out[i])).+rand(length(out[i]))*.2, out[i], label = false, c = :deepskyblue3)
end
a
hline!([0.0243, 0.0243], label = false, c =:firebrick)
u=[mean(out[i]) for i in 1:10]
μ = [u u][:,1]
ub = [mean(out[i])+std(out[i])*2 for i in 1:10]
lb = [mean(out[i])-std(out[i])*2 for i in 1:10]
PI=[ub lb]
plot!([μ μ],  fillrange=[PI[:,1] PI[:,2]], fillalpha=.3, c=:orange, label = false) 
a
plot!()
payoff = copy(a)




# This checks the ROI
out = []
for i in 1:length(abm_dat)
   ok=[(mean(Float64.(abm_dat[i][:harvest][9000:end, :, j]), dims = 1) ./ mean(Float64.(abm_dat[i][:effort][9000:10000, :, j]), dims = 1))[mean(Float64.(abm_dat[i][:punish2][9000:10000, :, j]), dims = 1) .>.1]  for j in 1:size(abm_dat[i][:limit])[3]]   
   push!(out, reduce(vcat, reduce(vcat, ok)))
end

a=scatter(fill(1, length(out[1])).+rand(length(out[1]))*.2 , out[1], label = false)
for i in 2:length(out)
    scatter!(fill(i, length(out[i])).+rand(length(out[i]))*.2, out[i], label = false)
end

hline!([8.75/.59, 8.75/.59], label = "ROI at OSY")

u=[mean(out[i]) for i in 1:10]
μ = [u u][:,1]
ub = [mean(out[i])+std(out[i])*2 for i in 1:10]
lb = [mean(out[i])-std(out[i])*2 for i in 1:10]
PI=[ub lb]
plot!([μ μ],  fillrange=[PI[:,1] PI[:,2]], fillalpha=.3, c=:orange, label = false) 
a
plot!()
payoff = copy(a)


# This checks the harvest
out = []
for i in 1:length(abm_dat)
   ok=[(mean(Float64.(abm_dat[i][:harvest][1000:end, :, j]), dims = 1))[mean(Float64.(abm_dat[i][:punish2][9000:10000, :, j]), dims = 1) .>.1]  for j in 1:size(abm_dat[i][:limit])[3]]   
   push!(out, reduce(vcat, reduce(vcat, ok)))
end

a=scatter(fill(1, length(out[1])).+rand(length(out[1]))*.2 , out[1], label = false, c = :deepskyblue3)
for i in 2:length(out)
    scatter!(fill(i, length(out[i])).+rand(length(out[i]))*.2, out[i], label = false, c = :deepskyblue3)
end
a
hline!([8.75, 8.75], label = "Harvest at OSY", c = :firebrick)

u=[mean(out[i]) for i in 1:10]
μ = [u u][:,1]
ub = [mean(out[i])+std(out[i])*2 for i in 1:10]
lb = [mean(out[i])-std(out[i])*2 for i in 1:10]
PI=[ub lb]
plot!([μ μ],  fillrange=[PI[:,1] PI[:,2]], fillalpha=.3, c=:orange, label = false) 
a
plot!()
payoff = copy(a)




#########################################################################
#################### OSTROM SI 1 ########################################

# Alternate bsm

# Sharing 

data_sharing =cpr_abm(n = 150*9, max_forest = 210000*9, ngroups = 9, nsim = 10, nrounds = 1000,
    lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true,
    travel_cost = 0.003, full_save = true, learn_group_policy = true, bsm = "collective")

data_indv =cpr_abm(n = 150*9, max_forest = 210000*9, ngroups = 9, nsim = 10, nrounds = 1000,
    lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true,
    travel_cost = 0.003, full_save = true, learn_group_policy = true, bsm = "individual")

data_buring =cpr_abm(n = 150*9, max_forest = 210000*9, ngroups = 9, nsim = 10, nrounds = 1000,
    lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = false,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true,
    travel_cost = 0.003, full_save = true, learn_group_policy = true, bsm = "individual")

data_fines =cpr_abm(n = 150*9, max_forest = 210000*9, ngroups = 9, nsim = 10, nrounds = 1000,
    lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = true, fines2_on = false, seized_on = false,
    punish_cost = 0.00650525196229018395, labor = .7, zero = true,
    travel_cost = 0.003, full_save = true, learn_group_policy = true, bsm = "individual")


[mean(data_indv[1][:stock][900:end, :, j], dims = 1)  for j in 1:size(data_indv[1][:limit])[3]]



data_indv =cpr_abm(n = 150*9, max_forest = 210000*9, ngroups = 9, nsim = 10, nrounds = 500,
    lattice = [3,3], harvest_limit = 8.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00320525196229018395, labor = .7, zero = true, harvest_var_ind = 1,  
    travel_cost = 0.003, full_save = true, learn_group_policy = true, bsm = "individual")


data_indv2 =cpr_abm(n = 150*9, max_forest = 210000*9, ngroups = 9, nsim = 10, nrounds = 500,
    lattice = [3,3], harvest_limit = 8.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00320525196229018395, labor = .7, zero = true, harvest_var_ind = .1,  
    travel_cost = 0.003, full_save = true, learn_group_policy = true, bsm = "individual")

data_indv3 =cpr_abm(n = 150*9, max_forest = 210000*9, ngroups = 9, nsim = 10, nrounds = 500,
    lattice = [3,3], harvest_limit = 8.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00320525196229018395, labor = .7, zero = true, harvest_var_ind = 2,  
    travel_cost = 0.003, full_save = true, learn_group_policy = true, bsm = "individual")


data_indv4 =cpr_abm(n = 150*9, max_forest = 210000*9, ngroups = 9, nsim = 10, nrounds = 500,
    lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00320525196229018395, labor = .7, zero = true, harvest_var_ind = .5,  
    travel_cost = 0.003, full_save = true, learn_group_policy = true, bsm = "individual")


data_indv11 =cpr_abm(n = 150*9, max_forest = 210000*9, ngroups = 9, nsim = 10, nrounds = 500,
    lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00320525196229018395, labor = .7, zero = true, harvest_var_ind = 1,  
    travel_cost = 0.003, full_save = true, learn_group_policy = true, bsm = "individual", leak = false)


data_indv12 =cpr_abm(n = 150*9, max_forest = 210000*9, ngroups = 9, nsim = 10, nrounds = 500,
    lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00320525196229018395, labor = .7, zero = true, harvest_var_ind = .1,  
    travel_cost = 0.003, full_save = true, learn_group_policy = true, bsm = "individual", leak = false)

data_indv13 =cpr_abm(n = 150*9, max_forest = 210000*9, ngroups = 9, nsim = 10, nrounds = 500,
    lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00320525196229018395, labor = .7, zero = true, harvest_var_ind = 2,  
    travel_cost = 0.003, full_save = true, learn_group_policy = true, bsm = "individual", leak = false)


data_indv14 =cpr_abm(n = 150*9, max_forest = 210000*9, ngroups = 9, nsim = 10, nrounds = 500,
    lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00320525196229018395, labor = .7, zero = true, harvest_var_ind = .5,  
    travel_cost = 0.003, full_save = true, learn_group_policy = true, bsm = "individual", leak = false)


##########################################################################################################
########################################## THIS MAY BE THE GOLDEN ONE ####################################



data_indv14 =cpr_abm(n = 150*9, max_forest = 210000*9, ngroups = 9, nsim = 1, nrounds = 1000,
    lattice = [3,3], harvest_limit = 9.75, regrow = .025, pun1_on = true, pun2_on = true, wages = 0.007742636826811269,
    price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00320525196229018395, labor = .7, zero = true, harvest_var_ind = 1,  
    travel_cost = 0.003, full_save = true, learn_group_policy = true, bsm = "individual", leak = false,
    experiment_punish2 = 1, experiment_group=collect(1:1:9), learn_type = "wealth", nmodels = 10,
    genetic_evolution = true,
    back_leak = true, control_learning = true)

plot(data_indv14[:limit][:,:,1], label = false)
mean(Float64.(data_indv14[:limit][9500:end,:,1]))
mean(Float64.(data_indv14[:harvest][9500:end,:,1]))
plot(data_indv14[:harvest][:,:,1], label = false)
mean(data_indv14[:harvest][:,:,1])
plot(data_indv14[:stock][:,:,1], label = false)

plot(data_indv14[:harvest][:,:,1], label = false, alpha = .2)

####################################### LOOK ABOVE ##############################################################




    plot(data_indv[:limit][400:end, :,5])


a=[mean(data_indv[:limit][400:end, :, j], dims = 1)  for j in 1:10]
b=[mean(data_indv2[:limit][400:end, :, j], dims = 1)  for j in 1:10]
c=[mean(data_indv3[:limit][400:end, :, j], dims = 1)  for j in 1:10]
d=[mean(data_indv4[:limit][400:end, :, j], dims = 1)  for j in 1:10]

e=[mean(data_indv14[:limit][400:end, :, j], dims = 1)  for j in 1:10]

mean(reduce(vcat, reduce(vcat, a)))
mean(reduce(vcat, reduce(vcat, b)))
mean(reduce(vcat, reduce(vcat, c)))
mean(reduce(vcat, reduce(vcat, d)))
mean(reduce(vcat, reduce(vcat, e)))