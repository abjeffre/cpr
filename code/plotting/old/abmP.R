#########################################################
################# Plotting ABM ##########################

###################
##    Goals
##
##1. Show relationship between leakage and Insitutions
##2. Show how that relationship varies by resource type
##
##
##
####################
library(rethinking)
source(paste0(path$script, "abm_data_build.R"))
dat_l <- full 

dat <- dat_l$data


corrs <- rep(NA, length(dat))
for(i in 1:length(corrs)){
  temp <- rep(NA, 10)
  for(j in 1:10){
    temp[j] <- cor(rowMeans(dat[[i]]$punish[[j]]), rowMeans(dat[[i]]$leakage[[j]]))
    corrs[i] <- mean(temp)
  }
}



corrs_pf <- rep(NA, length(dat))
for(i in 1:length(corrs_pf)){
  temp <- rep(NA, 10)
  for(j in 1:10){
    temp[j] <- cor(rowMeans(dat[[i]]$punish[[j]]), rowMeans(dat[[i]]$stock[[j]]))
    corrs_pf[i] <- mean(temp)
  }
}

hist(corrs_pf)

corrs_lf <- rep(NA, length(dat))
for(i in 1:length(corrs_lf)){
  temp <- rep(NA, 10)
  for(j in 1:10){
    temp[j] <- cor(rowMeans(dat[[i]]$leakage[[j]]), rowMeans(dat[[i]]$stock[[j]]))
    corrs_lf[i] <- mean(temp)
  }
}

hist(corrs_lf)


hist(corrs_lf)

corrs_le <- rep(NA, length(dat))
for(i in 1:length(corrs_le)){
  temp <- rep(NA, 10)
  for(j in 1:10){
    temp[j] <- cor(rowMeans(dat[[i]]$limit[[j]]), (dat[[i]]$effort[[j]]))
    corrs_le[i] <- mean(temp)
  }
}

hist(corrs_le)



##############################################################
################ Check for Large Correlations ################

a <- which(corrs >.3)
apply(dat_l$par[a,], 2, table)

b<-which(corrs == max(corrs))

plot(rowMeans(dat[[b]]$punish[[1]]), type = "l", col=col.alpha("turquoise4", .4),  ylim = c(0,1) )
for(i in 2:10) lines(rowMeans(dat[[b]]$punish[[i]]), col=col.alpha("turquoise4", .4))
for(i in 1:10) lines(rowMeans(dat[[b]]$leakage[[i]]), col=col.alpha("goldenrod3", .5))
for(i in 1:10) lines(rowMeans(dat[[b]]$stock[[i]]), col=col.alpha("green", .4))


plot(rowMeans(dat[[b]]$punish[[7]]), type = "l", col=col.alpha("turquoise4", .4),  ylim = c(0,1) )
for(i in 7:7) lines(rowMeans(dat[[b]]$leakage[[i]]), col=col.alpha("goldenrod3", .5))
for(i in 7:7) lines(rowMeans(dat[[b]]$stock[[i]]), col=col.alpha("green", .4))


##########################
## CHECK WAGE LABOR ######



wage <- rep(NA, length(dat))
for(i in 1:length(corrs)){
  temp <- rep(NA, 10)
  for(j in 1:10){
    temp[j] <- mean(dat[[i]]$wages[[j]])
    wage[i] <- mean(temp)
  }
}
rowMeans(dat[[b]]$seized[[i]])

##############################
### CHECK STOCK ##############

stock <- rep(NA, length(dat))
for(i in 1:length(corrs)){
  temp <- rep(NA, 10)
  for(j in 1:10){
    temp[j] <- mean(rowMeans(dat[[i]]$stock[[j]]))
    stock[i] <- mean(temp)
  }
}


##############################
### CHECK PUNISH ##############

punish <- rep(NA, length(dat))
for(i in 1:length(corrs)){
  temp <- rep(NA, 10)
  for(j in 1:10){
    temp[j] <- mean(rowMeans(dat[[i]]$punish[[j]]))
    punish[i] <- mean(temp)
  }
}



mean(punish)
a <- which(punish==max(punish))
for(i in 1:10)v[i] <- cor(rowMeans(dat[[a]]$leakage[[i]]), rowMeans(dat[[a]]$punish[[i]]))

for(i in 1:10){
plot(rowMeans(dat[[a]]$punish[[i]]), type = "l", col=col.alpha("turquoise4", .8),  ylim = c(0,1) )
#for(i in 2:10) lines(rowMeans(dat[[a]]$punish[[i]]), col=col.alpha("turquoise4", .4))
for(i in i:i) lines(rowMeans(dat[[a]]$leakage[[i]]), col=col.alpha("goldenrod3", .8))
for(i in i:i) lines(rowMeans(dat[[a]]$stock[[i]]), col=col.alpha("green", .8))
for(i in i:i) lines(rowMeans(dat[[a]]$limit [[i]]), col=col.alpha("purple", .8))
for(i in i:i) lines(dat[[a]]$effort [[i]], col=col.alpha("black", .8))
}


