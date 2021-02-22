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
dat_l <- leak 

dat <- dat_l$data


corrs <- rep(NA, length(dat))
for(i in 1:length(corrs)){
  temp <- rep(NA, 10)
  for(j in 1:10){
    temp[j] <- cor(rowMeans(dat[[i]]$punish[[j]]), rowMeans(dat[[i]]$leakage[[j]]))
    corrs[i] <- mean(temp)
  }
}

###########################################################################
######## GET THE MARGINAL CORRELATIONS FOR EACH PARAMETER SETTING #########

cor_l <- list()
for(i in 1:ncol(dat_l$par)){
  rows <- (table(dat_l$par[,i]))[1]
  pars <- unique(dat_l$par[,i])
  m <- matrix(NA, ncol = length(pars), nrow =rows)
  for(j in 1:length(pars)){
    match <-which(dat_l$par[,i]==pars[j])
    m[,j] <- corrs[match]
  }
  cor_l[[i]]<- m
}
names(cor_l) <- colnames(dat_l$par)

marginal_cor<- sapply(cor_l, colMeans)
names(marginal_cor) <- colnames(dat_l$par)


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
a <- which(punish==max(punish[1:2000]))
for(i in 1:10)v[i] <- cor(rowMeans(dat[[a]]$leakage[[i]]), rowMeans(dat[[a]]$punish[[i]]))

for(i in 3:3){
plot(rowMeans(dat[[a]]$punish[[i]]), type = "l", col=col.alpha("turquoise4", .8),  ylim = c(0,1) )
#for(i in 2:10) lines(rowMeans(dat[[a]]$punish[[i]]), col=col.alpha("turquoise4", .4))
for(i in i:i) lines(rowMeans(dat[[a]]$leakage[[i]]), col=col.alpha("goldenrod3", .8))
#for(i in i:i) lines(rowMeans(dat[[a]]$stock[[i]]), col=col.alpha("green", .4))
}

legend("topleft", c("Enforcers", "Leakers"), fill = sapply(c("goldenrod3", "turquoise4"), col.alpha, .8), cex = 0.75)

for(i in i:i) lines(dat[[a]]$effort[[i]], col=col.alpha("purple", .4))