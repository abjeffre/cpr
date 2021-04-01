#######################################################################
################### EXAMINE BASE PARAMETER SETTINGS ###################


set.seed(2)
leak_base1 <- cpr_abm(n = 600,  
                wages = .1,
                labor = dat_l$par$labor[a],
                tech = 1,
                regrow = .01,
                max_forest = dat_l$par$max_forest[a],
                var_forest = "binary",
                outgroup = 0.01,
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
                nrounds = 1000, 
                REDD = TRUE,
                cofma_gid = "biggest",
                law = .1,
                REDD_dates  = "leakage",
                nmodels = 5,
                seed = 10)



par(mfrow =c(1,1))
for(i in 1:2){
  plot(NULL, xlim = c(0, 250), ylim = c(0,1))
  lines(rowMeans(leak_base1$punish[[i]]), col=col.alpha("turquoise4", .5))
  lines(rowMeans(leak_base1$leakage[[i]]), col=col.alpha("goldenrod3", .5))
  lines(rowMeans(leak_base1$stock[[i]]), col=col.alpha("green", .2))
  lines(rowMeans(leak_base1$limit [[i]]), col=col.alpha("purple", .2))
  lines(rowMeans(leak_base1$effort [[i]]), col=col.alpha("red", .7))
}




par (mfrow =c(1,2))
for(i in 1:1){
  plot(NULL,  ylim = c(0,1), xlim = c(0 , 250))
  for(j in 1:1)lines((leak_base1$punish[[i]][,j]), col=col.alpha("turquoise4", 1))
  for(j in 1:1)lines((leak_base1$leakage[[i]])[,j], col=col.alpha("goldenrod3", 1))
  for(j in 1:1)lines((leak_base1$stock[[i]][,j]*leak_base1$forsize[[i]][j])/max(leak_base1$forsize[[i]]), col=col.alpha("green", 1))
  for(j in 1:1)lines((leak_base1$limit [[i]][,j]), col=col.alpha("purple", 1))
  for(j in 1:1)lines((leak_base1$effort [[i]][,j]), col=col.alpha("red", 1))
}



for(i in 1:1){
  plot(NULL,  ylim = c(0,1), xlim = c(0 , 250))
  for(j in 2:2)lines((leak_base1$punish[[i]][,j]), col=col.alpha("turquoise4", 1))
  for(j in 2:2)lines((leak_base1$leakage[[i]])[,j], col=col.alpha("goldenrod3", 1))
  for(j in 2:2)lines((leak_base1$stock[[i]][,j]*leak_base1$forsize[[i]][j])/max(leak_base1$forsize[[i]]), col=col.alpha("green", 1))
  for(j in 2:2)lines((leak_base1$limit [[i]][,j]), col=col.alpha("purple", 1))
  for(j in 2:2)lines((leak_base1$effort [[i]][,j]), col=col.alpha("red", 1))
}



par (mfrow =c(1,2))
for(i in 1:1){
  plot(NULL,  ylim = c(0,1), xlim = c(0 , 1000))
  for(j in 1:1)lines((leak_base1$punish[[i]][,j]), col=col.alpha("turquoise4", 1))
  for(j in 1:1)lines((leak_base1$leakage[[i]])[,j], col=col.alpha("goldenrod3", 1))
  for(j in 1:1)lines((leak_base1$stock[[i]][,j]*leak_base1$forsize[[i]][j])/max(leak_base1$forsize[[i]]), col=col.alpha("green", 1))
  for(j in 1:1)lines((leak_base1$limit [[i]][,j]), col=col.alpha("purple", 1))
  for(j in 1:1)lines((leak_base1$effort [[i]][,j]), col=col.alpha("red", 1))
}



