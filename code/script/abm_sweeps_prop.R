source("cpr/code/abm/cpr_inst_wlimit_continious_gen.R")
source("cpr/paths.R")
library(parallel)
sweeps <- expand.grid(n = c(150),#, 300, 900),
                      #wages = c(0.025, 0.05, 0.075),
                      max_forest = c(100, 200),#, 500, 1000),
                      var_forest = c(10, 50),
                      regrow = c(0.03, 0.05, 0.07),
                      self_policing =c(TRUE),#, FALSE),
                      fine = c(0.00),#, 0.5, 1 ),
                      outgroup = c(.5),#, .9, 0.1, ),
                      travel_cost = c(0.1),#, .5, 1), 
                      monitor_tech = c(0.1, 1, 5),
                      harvest_limit = c(0.01, .10, .20),
                      labor = c(0.3, .7),
                      tech = c(0.04, 0.06)
)


cpr_sweeps <- mclapply(1:nrow(sweeps),   #that -1 is a correction that was not implmented the first time run
                       function(i) cpr_institution_abm(n=sweeps$n[[i]], 
                                                       max_forest=sweeps$max_forest[[i]],
                                                       regrow=sweeps$regrow[[i]], 
                                                       var_forest = sweeps$var_forest[[i]], 
                                                       labor = sweeps$labor[[i]], 
                                                       self_policing=sweeps$self_policing[[i]], 
                                                       fine=sweeps$fine[[i]], 
                                                       outgroup=sweeps$outgroup[[i]], 
                                                       travel_cost=sweeps$travel_cost[[i]], 
                                                       tech = sweeps$tech[[i]], 
                                                       monitor_tech= sweeps$monitor_tech[[i]], 
                                                       harvest_limit = sweeps$harvest_limit[[i]], 
                                                       nsim = 20,
                                                       nrounds = 1000),
                       mc.cores =50
)


sweep_prop <- list(par = sweeps,
                   data = cpr_sweeps)

saveRDS(sweep_prop, file = paste0(path$dataAbm, "cpr_sweeps_prop.RDS"))


###################################################
############ Get Full list ########################



# 
#  flattenlist <- function(x){  
#   out <- list()
#   for(i in 1:length(x)){
#     out <- c(out, x[[i]])
#   }
#   return(out)
# }

# temp <- flattenlist(cpr_sweeps)

cpr_sims<- cpr_sweeps



# Check where the errors occured in the ABM  
errors <- which(unlist(lapply(cpr_sims, function(x) length(x)<2)))

# Check for why errors occur

apply(sweeps[errors,],2,unique)
apply(sweeps[errors,],2,table)


####################################################################
######################## RERUN ERROR MODELS ########################



cpr_errors_rerun <- mclapply(errors,   
                             function(i) cpr_institution_abm(n=sweeps$n[[i]], 
                                                             max_forest=sweeps$max_forest[[i]],
                                                             regrow=sweeps$regrow[[i]], 
                                                             var_forest = sweeps$var_forest[[i]], 
                                                             labor = sweeps$labor[[i]], 
                                                             self_policing=sweeps$self_policing[[i]], 
                                                             fine=sweeps$fine[[i]], 
                                                             outgroup=sweeps$outgroup[[i]], 
                                                             travel_cost=sweeps$travel_cost[[i]], 
                                                             tech = sweeps$tech[[i]], 
                                                             monitor_tech= sweeps$monitor_tech[[i]], 
                                                             harvest_limit = sweeps$harvest_limit[[i]], 
                                                             nsim = 20,
                                                             nrounds = 1000),
                             mc.cores =8
)

cpr_sweeps[errors] <- cpr_errors_rerun

sweep_prop <- list(par = sweeps,
                   data = cpr_sweeps)


saveRDS(cpr_sweeps, file = paste0(path$dataAbm, "cpr_sweeps_prop.RDS"))


################################################################################################
########################## WITHOUT INSITUTIONS #################################################


sweeps2 <- expand.grid(n = c(150),#, 300, 900),
                       #wages = c(0.025, 0.05, 0.075),
                       max_forest = c(100, 200),#, 500, 1000),
                       var_forest = c(10, 50),
                       regrow = c(0.03, 0.05, 0.07),
                       self_policing =c(TRUE),#, FALSE),
                       fine = c(0.00),#, 0.5, 1 ),
                       outgroup = c(.5),#, .9, 0.1, ),
                       travel_cost = c(0.1),#, .5, 1), 
                       monitor_tech = c(0.1),
                       harvest_limit = c(0.01),
                       labor = c(0.3, .7),
                       tech = c(0.04, 0.06)
)


