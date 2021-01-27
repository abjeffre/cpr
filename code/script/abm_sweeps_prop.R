source("cpr/code/abm/cpr_inst_wlimit_continious_gen.R")
source("cpr/paths.R")
library(parallel)
sweeps <- expand.grid(n = c(150),#, 300, 900),
                      #wages = c(0.025, 0.05, 0.075),
                      max_forest = c(100, 200),#, 500, 1000),
                      var_forest = c(1, 50),
                      regrow = c(0.03, 0.05, 0.07),
                      self_policing =c(TRUE),#, FALSE),
                      fine = c(0.00),#, 0.5, 1 ),
                      outgroup = c(.5),#, .9, 0.1, ),
                      travel_cost = c(0.1),#, .5, 1), 
                      monitor_tech = c(0.1, 1, 5),
                      harvest_limit = c(0.01, .10, .20),
                      labor = c(0.3, .7),
                      marginal = c(FALSE)
)


  cpr_sweeps <- mclapply(1:nrow(sweeps),   #that -1 is a correction that was not implmented the first time run
                         function(i) cpr_institution_abm(n=sweeps$n[[i]], max_forest=sweeps$max_forest[[i]],
                                                         regrow=sweeps$regrow[[i]], var_forest = sweeps$var_forest[[i]], labor = sweeps$labor[[i]], 
                                                         self_policing=sweeps$self_policing[[i]], fine=sweeps$fine[[i]], outgroup=sweeps$outgroup[[i]], travel_cost=sweeps$travel_cost[[i]], 
                                                         marginal = sweeps$marginal[[i]], monitor_tech= sweeps$monitor_tech[[i]], harvest_limit = sweeps$harvest_limit[[i]], nsim = 20),
                         mc.cores =1
  )
  
  saveRDS(cpr_sweeps, file = paste0(path$dataAbm, "cpr_sweeps_prop.RDS"))

  
###################################################
############ Get Full list ########################




flattenlist <- function(x){  
  out <- list()
  for(i in 1:length(x)){
    out <- c(out, x[[i]])
  }
  return(out)
}

temp <- flattenlist(cpr_sweeps)

cpr_sims<- cpr_sweeps



# Check where the errors occured in the ABM  
errors <- which(unlist(lapply(cpr_sims, function(x) length(x)<2)))

# Check for why errors occur

apply(sweeps[errors,],2,unique)
apply(sweeps[errors,],2,table)





####################################################################
######################## RERUN ERROR MODELS ########################



cpr_errors_rerun <- mclapply(errors,   
                             function(i) cpr_institution_abm(n=sweeps$n[[i]], wages=sweeps$wages[[i]], max_forest=sweeps$max_forest[[i]],
                                                             regrow=sweeps$regrow[[i]], self_policing=sweeps$self_policing[[i]], fine=sweeps$fine[[i]], outgroup=sweeps$outgroup[[i]], travel_cost=sweeps$travel_cost[[i]]), 
                             mc.cores =8
)

saveRDS(cpr_errors_rerun, file = "cpr_sweeps_errors.RDS")
readRDS

########################################################################
########################################################################

cpr_sims[errors] <- cpr_errors_rerun


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