for(i in 1:1){
  plot(NULL,  ylim = c(0,1), xlim = c(0 , 1000))
  for(j in 2:2)lines((leak_base1$punish[[i]][,j]), col=col.alpha("turquoise4", 1))
  for(j in 2:2)lines((leak_base1$leakage[[i]])[,j], col=col.alpha("goldenrod3", 1))
  for(j in 2:2)lines((leak_base1$stock[[i]][,j]*leak_base1$forsize[[i]][j])/max(leak_base1$forsize[[i]]), col=col.alpha("green", 1))
  for(j in 2:2)lines((leak_base1$limit [[i]][,j]), col=col.alpha("purple", 1))
  for(j in 2:2)lines((leak_base1$effort [[i]][,j]), col=col.alpha("red", 1))
}


##############################################################################
################### SWEEPS NO LEAKAGE ########################################

leak_base2 <- cpr_abm(n = 600,  
                      wages = .1,
                      labor = dat_l$par$labor[a],
                      tech = 1,
                      regrow = .01,
                      max_forest = dat_l$par$max_forest[a],
                      var_forest = "binary",
                      outgroup = 0.01,
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
                      cofma_gid = "smallest",
                      law = .1,
                      REDD_dates  = "no_leakage",
                      nmodels = 5,
                      seed = 10)



par (mfrow =c(1,2))
for(i in 1:1){
  plot(NULL,  ylim = c(0,1), xlim = c(0 , 1000))
  for(j in 1:1)lines((leak_base2$punish[[i]][,j]), col=col.alpha("turquoise4", 1))
  for(j in 1:1)lines((leak_base2$leakage[[i]])[,j], col=col.alpha("goldenrod3", 1))
  for(j in 1:1)lines((leak_base2$stock[[i]][,j]*leak_base2$forsize[[i]][j])/max(leak_base2$forsize[[i]]), col=col.alpha("green", 1))
  for(j in 1:1)lines((leak_base2$limit [[i]][,j]), col=col.alpha("purple", 1))
  for(j in 1:1)lines((leak_base2$effort [[i]][,j]), col=col.alpha("red", 1))
}



for(i in 1:1){
  plot(NULL,  ylim = c(0,1), xlim = c(0 , 1000))
  for(j in 2:2)lines((leak_base2$punish[[i]][,j]), col=col.alpha("turquoise4", 1))
  for(j in 2:2)lines((leak_base2$leakage[[i]])[,j], col=col.alpha("goldenrod3", 1))
  for(j in 2:2)lines((leak_base2$stock[[i]][,j]*leak_base2$forsize[[i]][j])/max(leak_base2$forsize[[i]]), col=col.alpha("green", 1))
  for(j in 2:2)lines((leak_base2$limit [[i]][,j]), col=col.alpha("purple", 1))
  for(j in 2:2)lines((leak_base2$effort [[i]][,j]), col=col.alpha("red", 1))
}

###############################################################################
#################### RUN SWEEPS TO GENERATE PREDICTIONS #######################
rm(list = ls())
source("cpr/code/abm/cpr_abm_unif.R")
source("cpr/paths.R")
library(parallel)

sweeps <- expand.grid(n = c(600),#, 300, 900),
                      wages = c(.1),#, .25, .5),
                      max_forest = c(10000),#, 500, 1000),
                      var_forest = "binary",
                      regrow = c(0.01),
                      self_policing =c(TRUE),#, FALSE),
                      fine = c(0.00, 0.02),#, 0.5, 1 ),
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
                      cofma_gid = c("biggest", "smallest"),
                      law = .1,
                      REDD_dates  = c("leakage", "no_leakage"),
                      nmodels = 5,
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
                                                       
                                                       nsim = 20,
                                                       leak = TRUE),
                       mc.cores =40
)


sweep_hypo <- list(par = sweeps,
                   data = cpr_sweeps)


saveRDS(sweep_hypo, file = paste0(path$dataAbm, "cpr_sweeps_leak_effort_hypo.RDS"))




########################################################################################
##################### EXTRACT LEAKAGE AND NO LEAKAGE CONDITIONS AND COMPARE EFFORT #####


