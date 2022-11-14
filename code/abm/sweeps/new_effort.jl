################


a=cpr_abm(leak = false, experiment_leak = 1,
 pun1_on = false, pun2_on =false, nrounds = 1000, wages = .1, experiment_price = 2, max_forest = 350000, begin_leakage_experiment = 1)


ab=cpr_abm(leak = false, experiment_leak = .01,
 pun1_on = false, pun2_on =true, nrounds = 1000, wages=.1, experiment_price = 2, max_forest= 350000, begin_leakage_experiment = 1)

ac=cpr_abm(leak = false, n = 100, regrow = .025, tech  = 10,
 pun1_on = false, pun2_on =true, nrounds = 2000, wages=10, max_forest= 200000, harvest_limit = 5)

 # Note that this confirms the mathematical management papers assertion that 
 # The equalibrium value will equal Stock = c/p*q
 # It the catchability coefficent here is equal to 100 at Max production 
 # It would appear that Q is 
 plot(ac[:stock][:,:,1], ylim = (0, 1))
 plot(ac[:harvest][:,:,1])
 plot(ac[:effort][:,:,1])
 plot(ac[:payoffR][:,:,1])
 plot(ac[:punish2][:,:,1])
 plot(ac[:punish2][:,:,1])



using Plots
plot(a[:stock][:,2,1])
plot!(ab[:stock][:,2,1])
plot!(ac[:stock][:,:,1])

plot(a[:effort][:,2,1])
plot!(ab[:effort][:,2,1])
plot!(ac[:effort][:,2,1])


plot(a[:payoffR][:,2,1])
plot!(ab[:payoffR][:,2,1])
plot!(ac[:payoffR][:,2,1])
ylims!(0, .2)
