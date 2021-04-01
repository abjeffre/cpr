###############################################################################
#################### RUN SWEEPS TO GENERATE PREDICTIONS #######################
rm(list = ls())
source("cpr/code/abm/cpr_abm_exp.R")
source("cpr/paths.R")
library(parallel)
####################################################################
############# REMEMBER I REVERSED THE ORDER AFTERWARDS ############

sweeps <- expand.grid(n = c(600),#, 300, 900),
                      wages = c(.1, .5),#, .25, .5),
                      max_forest = c(10000),#, 500, 1000),
                      var_forest = 10,
                      regrow = c(0.01),
                      self_policing =c(TRUE),#, FALSE),
                      fine = c(0.00, 0.1),#, 0.5, 1 ),
                      outgroup = c(.01, .9),# 0.1, ),
                      travel_cost = c(0.1),#, .5, 1), 
                      monitor_tech = c(0.5, 2),
                      harvest_limit = c(.90),
                      labor = c(.7),
                      tech = c(1),
                      defensibility = c(300),
                      punish_cost = c(0.002, 0.02),
                      ngroups = 2,
                      groups_sampled = 1,
                      nrounds = 1000, 
                      REDD = c(TRUE, FALSE),
                      cofma_gid = 1,
                      law = .1,
                      REDD_dates  = 75,
                      nmodels = 5,
                      experiment =c(.1,.5 ,.9),
                      seed = 10, stringsAsFactors = FALSE)


cpr_sweeps <- mclapply(1:nrow(sweeps),  
                       function(i) cpr_abm(n=sweeps$n[[i]], 
                                           wages=sweeps$wages[[i]],
                                           max_forest=sweeps$max_forest[[i]],
                                           var_forest = sweeps$var_forest[[i]],
                                           regrow=sweeps$regrow[[i]], 
                                           
                                           self_policing=sweeps$self_policing[[i]],                                                        
                                           fine=sweeps$fine[[i]], 
                                           outgroup=sweeps$outgroup[[i]], 
                                           travel_cost=sweeps$travel_cost[[i]], 
                                           monitor_tech= sweeps$monitor_tech[[i]], 
                                           
                                           harvest_limit=sweeps$harvest_limit[[i]],
                                           labor = sweeps$labor[[i]], 
                                           tech = sweeps$tech[[i]], 
                                           defensibility = sweeps$defensibility[[i]],
                                           punish_cost = sweeps$punish_cost[[i]],
                                           
                                           ngroups =sweeps$ngroups[[i]],
                                           groups_sampled = sweeps$groups_sampled[[i]],
                                           lattice = c(1,2),
                                           nrounds = 250,
                                           REDD = sweeps$REDD[[i]],
                                           
                                           cofma_gid = sweeps$cofma_gid[[i]],
                                           law =sweeps$law[[i]],
                                           REDD_dates = sweeps$REDD_dates[[i]],
                                           nmodels = sweeps$nmodels[[i]],
                                           seed = sweeps$seed[[i]],
                                           experiment = sweeps$experiment[[i]],
                                           
                                           nsim = 30,
                                           leak = TRUE),
                       mc.cores =40
)


sweep_hypo2 <- list(par = sweeps,
                   data = cpr_sweeps)



saveRDS(sweep_hypo2, file = paste0(path$dataAbm, "cpr_sweeps_leak_effort_hypo2.RDS"))



####################################################################
############# REMEMBER I REVERSED THE ORDER AFTERWARDS ############

sweeps4 <- expand.grid(n = c(600),#, 300, 900),
                      wages = c(.1),#, .25, .5),
                      max_forest = c(10000),#, 500, 1000),
                      var_forest = 10,
                      regrow = c(0.01),
                      self_policing =c(TRUE),#, FALSE),
                      fine = c(0.00, 0.1),#, 0.5, 1 ),
                      outgroup = c(.01, .9),# 0.1, ),
                      travel_cost = c(0.1),#, .5, 1), 
                      monitor_tech = c(0.5, 2),
                      harvest_limit = c(.90),
                      labor = c(.7),
                      tech = c(1),
                      defensibility = c(300, 600),
                      punish_cost = c(0.002, 0.02),
                      ngroups = 2,
                      groups_sampled = 1,
                      nrounds = 1000, 
                      REDD = c(TRUE, FALSE),
                      cofma_gid = 2,
                      law = .1,
                      REDD_dates  = 75,
                      nmodels = 5,
                      experiment_leak =c(0.0001,.1,.5 ,.9),
                      experiment_punish =c(.5),
                      seed = 10, stringsAsFactors = FALSE)


