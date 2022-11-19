#simulate
highleak=cpr_abm(experiment_effort = 1, experiment_leak=.9, wages = 8,  pun2_on = false, fines1_on = false, fines2_on = false, max_forest = 430000,   regrow = .025,
 nsim = 5, tech = .9, punish_cost = 0.00001, nrounds = 1000, leak = false)
lowleak=cpr_abm(experiment_effort = 1, experiment_leak=.1, wages = 8, pun2_on = false, fines1_on = false, fines2_on = false,  max_forest = 430000,   regrow = .025,
 nsim = 5, tech = .9, punish_cost = 0.00001, nrounds = 1000, leak = false)

#Plot
 plot(mean(mean(highleak[:punish][1:700,2,:], dims = 3), dims = 2), label = "High Leakage", xlab = "time",
 size=(450, 380), ylab = "Average contribution exclude (X)", ylim = (-.01, 1), lw = 2)
plot!(mean(mean(lowleak[:punish][1:700,2,:], dims = 3), dims = 2), label = "Low Leakage", lw =3)
#save
png("cpr/output/exampleate.png")

# Check other dynamics: optional

plot!(mean(mean(lowleak[:stock][:,2,:], dims = 3), dims = 2), label = "Low Leakage")
plot!(mean(mean(highleak[:stock][:,2,:], dims = 3), dims = 2), label = "High Leakage")
plot!(mean(mean(lowleak[:effort][:,2,:], dims = 3), dims = 2), label = "Low Leakage")
plot!(mean(mean(highleak[:effort][:,2,:], dims = 3), dims = 2), label = "High Leakage")

#simulate
highleak=cpr_abm(experiment_effort = 1, experiment_leak=.9, wages = 14,  pun2_on = false, fines1_on = false, fines2_on = false, max_forest = 430000,  regrow = .025,
 nsim = 5, tech = .9, punish_cost = 0.00001, nrounds = 1000, leak = false)
lowleak=cpr_abm(experiment_effort = 1, experiment_leak=.01, wages = 14, pun2_on = false, fines1_on = false, fines2_on = false,  max_forest = 430000, regrow = .025,
 nsim = 5, tech = .9, punish_cost = 0.00001, nrounds = 1000, leak = false)

#Plot
 plot(mean(mean(highleak[:punish][1:700,2,:], dims = 3), dims = 2), label = false, xlab = "time",
 size=(450, 380), ylab = "Average contribution exclude (X)", ylim = (-0.01, 1), lw = 2)
plot!(mean(mean(lowleak[:punish][1:700,2,:], dims = 3), dims = 2), label = false, lw = 2)
#save
png("cpr/output/exampleate2.png")
