######################################################
################ COMPLIANCE ##########################
a=cpr_abm(leak = false, degrade = .01, defensibility = 1, regrow = .02, experiment_limit = 2, new_leakage_experiment = 0, punish_cost = 1.5, tech = .3, wages = 7, nrounds = 1000)
b=cpr_abm(leak = false, degrade = .01, defensibility = 1, regrow = .02, experiment_limit = 2, new_leakage_experiment = 500, punish_cost = 1.5, tech = .3, wages = 7, nrounds = 1000)

p1=plot(a[:harvest][:,1,1])
plot!(b[:harvest][:,1,1])

p2=plot(a[:punish2][:,1,1])
plot!(b[:punish2][:,1,1])

p2=plot(a[:punish2][:,1,1])
plot!(b[:punish2][:,1,1])


mp1 = plot(p1, p2)
# Fixed punishmemt


c=cpr_abm(leak = false, degrade = .01, defensibility = 1, regrow = .02, experiment_limit = 4, experiment_punish2 = .5, new_leakage_experiment = 0, punish_cost = 1.5, tech = .3, wages = 7, nrounds = 1000)
d=cpr_abm(leak = false, degrade = .01, defensibility = 1, regrow = .02, experiment_limit = 4, experiment_punish2 = .5, new_leakage_experiment = 500, punish_cost = 1.5, tech = .3, wages = 7, nrounds = 1000)

p3=plot(c[:harvest][:,1,1])
plot!(d[:harvest][:,1,1])


mp2 = plot(p1, p2, p3)