leak <-which(sweeps$REDD_dates == "leakage")
leakb <-which(sweeps$REDD_dates == "leakage" & sweeps$cofma_gid == "biggest")
leaks <-which(sweeps$REDD_dates == "leakage" & sweeps$cofma_gid == "smallest")

noleak <- which(sweeps$REDD_dates =="no_leakage" )
noleakb <- which(sweeps$REDD_dates =="no_leakage" & sweeps$cofma_gid == "biggest")
noleaks<- which(sweeps$REDD_dates =="no_leakage" & sweeps$cofma_gid == "smallest")

nsim <- 20
#l measures the diffrence in effrot before and after the conservation experiment
#le measures the covariance between leakage and effort
l <- list()
for(i in 1:length(leakb)){
  idl <- leakb[i]
  idn <- noleakb[i]
  
  diff <- matrix(NA, nsim, 3)
  colnames(diff) <- c("leak", "noleak", "diffndiff")
  
  for(j in 1:nsim){
    #Leakage
    d <- cpr_sweeps[[idl]]
    date <-d$reddyear[[j]]
    if(date < 250){
      effort <- d$effort[[j]]
      if(sweeps$cofma_gid[idl] == "biggest" ) cof <- which.max(d$forsize[[j]])
      if(sweeps$cofma_gid[idl] == "smallest" ) cof <- which.min(d$forsize[[j]])
      pre_l <-mean(effort[c((date-10):date), cof])
      post_l <-mean(effort[c((date+1):(date+11)), cof])
      diff[j,1] <- pre_l -post_l
    }
    
    #No Leakage
    d <- cpr_sweeps[[idn]]
    date <-d$reddyear[[j]]
    if(date < 250){
    #Leakage
    effort <- d$effort[[j]]
        if(sweeps$cofma_gid[idn] == "biggest" ) cof <- which.max(d$forsize[[j]])
        if(sweeps$cofma_gid[idn] == "smallest" ) cof <- which.min(d$forsize[[j]])
        pre_l <-mean(effort[c((date-10):date), cof])
        post_l <-mean(effort[c((date+1):(date+11)), cof])
        diff[j,2] <- pre_l -post_l
        
        diff[j,3]<- diff[j,1]-diff[j,2]
      }
  }

    l[[i]] <- diff
}


for(i in 1:length(l))  if(!all(is.na(l[[i]][,3])))  dens(l[[i]][,3], main =i, show.zero =TRUE, show.HPDI = .89 )

dat <- data.frame(l[[1]])
for(i in 1:length(l)) dat <- rbind(dat, l[[i]])


#######################################################################################
################# FIND OUT WHEN THERE IS A STRONG COVARIANCE BETWEEN THEFT AND EFFORT##

le <- list()
for(i in 1:length(cpr_sweeps)){
  d<-cpr_sweeps[[i]]
  
  m <- matrix(NA, nsim, 2)
  for(j in 1:nsim){
    a<-cor(d$effort[[j]][2:250,1], d$leakage[[j]][1:249,2])
    b<-cor(d$effort[[j]][2:250,2], d$leakage[[j]][1:249,1])
    big <-which.max(d$forsize[[j]])
    small <- which.min(d$forsize[[j]])
    
    if(big==1){
      m[j,1] <- a 
      m[j,2] <- b
    }else{
      m[j,1] <- b
      m[j,2] <- a
    }
  }
le[[i]]<- m
}

covar <-sapply(le, colMeans)




str(covar)

var <- list()
for(i in 1:ncol(sweeps)){
  uni <-unique(sweeps[,i])
  ele <-list()
  for(j in 1:length(uni)){
    num <-which(sweeps[,i]==uni[j])
    temp<-colMeans(t(covar[,num]))
    names(temp)<- c("Effort:big, Leakage:small", "Effort:small, Leakage:big")
    ele[[j]]<- temp
  }
  names(ele)<- uni
  var[[i]]<-ele
}
names(var)<- colnames(sweeps)

