
using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
using ColorSchemes
using Distributed
cd("C:\\Users\\jeffr\\Documents\\Work\\")


###########



################# Brute force a solution
pay = []
stock = []

cd("C:\\Users\\jeffr\\Documents\\Work\\")

@everywhere include("C:\\Users\\jeffr\\Documents\\Work\\cpr\\code\\abm\\abm_invpun.jl")
@everywhere include("C:\\Users\\jeffr\\Documents\\Work\\functions\\utility.jl")

S=collect(0.0:0.05:1.0)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 300, ngroups = 2, lattice = (1,2), max_forest = 1400*300, regrow = 0.025,
    leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01, 
    wages = 1.3, price = .06, fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
    nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_effort = L, compress_data = false)
  end
msy=pmap(g, S)

a=[mean(msy[i][:payoffR][700:end,1,1]) for i in 1:length(msy)]
i=findmax(a)[2]
lim=msy[i][:harvest][end,1,1]




S=collect(0:.02:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 150*2, max_forest = 2*210000, ngroups =2, nsim = 100,
    lattice = [1,2], harvest_limit = 4.8, regrow = .025, pun2_on = false, leak=false,
    wages = 1.3, price = .06, defensibility = 1, experiment_leak = L, experiment_effort =1, fines1_on = false, punish_cost = 0.001, labor = .7, zero = true)
end
dat=pmap(g, S)
#@JLD2.save("brute.jld2", dat)

@JLD2.load("cpr\\data\\abm\\brute.jld2")