###########################################
### CHECK PUNISH FOR INCOME  ##############

inc_learn <- which(dat_l$par$learn_type=="income")
punish <- rep(NA, length(inc_learn))
for(i in inc_learn){
  temp <- rep(NA, 10)
  for(j in 1:10){
    temp[j] <- mean(rowMeans(dat[[i]]$punish[[j]]))
    punish[i] <- mean(temp)
  }
}

mean(punish)
a <- which(punish==max(punish))
for(i in 1:10)v[i] <- cor(rowMeans(dat[[a]]$leakage[[i]]), rowMeans(dat[[a]]$punish[[i]]))

dat_l$par[a,]


for(i in 1:10){
  plot(rowMeans(dat[[a]]$punish[[i]]), type = "l", col=col.alpha("turquoise4", .8),  ylim = c(0,1) )
  #for(i in 2:10) lines(rowMeans(dat[[a]]$punish[[i]]), col=col.alpha("turquoise4", .4))
  for(i in i:i) lines(rowMeans(dat[[a]]$leakage[[i]]), col=col.alpha("goldenrod3", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$stock[[i]]), col=col.alpha("green", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$limit [[i]]), col=col.alpha("purple", .8))
  for(i in i:i) lines(dat[[a]]$effort [[i]], col=col.alpha("black", .8))
}



##############################
### CHECK Limit ##############

limit <- rep(NA, length(dat))
for(i in 1:length(corrs)){
  temp <- rep(NA, 10)
  for(j in 1:10){
    temp[j] <- mean(rowMeans(dat[[i]]$limit[[j]]))
    limit[i] <- mean(temp)
  }
}



hist(limit)
a <- which(limit==min(limit))
dat_l$par[a,]

for(i in 1:10){
  plot(rowMeans(dat[[a]]$punish[[i]]), type = "l", col=col.alpha("turquoise4", .8),  ylim = c(0,1) )
  #for(i in 2:10) lines(rowMeans(dat[[a]]$punish[[i]]), col=col.alpha("turquoise4", .4))
  for(i in i:i) lines(rowMeans(dat[[a]]$leakage[[i]]), col=col.alpha("goldenrod3", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$stock[[i]]), col=col.alpha("green", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$limit [[i]]), col=col.alpha("purple", .8))
  for(i in i:i) lines(dat[[a]]$effort [[i]], col=col.alpha("black", .8))
}


###########################################
### CHECK LIMIT FOR WEALTH  ##############

inc_learn <- which(dat_l$par$learn_type=="wealth")
limit <- rep(NA, length(inc_learn))
for(i in inc_learn){
  temp <- rep(NA, 10)
  for(j in 1:10){
    temp[j] <- mean(rowMeans(dat[[i]]$limit[[j]]))
    limit[i] <- mean(temp)
  }
}

mean(limit)
a <- which(limit==min(limit, na.rm =T))

dat_l$par[a,]


for(i in 1:10){
  plot(rowMeans(dat[[a]]$punish[[i]]), type = "l", col=col.alpha("turquoise4", .8),  ylim = c(0,1) )
  #for(i in 2:10) lines(rowMeans(dat[[a]]$punish[[i]]), col=col.alpha("turquoise4", .4))
  for(i in i:i) lines(rowMeans(dat[[a]]$leakage[[i]]), col=col.alpha("goldenrod3", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$stock[[i]]), col=col.alpha("green", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$limit [[i]]), col=col.alpha("purple", .8))
  for(i in i:i) lines(dat[[a]]$effort [[i]], col=col.alpha("black", .8))
}




############################################################
############### CHECK FOR CORRS AND PUNISH #################

a <- which(corrs >.3 & punish>.3)
apply(dat_l$par[a,], 2, table)
b<- which(corrs*punish > .15)
apply(dat_l$par[b,], 2, table)

a <- which.max(corrs*punish)

dat_l$par[a,]
for(i in 1:10){
  plot(rowMeans(dat[[a]]$punish[[i]]), type = "l", col=col.alpha("turquoise4", .8),  ylim = c(0,1) )
  #for(i in 2:10) lines(rowMeans(dat[[a]]$punish[[i]]), col=col.alpha("turquoise4", .4))
  for(i in i:i) lines(rowMeans(dat[[a]]$leakage[[i]]), col=col.alpha("goldenrod3", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$stock[[i]]), col=col.alpha("green", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$limit [[i]]), col=col.alpha("purple", .8))
  for(i in i:i) lines(dat[[a]]$effort [[i]], col=col.alpha("black", .8))
}


