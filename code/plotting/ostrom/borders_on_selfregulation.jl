###################################################
############# Borders on Self Regulation ##########
# Note we increase the amount of forest to ensure that it does not bottom out by the time we sample the amount of support for borders. 
if RUN  == true
    # set up a smaller call function that allows for only a sub-set of pars to be manipulated
    S=collect(0.1:.05:1)
    # set up a smaller call function that allows for only a sub-set of pars to be manipulated
    @everywhere function g(L)
        cpr_abm(n = 75*9, max_forest = 9*105000, ngroups =9, nsim = 50,
        lattice = [3,3], harvest_limit = 2, harvest_var = .01, harvest_var_ind = .1,
        regrow = .01, pun2_on = true, leak=true, nrounds = 1000,
        wages = 0.1, price = 1, experiment_punish1=L, experiment_group = collect(1:1:9), back_leak = true,
        fines1_on = false, punish_cost = 0.1, labor = .7, invasion = true, learn_group_policy = true, control_learning = true)
    end
    dat=pmap(g, S)
    serialize("borders_on_reg.dat", dat)
end


dat = deserialize("cpr\\data\\abm\\borders_on_reg.dat")

groups = collect(1:1:9)
y = [mean(dat[i][:punish2][400:500,groups,:], dims =1) for i in 1:length(dat)]
μ = [median(y[i]) for i in 1:length(dat)]
a = [reduce(vcat, y[i]) for i in 1:length(y)]
PI = [quantile(a[i], [0.31,.68]) for i in 1:size(y)[1]]
PI=vecvec_to_matrix(PI) 
x1=collect(.1:.05:1)
x=reduce(vcat, [fill(i, size(dat[1][:stock])[3]*9) for i in x1])
a=reduce(vcat, a)

borders_on_selfreg=plot([μ μ], fillrange=[PI[:,1] PI[:,2]], fillalpha=0.3, c=:grey, label = false,
 xlab = "Presence of Boundaries", ylab = "Support for Regulation",
xticks = (collect(0:4:20), ("0", "0.2", "0.4", "0.6", "0.8", "1")),
title = "(j)", titlelocation = :left, titlefontsize = 15)
scatter!(x[collect(1:10:8550)]*20, a[collect(1:10:8550)], c=:black, alpha = .2, label = false)