cpr_sweeps4 <- mclapply(1:nrow(sweeps4),  
                       function(i) cpr_abm(n=sweeps4$n[[i]], 
                                           wages=sweeps4$wages[[i]],
                                           max_forest=sweeps4$max_forest[[i]],
                                           var_forest = sweeps4$var_forest[[i]],
                                           regrow=sweeps4$regrow[[i]], 
                                           
                                           self_policing=sweeps4$self_policing[[i]],                                                        
                                           fine=sweeps4$fine[[i]], 
                                           outgroup=sweeps4$outgroup[[i]], 
                                           travel_cost=sweeps4$travel_cost[[i]], 
                                           monitor_tech= sweeps4$monitor_tech[[i]], 
                                           
                                           harvest_limit=sweeps4$harvest_limit[[i]],
                                           labor = sweeps4$labor[[i]], 
                                           tech = sweeps4$tech[[i]], 
                                           defensibility = sweeps4$defensibility[[i]],
                                           punish_cost = sweeps4$punish_cost[[i]],
                                           
                                           ngroups =sweeps4$ngroups[[i]],
                                           groups_sampled = sweeps4$groups_sampled[[i]],
                                           lattice = c(1,2),
                                           nrounds = 250,
                                           REDD = sweeps4$REDD[[i]],
                                           
                                           cofma_gid = sweeps4$cofma_gid[[i]],
                                           law =sweeps4$law[[i]],
                                           REDD_dates = sweeps4$REDD_dates[[i]],
                                           nmodels = sweeps4$nmodels[[i]],
                                           seed = sweeps4$seed[[i]],
                                           experiment_leak = sweeps4$experiment_leak[[i]],
                                           experiment_punish = sweeps4$experiment_punish[[i]],
                                           
                                           nsim = 20,
                                           leak = TRUE),
                       mc.cores =40
)


sweep_hypo4 <- list(par = sweeps4,
                    data = cpr_sweeps4)



saveRDS(sweep_hypo4, file = paste0(path$dataAbm, "cpr_sweeps_leak_effort_hypo4.RDS"))



###########################################################################################
######################### THE FULL SET ####################################################

rm(list = ls())
source("cpr/code/abm/cpr_abm_exp.R")
source("cpr/paths.R")
library(parallel)

sweeps5 <- expand.grid(n = c(600),#, 300, 900),
                       wages = c(.1, 0.01),#, .25, .5),
                       max_forest = c(10000),#, 500, 1000),
                       var_forest = 10,
                       regrow = c(0.01),
                       self_policing =c(TRUE),#, FALSE),
                       fine = c(0.00, 0.1),#, 0.5, 1 ),
                       outgroup = c(.01, .9),# 0.1, ),
                       travel_cost = c(0.1),#, .5, 1), 
                       monitor_tech = c(0.5, 2),
                       harvest_limit = c(.90, .5),
                       labor = c(.7),
                       tech = c(1),
                       defensibility = c(300, 900),
                       punish_cost = c(0.003, 0.03),
                       ngroups = 2,
                       groups_sampled = 1,
                       nrounds = 1000, 
                       REDD = c(TRUE, FALSE),
                       cofma_gid = 2,
                       law = .1,
                       REDD_dates  = 75,
                       nmodels = 5,
                       experiment_leak =c(0.0001,.1,.5 ,.9),
                       experiment_punish =c(.5),
                       seed = 10, stringsAsFactors = FALSE)