########################################################################
########## WE LEARN THAT CONDITIONING ON OUTGROUP IS VERY IMPORTANT ####

#NOW WE CONDITION ON OUTGROUP

#PUNISH COST
dens(rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$punish_cost==.02]))
     -rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$punish_cost==.002])))

dens(rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$punish_cost==.02]))
     -rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$punish_cost==.002])))

#REDD+
dens(rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$REDD ==FALSE]))
     -rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$REDD == TRUE])))

dens(rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$REDD == FALSE]))
     -rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$REDD == TRUE])))


#Monitor TECH
dens(rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$monitor_tech==.5]))
     -rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$monitor_tech==2])))

dens(rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$monitor_tech==.5]))
     -rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$monitor_tech==2])))


#Monitor TECH
dens(rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$fine==0]))
     -rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$fine==.02])))

dens(rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$fine==0]))
     -rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$fine==.02])))

###############################################################################
########################## DO PLOT ############################################

le_var<-c(which.max(rowMeans(t(covar))), which.min(rowMeans(t(covar))))
par(mfrow =c(1,1))

for(k in 1:2){
plot(NULL, xlim = c(0, 250), ylim = c(0,1))
for(i in 1:20){
  lines(rowMeans(cpr_sweeps[[le_var[[k]]]]$punish[[i]]), col=col.alpha("turquoise4", .2))
  lines(rowMeans(cpr_sweeps[[le_var[[k]]]]$leakage[[i]]), col=col.alpha("goldenrod3", .2))
 for(j in 1:2) lines((cpr_sweeps[[le_var[[k]]]]$stock[[i]][,j]), col=col.alpha("green", .2))
#  lines(rowMeans(cpr_sweeps[[le_var[[k]]]]$limit [[i]]), col=col.alpha("purple", .2))
  lines(rowMeans(cpr_sweeps[[le_var[[k]]]]$effort [[i]]), col=col.alpha("red", .2))
}
}


for(k in 1:2){
par (mfrow =c(1,2))

formax<- sapply(cpr_sweeps[[le_var[[k]]]]$forsize, which.max)
formin <- sapply(cpr_sweeps[[le_var[[k]]]]$forsize, which.min)
plot(NULL,  ylim = c(0,1), xlim = c(0 , 250))
for(i in 1:20){
 # for(j in formax[i])lines((cpr_sweeps[[le_var[[k]]]]$punish[[i]][,j]), col=col.alpha("turquoise3", .2))
  for(j in formin[i])lines((cpr_sweeps[[le_var[[k]]]]$leakage[[i]])[,j], col=col.alpha("goldenrod3", .2))
  for(j in formax[i])lines((cpr_sweeps[[le_var[[k]]]]$stock[[i]][,j]*cpr_sweeps[[le_var[[k]]]]$forsize[[i]][j])/max(cpr_sweeps[[le_var[[k]]]]$forsize[[i]]), col=col.alpha("green", .2))
  #for(j in 1:1)lines((cpr_sweeps[[le_var[[k]]]]$limit [[i]][,j]), col=col.alpha("purple", .2))
  for(j in formax[i])lines((cpr_sweeps[[le_var[[k]]]]$effort [[i]][,j]), col=col.alpha("red", .2))

}

  plot(NULL,  ylim = c(0,1), xlim = c(0 , 250))
  for(i in 1:20){
  #for(j in formin[i])lines((cpr_sweeps[[le_var[[k]]]]$punish[[i]][,j]), col=col.alpha("turquoise1", .2))
  for(j in formax[i])lines((cpr_sweeps[[le_var[[k]]]]$leakage[[i]])[,j], col=col.alpha("goldenrod3", .2))
  for(j in formin[i])lines((cpr_sweeps[[le_var[[k]]]]$stock[[i]][,j]*cpr_sweeps[[le_var[[k]]]]$forsize[[i]][j])/max(cpr_sweeps[[le_var[[k]]]]$forsize[[i]]), col=col.alpha("green", .2))
  #for(j in 2:2)lines((cpr_sweeps[[le_var]]$limit [[i]][,j]), col=col.alpha("purple", 1))
  for(j in formin[i])lines((cpr_sweeps[[le_var[[k]]]]$effort [[i]][,j]), col=col.alpha("red", .2))
  }

}

