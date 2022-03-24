 ok  = cpr_abm(n = 150, ngroups = 150, lattice = (15,10), max_forest = 350000/2, leak = false, pun1_on = false,
   pun2_on = false, learn_type = "income", mortality_rate = .2, wages = 1,
   fines1_on = false, fines2_on = false, fidelity = .1, nrounds = 3000,
   nmodels = 2, var_forest = 1, mutation = .1, social_learning = false)
plot(ok[:stock][:,:,1], label = false, ylim = (0, 1))
plot(ok[:payoffR][:,:,1], label = false, ylim = (0, 25))

#Socail Learning True
ok  = cpr_abm(n = 150, ngroups = 150, lattice = (15,10), max_forest = 350000/2, leak = false, pun1_on = false,
   pun2_on = false, learn_type = "income", mortality_rate = 0.03, wages = 1,
   fines1_on = false, fines2_on = false, fidelity = .01, nrounds = 2000,
   nmodels = 149, var_forest = 0, mutation = .05, social_learning = true, slearn_freq = 0.5,
   regrow = .01, rec_history = true)
plot(ok[:stock][:,:,1], label = false, ylim = (0, 1))
plot(ok[:effort][:,:,1], label = false, ylim = (0, 1))
plot(ok[:payoffR][:,:,1], label = false, ylim = (0, 25))


ok  = cpr_abm(n = 3, ngroups = 3, lattice = (3,1), max_forest = 1166*3, leak = false, pun1_on = false,
   pun2_on = false, learn_type = "income", mortality_rate = .01, wages = 1,
   fines1_on = false, fines2_on = false, fidelity = .01, nrounds = 5000,
   nmodels = 1, var_forest = 0, mutation = .05, social_learning = false, slearn_freq = 1,
   regrow = .01,  rec_history = true)
   plot(ok[:stock][:,:,1], label = false, ylim = (0, 1))
   plot(ok[:effort][:,:,1], label = false, ylim = (0, 1))
   plot(ok[:payoffR][:,:,1], label = false, ylim = (0, 25))
   

pay = []
for i in collect(0.0:0.01:1.0)   
  ok  = cpr_abm(n = 150, ngroups = 2, lattice = (1,2), max_forest = 1166*150, leak = false, pun1_on = false,
     pun2_on = false, learn_type = "income", mortality_rate = 0, wages = 1,
    fines1_on = false, fines2_on = false, fidelity = .0, nrounds = 1000,
    nmodels = 10, var_forest = 0, mutation = .1, social_learning = false, experiment_effort = i)
    push!(pay, ok[:payoffR][1000,1,1])
end


pay = []
roi = []
for i in collect(0.0:0.01:1.0)   
  ok  = cpr_abm(n = 150, ngroups = 2, lattice = (2,1), max_forest = 1166*150, 
    leak = false, pun1_on = false, punish_cost = 0.001,
    pun2_on = false, learn_type = "income", mortality_rate = 0.03, wages = 1,
    fines1_on = false, fines2_on = false, fidelity = .02, nrounds = 1000,
    seized_on = false, labor = 1,
    experiment_effort = i, experiment_punish2 = 0, experiment_limit = 0,
    nmodels = 3, var_forest = 0, mutation = .05,
    social_learning = true, harvest_limit = 3)
  push!(pay, ok[:payoffR][1000,1,1])
  push!(roi, ok[:harvest][:,1,1]./ok[:effort][:,1,1])
end

plot(roi[13], ylim = (0, 100))
plot!(roi[14], ylim = (0, 60))
plot!(roi[12], ylim = (0, 60))
plot!(roi[11], ylim = (0, 60))
plot!(roi[10], ylim = (0, 60))
plot!(roi[5], ylim = (0, 60))



ok  = cpr_abm(n = 150, ngroups = 2, lattice = (1,2), max_forest = 1166*150, 
leak = false, pun1_on = false, punish_cost = 0.001,
pun2_on = false, learn_type = "income", mortality_rate = 0.5, wages = 1,
fines1_on = false, fines2_on = false, fidelity = .02, nrounds = 2000,
seized_on = false, glearn_strat = "income", og_on = false,
nmodels = 3, var_forest = 0, mutation = .1, social_learning = false, 
harvest_limit = 2.93 )


plot(ok[:payoffR][:,:,1], ylim = (0, 30), label = false)
plot(ok[:effort][:,:,1],  ylim = (0, 1), label = false)
plot(ok[:stock][:,:,1],  ylim = (0, 1), label = false)

plot(ok[:clp2][:,1,1])


ok2  = cpr_abm(n = 3000, ngroups = 30, lattice = (6,5), max_forest = 1166*3000, 
leak = true, pun1_on = true, punish_cost = 0.001,
pun2_on = true, learn_type = "income", mortality_rate = 0.03, wages = 1,
fines1_on = false, fines2_on = true, fidelity = .02, nrounds = 1000,
seized_on = true, glearn_strat = "income", og_on = false,
nmodels = 3, var_forest = 0, mutation = .05, social_learning = true, harvest_limit = 2.93,
reset = (250, 500, 750) 
)

plot(ok2[:stock][:,:,1], ylim = (0, 1), label = false)
plot(ok2[:payoffR][:,:,1], ylim = (0, 30), label = false)
plot(ok2[:harvest][:,:,1])
plot(ok2[:punish2][:,:,1], ylim = (0, 1), label = false)
plot(ok2[:effort][:,:,1],  ylim = (0, 1), label = false)
plot(ok2[:limit][:,:,1],  ylim = (0, 10), label = false)
plot(ok2[:fine2][:,:,1],  ylim = (0, 10), label = false)


ok  = cpr_abm(n = 1500, ngroups = 30, lattice = (1,30), max_forest = 1166*1500, 
leak = false, pun1_on = false, punish_cost = 0.001,
pun2_on = true, learn_type = "income", mortality_rate = 0.01, wages = 1,
fines1_on = false, fines2_on = false, fidelity = .02, nrounds = 10000,
seized_on = false,  og_on = false,
nmodels = 3, var_forest = 0, mutation = .01, social_learning = true, 
harvest_limit = 2.93, socialLearnYear = (1:1:10000) )

plot(ok[:stock][:,:,1],  ylim = (0, 1), label = false)