y = [mean(dat[i][:punish][100:end,2,:], dims =1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = mean(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 10)

mean(y)
border=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Resource competition", ylab = "Support for borders",
xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)


z = [mean(dat[i][:stock][:,2,:], dims =1) for i in 1:length(d)]
a=reduce(vcat, y[2:51])



################################################################################################################################################
########################### SUPPORT FOR REGULATION #############################################################################################

########## FIND WHERE THE DIFFRENCE IS THE LARGEST
diff = findmax(osyp./ncsh)
par=L[diff[2],:]
lim=osy[diff[2]]

S=collect(0:.02:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 5,
    lattice = [3,3], harvest_limit = 8.259, regrow = .025, pun1_on = true, 
    wages = 0.007742636826811269, price = 0.0027825594022071257, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = true,
    punish_cost = 0.00010525196229018395, labor = .7, zero = true, experiment_punish1 = L,  travel_cost = 0,
    experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true, full_save = true)
end
dat=pmap(g, S)
#@JLD2.save("brute2.jld2", dat)


#####################################################################################################################################################
############################ CHECK WITHOUT SEIZURES #################################################################################################

S=collect(0:.02:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 5,
    lattice = [3,3], harvest_limit = 4.8, regrow = .025, pun1_on = true, 
    wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, seized_on = false,
    punish_cost = 0.0001, labor = .7, zero = true, experiment_punish1 = L,  travel_cost = 0,
    experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true, full_save = true)
end
dat2=pmap(g, S)
#@JLD2.save("brute2.jld2", dat)








@JLD2.load("cpr\\data\\abm\\brute2.jld2")

y = [median(median(dat[i][:punish2][100:end,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)

mean(y)
self=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "Support for self-regulation", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



plot(border, self, size = (1300/2, 600/2), bottom_margin = 20px, left_margin = 20px)
png("cpr//output//ostromfirstprinciple.png")









#####################################################
################ LIMIT ##############################



@JLD2.load("cpr\\data\\abm\\brute2.jld2")

y = [mean(mean(dat[i][:limit][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = std(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)

limitvar=plot(μ, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "Std(MAH)", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))


y = [mean(mean(dat[i][:limit][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = mean(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)


mean(y)
limit=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "MAH", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
 hline!([4.5], label = false)
# scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)





#########################################################################
################ PAYOFF##################################################


y = [mean(mean(dat[i][:payoffR][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = mean(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)


mean(y)
payoff=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "Payoff", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)

#########################################################################
################ Leakage##################################################


y = [mean(mean(dat[i][:leakage][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = mean(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)


mean(y)
leakage=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "leakage", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



###########################################################
########## PUNISH 2 #######################################

y = [mean(mean(dat[i][:punish2][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)


mean(y)
Punish=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "Punish2", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)




###########################################################
########## EFFORT #########################################

y = [mean(mean(dat[i][:effort][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)


mean(y)
Effort=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "Effort", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)


###########################################################
########## Harvest #########################################

y = [mean(mean(dat[i][:harvest][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)


mean(y)
Harvest=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "Harvest", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)
hline!([4.8])


###########################################################
########## Stock #########################################

y = [mean(mean(dat[i][:stock][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)


mean(y)
Stock=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "stock", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



plot(Stock, Effort, Harvest, Punish, payoff, limit, limitvar, leakage)





###########################################################
########## Seizure #########################################

y = [mean(mean(dat[i][:seized][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])./150
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)


mean(y)
Seized=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "stock", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



plot(Stock, Effort, Harvest, Punish, payoff, limit, limitvar, leakage, Seized)


###########################################################
########## Stock #########################################

y = [mean(mean(dat[i][:harvest][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a1=reduce(vcat, y[2:51])
μ1 = median(a1, dims = 2)

y = [mean(mean(dat[i][:limit][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a2=reduce(vcat, y[2:51])
μ2 = median(a2, dims = 2)

a=a1 .- a2

PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)


plot(μ1- μ2)

mean(y)
Stock=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "stock", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



plot(Stock, Effort, Harvest, Punish, payoff, limit, limitvar, leakage)



###########################################################
########## CLP2 #########################################

y = [mean(mean(dat[i][:clp2][400:500,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)


mean(y)
Stock=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "CLP2", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)





######################################################################################
######################## SUPPORT FOR REGULATION VARIANCE #############################
S=collect(0:.02:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 50,
    lattice = [3,3], harvest_limit = 4.8, regrow = .025, pun1_on = true, 
    wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
    punish_cost = 0.01, labor = .7, zero = true, experiment_punish1 = L, 
    experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true, )
end
dat=pmap(g, S)
#@JLD2.save("brute2.jld2", dat)








##############################################################################################
############################ SET TRAVEL COST #################################################


S=collect(0:.02:1)
@everywhere function g(L)
    cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 20,
    lattice = [3,3], harvest_limit = 4.8, regrow = .025, pun1_on = true, 
    wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
    punish_cost = 0.01, labor = .7, zero = true, experiment_punish1 = L, travel_cost = 0.001,
    experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true)
end

dat=pmap(g, S)
@JLD2.save("brute3.jld2", dat)
#@JLD2.save("brute2.jld2", dat)
@JLD2.load("cpr\\data\\abm\\brute3.jld2")


y = [median(median(dat[i][:punish2][100:end,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)

mean(y)
self=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Presence of borders",
 ylab = "Support for self-regulation", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



##############################################################################################
############################ VARIANCE        #################################################


S=collect(.01:.02:1)*100000
S = [0; S]
@everywhere function g(L)
    cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10,
    lattice = [3,3], harvest_limit = 4.8, regrow = .025, pun1_on = false, pun2_on = false,
    var_forest = L, 
    wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
    punish_cost = 0.01, labor = .7, zero = true, travel_cost = 0.01, back_leak = true, control_learning = true, groups_sampled = 6)
end

dat=pmap(g, S)
@JLD2.save("brute4.jld2", dat)
#@JLD2.save("brute2.jld2", dat)
@JLD2.load("cpr\\data\\abm\\brute4.jld2")



y = [median(median(dat[i][:leakage][1:end,:,:], dims =2)[:,1,:], dims = 1) for i in 1:length(dat)]
a=reduce(vcat, y[2:51])
μ = median(a, dims = 2)
PI = [quantile(a[i,:], [0.31,.68]) for i in 1:size(a)[1]]
PI=vecvec_to_matrix(PI) 
y=reduce(vcat, a)
x=collect(.02:.02:1)
x=repeat(x, 50)

mean(y)
leak=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:orange, label = false, xlab = "Variance",
 ylab = "Leakage", xticks = (collect(0:10:50), ("0", "0.2", "0.4", "0.6", "0.8", "1")))
scatter!(x.*50, y, c=:firebrick, alpha = .2, label = false)



#############################################################################################
###################### TIME SERISE ##########################################################

plot(mean(mean(dat[2][:punish2][:,:,:], dims = 2), dims = 3)[:,:,1], ylim = (0, 1))
plot!(mean(mean(dat[2][:stock][:,:,:], dims = 2), dims = 3)[:,:,1], ylim = (0, 1))
plot!(mean(mean(dat[2][:leakage][:,:,:], dims = 2), dims = 3)[:,:,1], ylim = (0, 1))


plot(mean(mean(dat[27][:punish2][:,:,:], dims = 2), dims = 3)[:,:,1], ylim = (0, 1))
plot!(mean(mean(dat[27][:stock][:,:,:], dims = 2), dims = 3)[:,:,1], ylim = (0, 1))
plot!(mean(mean(dat[27][:leakage][:,:,:], dims = 2), dims = 3)[:,:,1], ylim = (0, 1))


tempa=cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 1,
lattice = [3,3], harvest_limit = 4.8, regrow = .025, pun1_on = true, 
wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
punish_cost = 0.01, labor = .7, zero = true, experiment_punish1 = .1, 
experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true)


tempb =   cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 1,
lattice = [3,3], harvest_limit = 4.8, regrow = .025, pun1_on = true, 
wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
punish_cost = 0.01, labor = .7, zero = true, experiment_punish1 = .55, 
experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true)

plot(tempb[:punish2][:,:,1])






tempb =   cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10,
lattice = [3,3], harvest_limit = 6, regrow = .025, pun1_on = true, harvest_var = 2.5,
wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
punish_cost = 0.01, labor = .7, zero = true, experiment_punish1 = 0.02, 
experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true, full_save = true)



plot(mean(mean(tempb[:punish2][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
plot(mean(mean(tempb[:limit][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 8))
plot(mean(mean(tempb[:vl][:,:,:], dims = 3), dims = 2)[:,:,1])
plot(mean(mean(tempb[:stock][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
plot(mean(mean(tempb[:payoffR][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 2))



t1 =   cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 10, nrounds = 1000,
lattice = [3,3], harvest_limit = 4, regrow = .01, pun1_on = true,
wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
punish_cost = 0.01, labor = .7, zero = true, experiment_punish1 = 0.02, 
experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true, full_save = true)



plot(mean(mean(t1[:punish2][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
plot(mean(mean(t1[:limit][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 8))
plot(mean(mean(t1[:vl][:,:,:], dims = 3), dims = 2)[:,:,1])
plot(mean(mean(t1[:stock][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
plot(mean(mean(t1[:payoffR][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 2))
plot(mean(mean(t1[:effort][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))



t2 =   cpr_abm(n = 75*36, max_forest = 36*210000, ngroups =36, nsim = 5, nrounds = 1000,
lattice = [6,6], harvest_limit = 6, regrow = .025, pun1_on = true, harvest_var = 3,
wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
punish_cost = 0.01, labor = .7, zero = true, back_leak = false, control_learning = false, full_save = true)



plot(mean(mean(t2[:punish2][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
plot(mean(mean(t2[:limit][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 8))
plot(mean(mean(t2[:vl][:,:,:], dims = 3), dims = 2)[:,:,1])
plot(mean(mean(t2[:stock][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
plot(mean(mean(t2[:payoffR][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 2))
plot(mean(mean(t2[:effort][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))



t3 =   cpr_abm(n = 150*49, max_forest = (49)*210000, ngroups =49, nsim = 5, nrounds = 500,
lattice = [7,7], harvest_limit = 6, regrow = .025, pun1_on = true, harvest_var = 3,
wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
punish_cost = 0.01, labor = .7, zero = true, back_leak = false, control_learning = false, full_save = true)


plot(mean(mean(t3[:punish][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
plot(mean(mean(t3[:punish2][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
plot(mean(mean(t3[:limit][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 8))
plot(mean(mean(t3[:vl][:,:,:], dims = 3), dims = 2)[:,:,1])
plot(mean(mean(t3[:stock][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
plot(mean(mean(t3[:payoffR][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 2))
plot(mean(mean(t3[:effort][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))





t4 =   cpr_abm(n = 150*49, max_forest = (49)*210000, ngroups =49, nsim = 5, nrounds = 500,
lattice = [7,7], harvest_limit = 3.5, regrow = .025, pun1_on = true, harvest_var = 2,
wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
punish_cost = 0.01, labor = .7, zero = true, back_leak = true, control_learning = true, full_save = true, 
experiment_punish1 = 1, experiment_group = [collect(1:49)][1])



plot(mean(mean(t4[:punish2][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
plot(mean(mean(t4[:limit][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 8))
plot(mean(mean(t4[:vl][:,:,:], dims = 3), dims = 2)[:,:,1])
plot(mean(mean(t4[:stock][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
plot(mean(mean(t4[:payoffR][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 2))
plot(mean(mean(t4[:effort][:,:,:], dims = 3), dims = 2)[:,:,1], ylim = (0, 1))
plot(mean(mean(t4[:harvest][:,:,:], dims = 3), dims = 2)[:,:,1])
plot(mean(mean(t4[:harvest][:,:,:], dims = 3), dims = 2)[:,:,1]./mean(mean(t4[:effort][:,:,:], dims = 3), dims = 2)[:,:,1])