########################################################################################
###################### FIND OUT WHEN LEAKAGE AND PUNISH COVARY #########################

le <- list()
for(i in 1:length(cpr_sweeps)){
  d<-cpr_sweeps[[i]]
  
  m <- matrix(NA, nsim, 2)
  for(j in 1:nsim){
    a<-cor(d$punish[[j]][2:250,1], d$leakage[[j]][1:249,2])
    b<-cor(d$punish[[j]][2:250,2], d$leakage[[j]][1:249,1])
    big <-which.max(d$forsize[[j]])
    small <- which.min(d$forsize[[j]])
    
    if(big==1){
      m[j,1] <- a 
      m[j,2] <- b
    }else{
      m[j,1] <- b
      m[j,2] <- a
    }
  }
  le[[i]]<- m
}

covar <-sapply(le, colMeans)




str(covar)

var <- list()
for(i in 1:ncol(sweeps)){
  uni <-unique(sweeps[,i])
  ele <-list()
  for(j in 1:length(uni)){
    num <-which(sweeps[,i]==uni[j])
    temp<-colMeans(t(covar[,num]))
    names(temp)<- c("Effort:big, Leakage:small", "Effort:small, Leakage:big")
    ele[[j]]<- temp
  }
  names(ele)<- uni
  var[[i]]<-ele
}
names(var)<- colnames(sweeps)

########################################################################
########## WE LEARN THAT CONDITIONING ON OUTGROUP IS VERY IMPORTANT ####

#NOW WE CONDITION ON OUTGROUP

#PUNISH COST
dens(rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$punish_cost==.02]))
     -rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$punish_cost==.002])))

dens(rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$punish_cost==.02]))
     -rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$punish_cost==.002])))

#REDD+
dens(rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$REDD ==FALSE]))
     -rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$REDD == TRUE])))

dens(rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$REDD == FALSE]))
     -rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$REDD == TRUE])))


#Monitor TECH
dens(rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$monitor_tech==.5]))
     -rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$monitor_tech==2])))

dens(rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$monitor_tech==.5]))
     -rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$monitor_tech==2])))


#Monitor TECH
dens(rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$fine==0]))
     -rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$fine==.02])))

dens(rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$fine==0]))
     -rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$fine==.02])))

###############################################################################
########################## DO PLOT ############################################

le_var<-c(which.max(rowMeans(t(covar))), which.min(rowMeans(t(covar))))
par(mfrow =c(1,1))

for(k in 1:2){
  plot(NULL, xlim = c(0, 250), ylim = c(0,1))
  for(i in 1:20){
    lines(rowMeans(cpr_sweeps[[le_var[[k]]]]$punish[[i]]), col=col.alpha("turquoise4", .2))
    lines(rowMeans(cpr_sweeps[[le_var[[k]]]]$leakage[[i]]), col=col.alpha("goldenrod3", .2))
    for(j in 1:2) lines((cpr_sweeps[[le_var[[k]]]]$stock[[i]][,j]), col=col.alpha("green", .2))
    #  lines(rowMeans(cpr_sweeps[[le_var[[k]]]]$limit [[i]]), col=col.alpha("purple", .2))
    #lines(rowMeans(cpr_sweeps[[le_var[[k]]]]$effort [[i]]), col=col.alpha("red", .2))
  }
}


