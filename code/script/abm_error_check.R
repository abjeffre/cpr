source("cpr/code/abm/cpr_inst_wlimit_continious_gen.R")
source("cpr/paths.R")
library(parallel)
sweeps <- expand.grid(n = c(135, 675),#, 300, 900),
                      #wages = c(0.025, 0.05, 0.075),
                      max_forest = c(200, 2000),#, 500, 1000),
                      var_forest = c(10, 50),
                      regrow = c(0.03, 0.07),
                      self_policing =c(FALSE),#, TRUE),
                      fine = c(0.00),#, 0.5, 1 ),
                      outgroup = c(.1, .9),# 0.1, ),
                      travel_cost = c(0.1),#, .5, 1), 
                      monitor_tech = c(0.1, 1, 5),
                      harvest_limit = c(0.05,.20),
                      labor = c(0.3, .7),
                      tech = c(0.04, 0.06),
                      defensibility = c(15, 30)
)

set.seed(2021)
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
                                                       defensibility = sweeps$defensibility[[i]],
                                                       nsim = 10,
                                                       ngroups = 9,
                                                       leak = TRUE,
                                                       lattice = c(3, 3),
                                                       nrounds = 1000),
                       mc.cores =70
)


sweep_leak <- list(par = sweeps,
                     data = cpr_sweeps)

saveRDS(sweep_leak, file = paste0(path$dataAbm, "cpr_sweeps_leak.RDS"))


