
using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
using ColorSchemes
cd("C:\\Users\\jeffr\\Documents\\Work\\")


###########



################# Brute force a solution
pay = []
stock = []

S=collect(0.0:0.01:1.0)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 150, ngroups = 150, lattice = (1,150), max_forest = 1400*150, regrow = 0.025,
    leak = false, pun1_on = false, pun2_on = false, learn_type = "income", mortality_rate = 0.01, 
    wages = 1.3, price = .01, fines1_on = false, fines2_on = false, nrounds = 1000, seized_on = false,
    nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, experiment_effort = L)
  end
msy=pmap(g, S)

a=[msy[i][:payoffR][end,1,1] for i in 1:length(msy)]
i=findmax(a)[2]
msy[i][:harvest][end,1,1]

### FOR THIS MODEL 2.408

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


S=collect(0:.02:1)
# set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(L)
    cpr_abm(n = 150*9, max_forest = 9*210000, ngroups =9, nsim = 50,
    lattice = [3,3], harvest_limit = 4.8, regrow = .025, pun1_on = true, 
    wages = 1.3, price = .06, defensibility = 1, fines1_on = false, fines2_on = false, 
    punish_cost = 0.01, labor = .7, zero = true, experiment_punish1 = L, 
    experiment_group = [1, 2, 3, 4, 5, 6, 7, 8, 9], back_leak = true, control_learning = true)
end
dat=pmap(g, S)
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