for(k in 1:2){
  par (mfrow =c(1,2))
  
  formax<- sapply(cpr_sweeps[[le_var[[k]]]]$forsize, which.max)
  formin <- sapply(cpr_sweeps[[le_var[[k]]]]$forsize, which.min)
  plot(NULL,  ylim = c(0,1), xlim = c(0 , 250))
  for(i in 1:20){
    for(j in formax[i])lines((cpr_sweeps[[le_var[[k]]]]$punish[[i]][,j]), col=col.alpha("turquoise3", .2))
    for(j in formin[i])lines((cpr_sweeps[[le_var[[k]]]]$leakage[[i]])[,j], col=col.alpha("goldenrod3", .2))
    for(j in formax[i])lines((cpr_sweeps[[le_var[[k]]]]$stock[[i]][,j]*cpr_sweeps[[le_var[[k]]]]$forsize[[i]][j])/max(cpr_sweeps[[le_var[[k]]]]$forsize[[i]]), col=col.alpha("green", .2))
    #for(j in 1:1)lines((cpr_sweeps[[le_var[[k]]]]$limit [[i]][,j]), col=col.alpha("purple", .2))
   # for(j in formax[i])lines((cpr_sweeps[[le_var[[k]]]]$effort [[i]][,j]), col=col.alpha("red", .2))
    
  }
  
  plot(NULL,  ylim = c(0,1), xlim = c(0 , 250))
  for(i in 1:20){
    for(j in formin[i])lines((cpr_sweeps[[le_var[[k]]]]$punish[[i]][,j]), col=col.alpha("turquoise1", .2))
    for(j in formax[i])lines((cpr_sweeps[[le_var[[k]]]]$leakage[[i]])[,j], col=col.alpha("goldenrod3", .2))
    for(j in formin[i])lines((cpr_sweeps[[le_var[[k]]]]$stock[[i]][,j]*cpr_sweeps[[le_var[[k]]]]$forsize[[i]][j])/max(cpr_sweeps[[le_var[[k]]]]$forsize[[i]]), col=col.alpha("green", .2))
    #for(j in 2:2)lines((cpr_sweeps[[le_var]]$limit [[i]][,j]), col=col.alpha("purple", 1))
    #for(j in formin[i])lines((cpr_sweeps[[le_var[[k]]]]$effort [[i]][,j]), col=col.alpha("red", .2))
  }
  
}


########################################################################################
###################### FIND OUT WHEN LEAKAGE AND LIMIT COVARY #########################

le <- list()
for(i in 1:length(cpr_sweeps)){
  d<-cpr_sweeps[[i]]
  
  m <- matrix(NA, nsim, 2)
  for(j in 1:nsim){
    a<-cor(d$limit[[j]][2:250,1], d$leakage[[j]][1:249,2])
    b<-cor(d$limit[[j]][2:250,2], d$leakage[[j]][1:249,1])
    big <-which.max(d$forsize[[j]])
    small <- which.min(d$forsize[[j]])
    
    if(big==1){
      m[j,1] <- a 
      m[j,2] <- b
    }else{
      m[j,1] <- b
      m[j,2] <- a
    }
  }
  le[[i]]<- m
}

covar <-sapply(le, colMeans)




str(covar)

var <- list()
for(i in 1:ncol(sweeps)){
  uni <-unique(sweeps[,i])
  ele <-list()
  for(j in 1:length(uni)){
    num <-which(sweeps[,i]==uni[j])
    temp<-colMeans(t(covar[,num]))
    names(temp)<- c("Effort:big, Leakage:small", "Effort:small, Leakage:big")
    ele[[j]]<- temp
  }
  names(ele)<- uni
  var[[i]]<-ele
}
names(var)<- colnames(sweeps)

########################################################################
########## WE LEARN THAT CONDITIONING ON OUTGROUP IS VERY IMPORTANT ####

#NOW WE CONDITION ON OUTGROUP

#PUNISH COST
dens(rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$punish_cost==.02]))
     -rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$punish_cost==.002])))

dens(rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$punish_cost==.02]))
     -rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$punish_cost==.002])))

#REDD+
dens(rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$REDD ==FALSE]))
     -rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$REDD == TRUE])))

dens(rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$REDD == FALSE]))
     -rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$REDD == TRUE])))


