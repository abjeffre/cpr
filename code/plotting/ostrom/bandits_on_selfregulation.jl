####################################################################
####### BANDITRY ON BORDERS  #######################################

# Note we increase the amount of forest to ensure that it does not bottom out by the time we sample the amount of support for borders. 
if RUN  == true
    S=collect(0.01:.05:1)
    # set up a smaller call function that allows for only a sub-set of pars to be manipulated
    @everywhere function g(L)
        cpr_abm(n = 75*9, max_forest = 9*105000, ngroups =9, nsim = 20,
        lattice = [3,3], harvest_limit = 3.4, harvest_var = .01, harvest_var_ind = .01,
        regrow = .01, pun2_on = true, leak=false, pun1_on = false, experiment_group = [5,6],
        wages = 0.1, price = 1, defensibility = 1, experiment_leak = L, 
        experiment_effort =1, control_learning = false,
        fines1_on = false, punish_cost = 0.1, labor = .7, 
        invasion = true, begin_leakage_experiment = 1)
    end
    dat=pmap(g, S)
    serialize("bandits_on_selfreg.dat", dat)
end

# Load 
using Serialization
dat = deserialize("cpr\\data\\abm\\bandits_on_selfreg.dat")

groups = [collect(1:1:4); collect(7:1:9)]
y = [mean(dat[i][:punish2][400:500,groups,:], dims =1) for i in 1:length(dat)]
μ = [median(y[i]) for i in 1:length(dat)]
a = [reduce(vcat, y[i]) for i in 1:length(y)]
PI = [quantile(a[i], [0.31,.68]) for i in 1:size(y)[1]]
PI=vecvec_to_matrix(PI) 
x1=collect(.01:.05:1)
x=reduce(vcat, [fill(i, length(dat)*7) for i in x1])
a=reduce(vcat, a)

mean(y)
bandits_on_self_regulation=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:grey, label = false,
 xlab = "Roving Banditry", ylab = "Support for Regulation",
xticks = (collect(0:4:20), ("0", "0.2", "0.4", "0.6", "0.8", "1")),
title = "(c)", titlelocation = :left, titlefontsize = 15)
scatter!(x.*20, a, c=:black, alpha = .2, label = false)