cpr_sweeps_base <- mclapply(1:nrow(sweeps2),   #that -1 is a correction that was not implmented the first time run
                            function(i) cpr_institution_abm(n=sweeps2$n[[i]], 
                                                            max_forest=sweeps2$max_forest[[i]],
                                                            regrow=sweeps2$regrow[[i]], 
                                                            var_forest = sweeps2$var_forest[[i]], 
                                                            labor = sweeps2$labor[[i]], 
                                                            self_policing=sweeps2$self_policing[[i]], 
                                                            fine=sweeps2$fine[[i]],
                                                            outgroup=sweeps2$outgroup[[i]], 
                                                            travel_cost=sweeps2$travel_cost[[i]], 
                                                            tech = sweeps2$tech[[i]],
                                                            monitor_tech= sweeps2$monitor_tech[[i]],
                                                            harvest_limit = sweeps2$harvest_limit[[i]], 
                                                            nsim = 20,
                                                            nrounds = 1000,
                                                            inst = FALSE),
                            mc.cores =48
)


sweep_prop_base <- list(par = sweeps2,
                        data = cpr_sweeps_base)

saveRDS(sweep_prop_base, file = paste0(path$dataAbm, "cpr_sweeps_prop_base.RDS"))


cpr_sims_base<- cpr_sweeps_base


# Check where the errors occured in the ABM  
errors <- which(unlist(lapply(cpr_sims_base, function(x) length(x)<2)))

if(length(errors)>0){
  
  
  # Check for why errors occur
  
  apply(sweeps[errors,],2,unique)
  apply(sweeps[errors,],2,table)
  
  
  ####################################################################
  ######################## RERUN ERROR MODELS ########################
  
  
  
  cpr_errors_rerun_base <- mclapply(errors,   
                                    function(i) cpr_institution_abm(n=sweeps2$n[[i]], 
                                                                    max_forest=sweeps2$max_forest[[i]],
                                                                    regrow=sweeps2$regrow[[i]], 
                                                                    var_forest = sweeps2$var_forest[[i]], 
                                                                    labor = sweeps2$labor[[i]], 
                                                                    self_policing=sweeps2$self_policing[[i]], 
                                                                    fine=sweeps2$fine[[i]],
                                                                    outgroup=sweeps2$outgroup[[i]], 
                                                                    travel_cost=sweeps2$travel_cost[[i]], 
                                                                    tech = sweeps2$tech[[i]],
                                                                    monitor_tech= sweeps2$monitor_tech[[i]],
                                                                    harvest_limit = sweeps2$harvest_limit[[i]], 
                                                                    nsim = 20,
                                                                    nrounds = 1000,
                                                                    inst = FALSE),
                                    mc.cores =8
  )
  
  cpr_sweeps_base[errors] <- cpr_errors_rerun_base
  
  sweep_prop_base <- list(par = sweeps2,
                          data = cpr_sweeps_base)
  
  
  saveRDS(cpr_sweeps_base, file = paste0(path$dataAbm, "cpr_sweeps_prop_base.RDS"))
  
  
}




########################################################################
########################################################################
cpr_sims[errors] <- cpr_errors_rerun

for(j in which((sweeps$harvest_limit==.20 & sweeps$regrow==.03) & sweeps$labor ==0.07)){
  plot(cpr_sims[[j]]$limit[[1]], type = "l", ylim = c(0, 1), col=col.alpha("red", .3))
  for(i in 2:10) lines(cpr_sims[[j]]$limit[[i]], col=col.alpha("red", .3))
  for(i in 1:10) lines(cpr_sims[[j]]$stock[[i]][,1], col=col.alpha("green", .3))
  for(i in 1:10) lines(cpr_sims[[j]]$punish[[i]], col=col.alpha("goldenrod", .3))
  for(i in 1:10) lines(cpr_sims[[j]]$effort[[i]], col=col.alpha("purple", .3))
}

punish_mean <- rep(0, length(cpr_sims))
punish_sds<- rep(0, length(cpr_sims))
leakage_mean <- rep(0, length(cpr_sims))
leakage_payoff <-rep(0, length(cpr_sims))
punish_payoff <- rep(0, length(cpr_sims))
leakage_mean <- rep(0, length(cpr_sims))
limit <-rep(0, length(cpr_sims))
stock<-rep(0, length(cpr_sims))
effort<-rep(0, length(cpr_sims))