#################################################################################3
############### CHECK FOR CORRS AND PUNISH WHEN GROUP SIZE IS BIG #################

big <- which(dat_l$par$n == 675)
a <- which((corrs >.3 & punish>.3) & dat_l$par$n == 675)

apply(dat_l$par[a,], 2, table)


a <- sort(corrs*punish, index.return = T, decreasing = TRUE)
dat_l$par[a$ix[9],]
a <- a$ix[9]

dat_l$par[a,]
for(i in 1:10){
  plot(rowMeans(dat[[a]]$punish[[i]]), type = "l", col=col.alpha("turquoise4", .8),  ylim = c(0,1) )
  #for(i in 2:10) lines(rowMeans(dat[[a]]$punish[[i]]), col=col.alpha("turquoise4", .4))
  for(i in i:i) lines(rowMeans(dat[[a]]$leakage[[i]]), col=col.alpha("goldenrod3", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$stock[[i]]), col=col.alpha("green", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$limit [[i]]), col=col.alpha("purple", .8))
  for(i in i:i) lines(dat[[a]]$effort [[i]], col=col.alpha("black", .8))
}

##########################################################################
################ CHECK WHEN FOREST ARE SAVED BY INSITUTIONS ##############


a <- which(corrs_pf >.3)
apply(dat_l$par[a,], 2, table)

a <- which.min(corrs_pf)

dat_l$par[a,]
for(i in 1:10){
  plot(rowMeans(dat[[a]]$punish[[i]]), type = "l", col=col.alpha("turquoise4", .8),  ylim = c(0,1) )
  #for(i in 2:10) lines(rowMeans(dat[[a]]$punish[[i]]), col=col.alpha("turquoise4", .4))
  for(i in i:i) lines(rowMeans(dat[[a]]$leakage[[i]]), col=col.alpha("goldenrod3", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$stock[[i]]), col=col.alpha("green", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$limit [[i]]), col=col.alpha("purple", .8))
  for(i in i:i) lines(dat[[a]]$effort [[i]], col=col.alpha("black", .8))
}




##########################################################################
################ CHECK WHEN EFFORT AND LIMIT ###########################


a <- which(corrs_le >.3)
apply(dat_l$par[a,], 2, table)

t<-sort(corrs_le*(1-limit), decreasing = TRUE, index.return = T)
a<- t$ix[26]

#FIVE IS VERY GOOD
#SO is 10
#SO is 14
#SO IS 17***
#SO IS 24 ***
dat_l$par[a,]
for(i in 1:10){
  plot(rowMeans(dat[[a]]$punish[[i]]), type = "l", col=col.alpha("turquoise4", .8),  ylim = c(0,1) )
  #for(i in 2:10) lines(rowMeans(dat[[a]]$punish[[i]]), col=col.alpha("turquoise4", .4))
  for(i in i:i) lines(rowMeans(dat[[a]]$leakage[[i]]), col=col.alpha("goldenrod3", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$stock[[i]]), col=col.alpha("green", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$limit [[i]]), col=col.alpha("purple", .8))
  for(i in i:i) lines(dat[[a]]$effort [[i]], col=col.alpha("black", .8))
}


#########################################################################
###################### LINKAGE BETWEEN LIMIT AND LEAKAGE#################


corrs_ll <- rep(NA, length(dat))
for(i in 1:length(corrs_ll)){
  temp <- rep(NA, 10)
  for(j in 1:10){
    temp[j] <- cor(rowMeans(dat[[i]]$limit[[j]]), rowMeans(dat[[i]]$leakage[[j]]))
    corrs_ll[i] <- mean(temp)
  }
}
hist(corrs_ll)
dens(corrs_ll)
a <- which(corrs_ll < (-0.4))
apply(dat_l$par[a,], 2, table)



t<-sort((-corrs_ll)*(1-limit), decreasing = TRUE, index.return = T)
apply(dat_l$par[t$ix[1:100],], 2, table)

a<- t$ix[9]


#FIVE IS INTERESTING
#SOMETHING GOING ON IN 9


for(i in 1:10){
  plot(rowMeans(dat[[a]]$punish[[i]]), type = "l", col=col.alpha("turquoise4", .2),  ylim = c(0,1) )
  #for(i in 2:10) lines(rowMeans(dat[[a]]$punish[[i]]), col=col.alpha("turquoise4", .4))
  for(i in i:i) lines(rowMeans(dat[[a]]$leakage[[i]]), col=col.alpha("goldenrod3", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$stock[[i]]), col=col.alpha("green", .8))
  for(i in i:i) lines(rowMeans(dat[[a]]$limit [[i]]), col=col.alpha("purple", .8))
  for(i in i:i) lines(dat[[a]]$effort [[i]], col=col.alpha("black", .2))
}

