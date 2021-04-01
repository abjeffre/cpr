set.seed(2)
test <- cpr_abm(n = 600,  
                wages = dat_l$par$wages[a],
                labor = dat_l$par$labor[a],
                tech = 1,
                regrow = .01,
                max_forest = dat_l$par$max_forest[a],
                var_forest = "binary",
                outgroup = 0.00,
                monitor_tech = .5,
                harvest_limit = dat_l$par$harvest_limit[a],
                defensibility = 300,
                degradability = dat_l$par$degradability[a] ,
                learn_type = "income",
                travel_cost = 0.1,
                self_policing = TRUE,
                fine = 0,
                nsim = 1,
                punish_cost = .02,
                ngroups = 2,
                leak = TRUE,
                groups_sampled = 1,
                lattice = c(1, 2),
                inst = TRUE,
                nrounds = 250, 
                REDD = TRUE,
                cofma_gid = "biggest",
                law = .1,
                REDD_dates  = 150,
                nmodels = 5)

par(mfrow =c(1,1))
for(i in 1:1){
  plot(NULL, xlim = c(0, 250), ylim = c(0,1))
  lines(rowMeans(test$punish[[i]]), col=col.alpha("turquoise4", .5))
  lines(rowMeans(test$leakage[[i]]), col=col.alpha("goldenrod3", .5))
  lines(rowMeans(test$stock[[i]]), col=col.alpha("green", .2))
  lines(rowMeans(test$limit [[i]]), col=col.alpha("purple", .2))
  lines(rowMeans(test$effort [[i]]), col=col.alpha("red", .7))
}




par (mfrow =c(1,2))
for(i in 1:1){
  plot(NULL,  ylim = c(0,1), xlim = c(0 , 250))
  for(j in 1:1)lines((test$punish[[i]][,j]), col=col.alpha("turquoise4", 1))
  for(j in 1:1)lines((test$leakage[[i]])[,j], col=col.alpha("goldenrod3", 1))
  for(j in 1:1)lines((test$stock[[i]][,j]*test$forsize[[i]][j])/max(test$forsize[[i]]), col=col.alpha("green", 1))
  for(j in 1:1)lines((test$limit [[i]][,j]), col=col.alpha("purple", 1))
  for(j in 1:1)lines((test$effort [[i]][,j]), col=col.alpha("red", 1))
}



for(i in 1:1){
  plot(NULL,  ylim = c(0,1), xlim = c(0 , 250))
  for(j in 2:2)lines((test$punish[[i]][,j]), col=col.alpha("turquoise4", 1))
  for(j in 2:2)lines((test$leakage[[i]])[,j], col=col.alpha("goldenrod3", 1))
  for(j in 2:2)lines((test$stock[[i]][,j]*test$forsize[[i]][j])/max(test$forsize[[i]]), col=col.alpha("green", 1))
  for(j in 2:2)lines((test$limit [[i]][,j]), col=col.alpha("purple", 1))
  for(j in 2:2)lines((test$effort [[i]][,j]), col=col.alpha("red", 1))
}