#Monitor TECH
dens(rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$monitor_tech==.5]))
     -rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$monitor_tech==2])))

dens(rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$monitor_tech==.5]))
     -rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$monitor_tech==2])))


#Monitor TECH
dens(rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$fine==0]))
     -rowMeans(t(covar[,sweeps$outgroup==0.01 & sweeps$fine==.02])))

dens(rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$fine==0]))
     -rowMeans(t(covar[,sweeps$outgroup==0.9 & sweeps$fine==.02])))

###############################################################################
########################## DO PLOT ############################################

le_var<-c(which.max(rowMeans(t(covar))), which.min(rowMeans(t(covar))))
par(mfrow =c(1,1))

for(k in 1:2){
  plot(NULL, xlim = c(0, 250), ylim = c(0,1))
  for(i in 1:20){
    #lines(rowMeans(cpr_sweeps[[le_var[[k]]]]$punish[[i]]), col=col.alpha("turquoise4", .2))
    lines(rowMeans(cpr_sweeps[[le_var[[k]]]]$leakage[[i]]), col=col.alpha("goldenrod3", .2))
    for(j in 1:2) lines((cpr_sweeps[[le_var[[k]]]]$stock[[i]][,j]), col=col.alpha("green", .2))
     lines(rowMeans(cpr_sweeps[[le_var[[k]]]]$limit [[i]]), col=col.alpha("purple", .2))
    #lines(rowMeans(cpr_sweeps[[le_var[[k]]]]$effort [[i]]), col=col.alpha("red", .2))
  }
}


for(k in 1:2){
  par (mfrow =c(1,2))
  
  formax<- sapply(cpr_sweeps[[le_var[[k]]]]$forsize, which.max)
  formin <- sapply(cpr_sweeps[[le_var[[k]]]]$forsize, which.min)
  plot(NULL,  ylim = c(0,1), xlim = c(0 , 250))
  for(i in 1:20){
    #for(j in formax[i])lines((cpr_sweeps[[le_var[[k]]]]$punish[[i]][,j]), col=col.alpha("turquoise3", .2))
    for(j in formin[i])lines((cpr_sweeps[[le_var[[k]]]]$leakage[[i]])[,j], col=col.alpha("goldenrod3", .2))
    for(j in formax[i])lines((cpr_sweeps[[le_var[[k]]]]$stock[[i]][,j]*cpr_sweeps[[le_var[[k]]]]$forsize[[i]][j])/max(cpr_sweeps[[le_var[[k]]]]$forsize[[i]]), col=col.alpha("green", .2))
    for(j in 1:1)lines((cpr_sweeps[[le_var[[k]]]]$limit [[i]][,j]), col=col.alpha("purple", .2))
     for(j in formax[i])lines((cpr_sweeps[[le_var[[k]]]]$effort [[i]][,j]), col=col.alpha("red", .2))
    
  }
  
  plot(NULL,  ylim = c(0,1), xlim = c(0 , 250))
  for(i in 1:20){
    #for(j in formin[i])lines((cpr_sweeps[[le_var[[k]]]]$punish[[i]][,j]), col=col.alpha("turquoise1", .2))
    for(j in formax[i])lines((cpr_sweeps[[le_var[[k]]]]$leakage[[i]])[,j], col=col.alpha("goldenrod3", .2))
    for(j in formin[i])lines((cpr_sweeps[[le_var[[k]]]]$stock[[i]][,j]*cpr_sweeps[[le_var[[k]]]]$forsize[[i]][j])/max(cpr_sweeps[[le_var[[k]]]]$forsize[[i]]), col=col.alpha("green", .2))
    for(j in 2:2)lines((cpr_sweeps[[le_var[[k]]]]$limit [[i]][,j]), col=col.alpha("purple", .1))
    for(j in formin[i])lines((cpr_sweeps[[le_var[[k]]]]$effort [[i]][,j]), col=col.alpha("red", .2))
  }
  
}