cpr_sweeps5 <- mclapply(1:nrow(sweeps5),  
                        function(i) cpr_abm(n=sweeps5$n[[i]], 
                                            wages=sweeps5$wages[[i]],
                                            max_forest=sweeps5$max_forest[[i]],
                                            var_forest = sweeps5$var_forest[[i]],
                                            regrow=sweeps5$regrow[[i]], 
                                            
                                            self_policing=sweeps5$self_policing[[i]],                                                        
                                            fine=sweeps5$fine[[i]], 
                                            outgroup=sweeps5$outgroup[[i]], 
                                            travel_cost=sweeps5$travel_cost[[i]], 
                                            monitor_tech= sweeps5$monitor_tech[[i]], 
                                            
                                            harvest_limit=sweeps5$harvest_limit[[i]],
                                            labor = sweeps5$labor[[i]], 
                                            tech = sweeps5$tech[[i]], 
                                            defensibility = sweeps5$defensibility[[i]],
                                            punish_cost = sweeps5$punish_cost[[i]],
                                            
                                            ngroups =sweeps5$ngroups[[i]],
                                            groups_sampled = sweeps5$groups_sampled[[i]],
                                            lattice = c(1,2),
                                            nrounds = sweeps5$nrounds[[i]],
                                            REDD = sweeps5$REDD[[i]],
                                            
                                            cofma_gid = sweeps5$cofma_gid[[i]],
                                            law =sweeps5$law[[i]],
                                            REDD_dates = sweeps5$REDD_dates[[i]],
                                            nmodels = sweeps5$nmodels[[i]],
                                            seed = sweeps5$seed[[i]],
                                            experiment_leak = sweeps5$experiment_leak[[i]],
                                            experiment_punish = sweeps5$experiment_punish[[i]],
                                            
                                            
                                            nsim = 30,
                                            leak = TRUE),
                        mc.cores =40
)


sweep_hypo5 <- list(par = sweeps5,
                    data = cpr_sweeps5)



saveRDS(sweep_hypo5, file = paste0(path$dataAbm, "cpr_sweeps_leak_effort_hypo5.RDS"))

####################################################################################
######################## THE CHAIN #################################################


rm(list = ls())
source("cpr/code/abm/cpr_abm_exp.R")
source("cpr/paths.R")
library(parallel)

sweeps6 <- expand.grid(n = c(900),#, 300, 900),
                       wages = c(.1, 0.01),#, .25, .5),
                       max_forest = c(15000),#, 500, 1000),
                       var_forest = 10,
                       regrow = c(0.01),
                       self_policing =c(TRUE),#, FALSE),
                       fine = c(0.00, 0.1),#, 0.5, 1 ),
                       outgroup = c(.01, .9),# 0.1, ),
                       travel_cost = c(0.9),#, .5, 1), 
                       monitor_tech = c(0.5, 2),
                       harvest_limit = c(.90, .5),
                       labor = c(.7),
                       tech = c(1),
                       defensibility = c(300, 900),
                       punish_cost = c(0.003, 0.03),
                       ngroups = 3,
                       groups_sampled = 1,
                       nrounds = 1000, 
                       REDD = c(TRUE, FALSE),
                       cofma_gid = 2,
                       law = .1,
                       REDD_dates  = 75,
                       nmodels = 5,
                       experiment_leak =c(0.0001,.1,.5 ,.9),
                       experiment_punish =c(.5),
                       seed = 10, stringsAsFactors = FALSE)


cpr_sweeps6 <- mclapply(1:nrow(sweeps6),  
                        function(i) cpr_abm(n=sweeps6$n[[i]], 
                                            wages=sweeps6$wages[[i]],
                                            max_forest=sweeps6$max_forest[[i]],
                                            var_forest = sweeps6$var_forest[[i]],
                                            regrow=sweeps6$regrow[[i]], 
                                            
                                            self_policing=sweeps6$self_policing[[i]],                                                        
                                            fine=sweeps6$fine[[i]], 
                                            outgroup=sweeps6$outgroup[[i]], 
                                            travel_cost=sweeps6$travel_cost[[i]], 
                                            monitor_tech= sweeps6$monitor_tech[[i]], 
                                            
                                            harvest_limit=sweeps6$harvest_limit[[i]],
                                            labor = sweeps6$labor[[i]], 
                                            tech = sweeps6$tech[[i]], 
                                            defensibility = sweeps6$defensibility[[i]],
                                            punish_cost = sweeps6$punish_cost[[i]],
                                            
                                            ngroups =sweeps6$ngroups[[i]],
                                            groups_sampled = sweeps6$groups_sampled[[i]],
                                            lattice = c(1,3),
                                            nrounds = sweeps6$nrounds[[i]],
                                            REDD = sweeps6$REDD[[i]],
                                            
                                            cofma_gid = sweeps6$cofma_gid[[i]],
                                            law =sweeps6$law[[i]],
                                            REDD_dates = sweeps6$REDD_dates[[i]],
                                            nmodels = sweeps6$nmodels[[i]],
                                            seed = sweeps6$seed[[i]],
                                            experiment_leak = sweeps6$experiment_leak[[i]],
                                            experiment_punish = sweeps6$experiment_punish[[i]],
                                            
                                            
                                            nsim = 30,
                                            leak = TRUE),
                        mc.cores =40
)


