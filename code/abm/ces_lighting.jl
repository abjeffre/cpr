
test1 =cpr_abm(ngroups = 2, n = 300, experiment_leak = false,
experiment_effort =false,
experiment_group =1, tech = 2, groups_sampled = 3, wages = .20,
price = .5,
max_forest=15000, nrounds = 1000, nsim =15, experiment_punish1 = false,
 regrow = .025,
labor = .7, lattice =[1,2],
var_forest = 0, pun1_on = false, pun2_on = true, outgroup = 0.01,
 harvest_var = .07, defensibility = 1,
seized_on = true, leak = false)


test2 =cpr_abm(ngroups = 5, n = 150*5, experiment_leak = false,
experiment_effort =false,
experiment_group =1, tech = 2, groups_sampled = 3, wages = .2,
price = 1,
max_forest=15000*2.5, nrounds = 1000, nsim =6, experiment_punish1 = false,
 regrow = .025,
labor = .7, lattice =[1,5],
var_forest = 0, pun1_on = false, pun2_on = true, outgroup = 0.01,
 harvest_var = .07, defensibility = 1,
seized_on = true, leak = false)




test3 =cpr_abm(ngroups = 10, n = 150*10, experiment_leak = false,
experiment_effort =false,
experiment_group =1, tech = 2, groups_sampled = 3, wages = .2,
price = 1,
max_forest=15000*5, nrounds = 1000, nsim =3, experiment_punish1 = false,
 regrow = .025,
labor = .7, lattice =[2,5],
var_forest = 0, pun1_on = false, pun2_on = true, outgroup = 0.01,
 harvest_var = .07, defensibility = 1,
seized_on = true, leak = false)




plot(test1["stock"][:,:,1], legend = false, ylim = (.5, 1),color = :forestgreen, alpha = .1)
plot!(test1["stock"][:,:,2] , legend = false, color = :forestgreen, alpha = .1)
plot!(test1["stock"][:,:,3] , legend = false, color = :forestgreen, alpha = .1)
plot!(test1["stock"][:,:,4] , legend = false, color = :forestgreen, alpha = .1)
plot!(test1["stock"][:,:,5] , legend = false, color = :forestgreen, alpha = .1)
plot!(test1["stock"][:,:,6] , legend = false, color = :forestgreen, alpha = .1)
plot!(test1["stock"][:,:,7] , legend = false, color = :forestgreen, alpha = .1)
plot!(test1["stock"][:,:,8] , legend = false, color = :forestgreen, alpha = .1)
plot!(test1["stock"][:,:,9] , legend = false, color = :forestgreen, alpha = .1)
plot!(test1["stock"][:,:,10] , legend = false, color = :forestgreen, alpha = .1)
plot!(test1["stock"][:,:,11] , legend = false, color = :forestgreen, alpha = .1)
plot!(test1["stock"][:,:,12] , legend = false, color = :forestgreen, alpha = .1)
plot!(test1["stock"][:,:,13] , legend = false, color = :forestgreen, alpha = .1)
plot!(test1["stock"][:,:,14] , legend = false, color = :forestgreen, alpha = .1)
xlabel!("Time")
ylabel!("Natural Resource Stock")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\ces_lighting1.png")

plot(test2["stock"][:,:,1], legend = false, ylim = (.5, 1), alpha = .3,  color = :forestgreen)
plot!(test2["stock"][:,:,2] , legend = false, alpha = .3,  color = :forestgreen)
plot!(test2["stock"][:,:,3] , legend = false, alpha = .3,  color = :forestgreen)
plot!(test2["stock"][:,:,4] , legend = false, alpha = .3,  color = :forestgreen)
plot!(test2["stock"][:,:,5] , legend = false, alpha = .3,  color = :forestgreen)
plot!(test2["stock"][:,:,6] , legend = false, alpha = .3,  color = :forestgreen)
xlabel!("Time")
ylabel!("Natural Resource Stock")
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\ces_lighting2.png")

plot(test3["stock"][:,:,1], legend = false, ylim = (.5, 1) , color = :forestgreen, alpha = .3)
plot!(test3["stock"][:,:,2] , legend = false, color = :forestgreen, alpha = .3)
plot!(test3["stock"][:,:,3] , legend = false, color = :forestgreen, alpha = .3)
xlabel!("Time")
ylabel!("Natural Resource Stock")
png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\ces_lighting3.png")





plot(test1["limit"][:,:,1], legend = false, ylim = (0, .4),color = :black, alpha = .3)
plot!(test1["limit"][:,:,2] , legend = false, color = :black, alpha = .3)
plot!(test1["limit"][:,:,3] , legend = false, color = :black, alpha = .3)
plot!(test1["limit"][:,:,4] , legend = false, color = :black, alpha = .3)
plot!(test1["limit"][:,:,5] , legend = false, color = :black, alpha = .3)
plot!(test1["limit"][:,:,6] , legend = false, color = :black, alpha = .3)
plot!(test1["limit"][:,:,7] , legend = false, color = :black, alpha = .3)
plot!(test1["limit"][:,:,8] , legend = false, color = :black, alpha = .3)
plot!(test1["limit"][:,:,9] , legend = false, color = :black, alpha = .3)
plot!(test1["limit"][:,:,10] , legend = false, color = :black, alpha = .3)
plot!(test1["limit"][:,:,11] , legend = false, color = :black, alpha = .3)
plot!(test1["limit"][:,:,12] , legend = false, color = :black, alpha = .3)
plot!(test1["limit"][:,:,13] , legend = false, color = :black, alpha = .3)
plot!(test1["limit"][:,:,14] , legend = false, color = :black, alpha = .3)
xlabel!("Time")
ylabel!("Groups Sustainability Policy")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\ces_lighting4.png")





plot(test2["limit"][:,:,1], legend = false, ylim = (0, .4), alpha = .3,  color = :black)
plot!(test2["limit"][:,:,2] , legend = false, alpha = .3,  color = :black)
plot!(test2["limit"][:,:,3] , legend = false, alpha = .3, color = :black)
plot!(test2["limit"][:,:,4] , legend = false, alpha = .3,  color = :black)
plot!(test2["limit"][:,:,5] , legend = false, alpha = .3,  color = :black)
plot!(test2["limit"][:,:,6] , legend = false, alpha = .3,  color = :black)
xlabel!("Time")
ylabel!("Groups Sustainability Policy")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\ces_lighting5.png")





plot(test3["limit"][:,:,1], legend = false, ylim = (0, .4) , color = :black, alpha = .3)
plot!(test3["limit"][:,:,2] , legend = false, color = :black, alpha = .3)
plot!(test3["limit"][:,:,3] , legend = false, color = :black, alpha = .3)
xlabel!("Time")
ylabel!("Groups Sustainability Policy")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\ces_lighting6.png")





####################################################