for(i in 1:length(cpr_sims)){
  
  temp <- rep(NA, 10)
  temp2 <- rep(NA, 10)
  temp8 <- temp7 <- temp5 <- temp4 <- temp3 <- temp6<- rep(NA, 10)
  for(j in 1:10){
    temp[j] <- mean(cpr_sims[[i]]$punish[[j]])
    temp2[j] <- sd(cpr_sims[[i]]$punish[[j]])
    temp3[j] <- mean(cpr_sims[[i]]$leakage[[j]])
    temp4[j] <- mean(cpr_sims[[i]]$payoff_punish[[j]], na.rm = T)
    temp5[j] <- mean(cpr_sims[[i]]$payoff_leakage[[j]], na.rm = T)
    temp6[j] <- mean(cpr_sims[[i]]$limit[[j]], na.rm = T)
    temp7[j] <- mean(cpr_sims[[i]]$limit[[j]], na.rm = T)
    temp8[j] <- mean(cpr_sims[[i]]$limit[[j]], na.rm = T)
    
    
  }
  punish_mean[[i]] <- mean(temp)
  punish_sds[[i]] <- mean(temp2)
  leakage_mean[[i]] <- mean(temp3)
  punish_payoff[[i]] <- mean(temp4)
  leakage_payoff[[i]] <- mean(temp5)
  limit[[i]] <- mean(temp6)
  stock[[i]] <- mean(temp7)
  effort[[i]] <- mean(temp8)
}



a <- which(sds < .1 & means > mean(means, na.rm = TRUE))


corrs <- list()
for(i in 1:ncol(sweeps)){
  items <- unique(sweeps[,i])
  temp <- rep(0, length(items))
  names(temp) <- as.character(items)
  for(value in items){
    a <- which(sweeps[,i]==value)
    cor <- cor(leakage_mean[a], punish_mean[a], use = "complete.obs")
    temp[which(names(temp) == as.character(value))] <- cor  
  }
  names(temp) <- paste0(as.character(items))
  corrs[[i]]  <- temp
  
}


corrs <- list()
for(j in 1:ncol(sweeps)){
  cond_list <- list()
  
  other_columns <- 1:ncol(sweeps)
  other_columns <- other_columns[-j]
  count <- 1
  unique_cond <- unique(sweeps[,j])
  other_col_list <- list()
  other_col_count <- 1
  for(cond_value in unique_cond){
    b <- sweeps[, j] == cond_value
    
    
    
    count2 <- 1
    cond <- list()
    for(i in other_columns){
      items <- unique(sweeps[,i])
      temp <- rep(0, length(items))
      names(temp) <- as.character(items)
      
      for(value in items){
        a <- which(sweeps[,i]==value & b)
        
        cor <- cor(leakage_mean[a], punish_mean[a], use = "complete.obs")
        temp[which(names(temp) == as.character(value))] <- cor  
      }
      names(temp) <- paste0(colnames(sweeps)[other_columns][i], "=" ,as.character(items), "|", colnames(sweeps)[j], "=", cond_value   )
      cond[[count2]]  <- temp
      count2 <- count2 +1
    }##END OTHER COLUMNS
    names(cond) <- colnames(sweeps)[other_columns]
    other_col_list[[other_col_count]] <- cond
    other_col_count <- other_col_count +1
  }    
  names(other_col_list) <- paste(colnames(sweeps)[j], "=", as.character(unique_cond))
  corrs[[j]]<- other_col_list  
}

names(corrs) <- paste("|",colnames(sweeps))






a <- cpr_sims[which(sweeps$regrow ==.)]
temp <- list()
for(i in 1:length(a)){
  temp[[i]] <- a[[i]][[13]]
}

mean(unlist(lapply(temp, function(x) mean(sapply(lapply(x, mean), mean)))))

plot(a[[1]]$stock[[1]][,1], type = "l", col=col.alpha("black",.2))
for(i in 1:19)lines(a[[2]]$stock[[i]][,1], col=col.alpha("black",.2))

means <- rep(NA, length(a))
for(i in 1:length(a)) means[i] <- mean(unlist(a[[i]]$limit[[1]][1]))
mean(means)