sweep_hypo6 <- list(par = sweeps6,
                    data = cpr_sweeps6)

check <-function(x){
  mean <- c()
  for(i in 1:length(x)){
    d<-x[[i]][[2]]
    for(i in 1:length(d)){
      temp<-mean(d[[i]])
      mean <- c(mean, temp)
    }
      
    
  }
  return(mean)
}

saveRDS(sweep_hypo6, file = paste0(path$dataAbm, "cpr_sweeps_leak_effort_hypo6.RDS"))



###############################################################################
############### THE BLOCK #####################################################

rm(list = ls())
source("cpr/code/abm/cpr_cmls.R")
source("cpr/paths.R")
library(parallel)

sweeps7 <- expand.grid(n = c(1800),#, 300, 900),
                       wages = c(.1, 0.01),#, .25, .5),
                       max_forest = c(30000),#, 500, 1000),
                       var_forest = 1,
                       regrow = c(0.01),
                       self_policing =c(TRUE),#, FALSE),
                       fine = c(0.00, 0.1),#, 0.5, 1 ),
                       outgroup = c(.01, .9),# 0.1, ),
                       travel_cost = c(0.9),#, .5, 1), 
                       monitor_tech = c(0.5, 2),
                       harvest_limit = c(.90, .5),
                       labor = c(.7),
                       tech = c(1),
                       defensibility = c(300, 900),
                       punish_cost = c(0.003, 0.03),
                       ngroups = 6,
                       groups_sampled = 1,
                       nrounds = 1000, 
                       REDD = c(TRUE, FALSE),
                       cofma_gid = 2,
                       law = .1,
                       REDD_dates  = 75,
                       nmodels = 5,
                       experiment_leak =c(0.0001,.1,.5 ,.9),
                       experiment_punish =c(.5),
                       cmls = c(TRUE, FALSE),
                       seed = 10, stringsAsFactors = FALSE)


cpr_sweeps7 <- mclapply(1:nrow(sweeps7),  
                        function(i) cpr_abm(n=sweeps7$n[[i]], 
                                            wages=sweeps7$wages[[i]],
                                            max_forest=sweeps7$max_forest[[i]],
                                            var_forest = sweeps7$var_forest[[i]],
                                            regrow=sweeps7$regrow[[i]], 
                                            
                                            self_policing=sweeps7$self_policing[[i]],                                                        
                                            fine=sweeps7$fine[[i]], 
                                            outgroup=sweeps7$outgroup[[i]], 
                                            travel_cost=sweeps7$travel_cost[[i]], 
                                            monitor_tech= sweeps7$monitor_tech[[i]], 
                                            
                                            harvest_limit=sweeps7$harvest_limit[[i]],
                                            labor = sweeps7$labor[[i]], 
                                            tech = sweeps7$tech[[i]], 
                                            defensibility = sweeps7$defensibility[[i]],
                                            punish_cost = sweeps7$punish_cost[[i]],
                                            
                                            ngroups =sweeps7$ngroups[[i]],
                                            groups_sampled = sweeps7$groups_sampled[[i]],
                                            lattice = c(1,2),
                                            nrounds = sweeps7$nrounds[[i]],
                                            REDD = sweeps7$REDD[[i]],
                                            
                                            cofma_gid = sweeps7$cofma_gid[[i]],
                                            law =sweeps7$law[[i]],
                                            REDD_dates = sweeps7$REDD_dates[[i]],
                                            nmodels = sweeps7$nmodels[[i]],
                                            seed = sweeps7$seed[[i]],
                                            experiment_leak = sweeps7$experiment_leak[[i]],
                                            experiment_punish = sweeps7$experiment_punish[[i]],
                                            cmls = sweeps7$cmls[[i]],
                                            
                                            nsim = 30,
                                            leak = TRUE),
                        mc.cores =40
)


sweep_hypo7 <- list(par = sweeps7,
                    data = cpr_sweeps7)



saveRDS(sweep_hypo7, file = paste0(path$dataAbm, "cpr_sweeps_leak_effort_hypo7.RDS"))
