########################################################
############ CHOOSE WHICH HYPOTHESIS YOU WANT ##########

hypo <- readRDS("/home/jeffrey_andrews/cpr/data/abm/cpr_sweeps_leak_effort_hypo5.RDS")


cpr_sweeps <- hypo$data
sweeps  <- hypo$par



a<-which(sweeps$REDD == FALSE)


match <- matrix(NA, length(a), 3)


ma<-sweeps[a,-which(colnames(sweeps)=="experiment_leak")]
m <- sweeps[a,-which(colnames(sweeps)=="experiment_leak")]

for(i in 1:nrow(ma)){
  cnt <- 1
  for(j in 1:nrow(m)){
    if(i!=j){
      if(all(ma[i,]==m[j,])){
        match[i,cnt] <- a[j]
        cnt <- cnt +1
        if(cnt == 4)break
      }
    }
  }
}

c <-cbind(a, match)
c <- c[1:(length(a)/4),]
for(q in 1:nrow(c)){
  
  par(mfrow=c(1,4))
  for(l in 1:4){
    d<- cpr_sweeps[[c[q,l]]]  
    
    plot(NULL, xlim = c(0, 250), ylim = c(0,1), main = paste(c[q,l]))
    for(i in 1:20){
      lines((d$punish[[i]][,2]), col=col.alpha("turquoise4", .2))
      lines(d$leakage[[i]][,2], col=col.alpha("goldenrod3", .2))
      for(j in 1:2) lines((d$stock[[i]][,j]), col=col.alpha("green", .2))
      lines((d$limit [[i]][,2]), col=col.alpha("purple", .2))
      lines((d$effort [[i]][,2]), col=col.alpha("red", .2))
    }
  }
}

iter <- length(cpr_sweeps[[1]]$effort)
len <- nrow(cpr_sweeps[[1]]$effort[[1]])


# The code below finds the differnce between high and low leakage
effort <- matrix(NA, ncol = iter, nrow = nrow(c))
limit <- matrix(NA, ncol = iter, nrow = nrow(c))
punish <- matrix(NA, ncol = iter, nrow = nrow(c))
leakage <- matrix(NA, ncol = iter, nrow = nrow(c))

for(i in 1:nrow(c)){
  d1<- cpr_sweeps[[c[i,1]]]
  d2<- cpr_sweeps[[c[i,4]]]
  
  for(j in 1:iter){
    effort[i,j]<- mean(d1$effort[[j]][,2]-d2$effort[[j]][,2])
    limit[i,j]<- mean(d1$limit[[j]][,2]-d2$limit[[j]][,2])
    leakage[i,j]<- mean(d1$leakage[[j]][,2]-d2$leakage[[j]][,2])
    punish[i,j]<- mean(d1$punish[[j]][,2]-d2$punish[[j]][,2])
    
  }
}





# FIND APPROPIATE CUT OFF TO DEMARKATE HIGH

effect <- c()
for(i in 1:nrow(c)) effect<-c(effect, c(mean(effort[i,])/sd(effort[i,])))    

sweeps[c[which.min(effect),],]
sweeps[c[which.max(effect),],]

esort<- sort(effect, index.return = TRUE)
ind<- esort$ix[1:4]
table(sweeps[c[ind,1], "punish_cost"])
apply(sweeps[c[ind,1],],2, table)

esort<- sort(effect, index.return = TRUE, decreasing = TRUE)
ind<- esort$ix[1:6]
apply(sweeps[c[ind,1],],2, table)

d <- which(sweeps$outgroup ==.9)
e <-which(sweeps$outgroup ==.01)
outg<-which(c[,1] %in% d)
ing <- which(c[,1] %in% e)


#Plot the maximum effect
esort<- sort(effect, index.return = TRUE)
ind<- esort$ix[1]
low_l<-c[ind,2]
high_l<-c[ind,4]

plot(NULL, xlim = c(0, 1000), ylim = c(0, 1))
for(i in 1:iter) lines(cpr_sweeps[[low_l]]$punish[[i]][,2], col = col.alpha("blue"))
for(i in 1:iter) lines(cpr_sweeps[[high_l]]$punish[[i]][,2], col = col.alpha("red"))

############################ GROUP DIFFRENCES IN HARVEST LIMIT #############

effect <- c()
for(i in 1:nrow(c)) effect<-c(effect, c(mean(limit[i,])/sd(limit[i,])))    

sweeps[c[which.min(effect),],]
sweeps[c[which.max(effect),],]

esort<- sort(effect, index.return = TRUE)
ind<- esort$ix[1:4]
table(sweeps[c[ind,1], "punish_cost"])
apply(sweeps[c[ind,1],],2, table)

esort<- sort(effect, index.return = TRUE, decreasing = TRUE)
ind<- esort$ix[1:6]
apply(sweeps[c[ind,1],],2, table)

d <- which(sweeps$outgroup ==.9)
e <-which(sweeps$outgroup ==.01)
outg<-which(c[,1] %in% d)
ing <- which(c[,1] %in% e)


#Plot the maximum effect
esort<- sort(effect, index.return = TRUE)
ind<- esort$ix[1]
low_l<-c[ind,1]
high_l<-c[ind,4]

plot(NULL, xlim = c(0, 1000), ylim = c(0, 1))
for(i in 1:iter) lines(cpr_sweeps[[low_l]]$limit[[i]][,2], col = col.alpha("blue"))
for(i in 1:iter) lines(cpr_sweeps[[high_l]]$limit[[i]][,2], col = col.alpha("red"))




##############################################################
############## MAKE PLOT #####################################
dev.off()
l1 <- Reduce('+', outg_l$effort)
l2 <- Reduce('+', ing_l$effort)
par(mfrow = c(1,1), mar=c(3,2,2,.5), oma =c(2, 3, 0, 0))
plot(NULL, ylim=c(-3.2, 2), xlim = c(3, 250), ylab = "", xlab = "")
for(i in 1:20)lines(l1[,i], col = col.alpha("goldenrod", .3))
lines(c(-100, 300), c(0, 0), col = 'red')
for(i in 1:20)lines(l2[,i], col = col.alpha("turquoise", .3))
lines(c(-100, 300), c(0, 0), col = 'red')
mtext(side = 1, "Time", outer = T, adj = .55)
mtext(side = 2, "Diff in Effort in \n Response to Leakage", outer = T, adj = .55)
legend("bottomleft",c("High Conformity", "Low Conformity"), fill =c("turquoise", "goldenrod"), cex = .8)






##################################################################
############# DIFFRENT PLOT ######################################

##################################################################
########### EFFECT ON LIMIT ######################################

effect <- c()
for(i in 1:64) effect<-c(effect, c(mean(limit[i,])/sd(limit[i,])))    
which.min(effect)
sweeps[c[20,],]
which.max(effect)
sweeps[c[54,],]


sweeps[c[which.min(effect),],]
sweeps[c[which.max(effect),],]

esort<- sort(effect, index.return = TRUE)
ind<- esort$ix[1:6]
table(sweeps[c[ind,1], "punish_cost"])
apply(sweeps[c[ind,1],],2, table)

esort<- sort(effect, index.return = TRUE, decreasing = TRUE)
ind<- esort$ix[1:6]
apply(sweeps[c[ind,1],],2, table)

####################################################################
################## EFFECT OF LEAKAGE ###############################

effect <- c()
for(i in 1:64) effect<-c(effect, c(mean(leakage[i,])/sd(leakage[i,])))    
which.min(effect)
sweeps[c[20,],]
which.max(effect)
sweeps[c[54,],]



sweeps[c[which.min(effect),],]
sweeps[c[which.max(effect),],]

esort<- sort(effect, index.return = TRUE)
ind<- esort$ix[1:6]
table(sweeps[c[ind,1], "punish_cost"])
apply(sweeps[c[ind,1],],2, table)

esort<- sort(effect, index.return = TRUE, decreasing = TRUE)
ind<- esort$ix[1:6]
apply(sweeps[c[ind,1],],2, table)



#####################################################################
################### EFFECT ON PUNISHMENT ###########################

effect <- c()
for(i in 1:64) effect<-c(effect, c(mean(punish[i,])/sd(punish[i,])))    
which.min(effect)
sweeps[c[20,],]
which.max(effect)
sweeps[c[54,],]



sweeps[c[which.min(effect),],]
sweeps[c[which.max(effect),],]

esort<- sort(effect, index.return = TRUE)
ind<- esort$ix[1:6]
table(sweeps[c[ind,1], "punish_cost"])
apply(sweeps[c[ind,1],],2, table)

esort<- sort(effect, index.return = TRUE, decreasing = TRUE)
ind<- esort$ix[1:6]
apply(sweeps[c[ind,1],],2, table)











#########################################################
############# Find limit and effort is low ##############

limit <- c()
for(i in 1:length(cpr_sweeps)){
  lim <- c()
  for(j in 1:iter) lim<- c(lim, mean(cpr_sweeps[[i]]$limit[[j]][,2]))
  limit <- c(limit, lim)
}

punish <- c()
for(i in 1:length(cpr_sweeps)){
  pun <- c()
  for(j in 1:iter) pun<- c(lim, mean(cpr_sweeps[[i]]$punish[[j]][,2]))
  punish <- c(punish, pun)
}


stock <- c()
for(i in 1:length(cpr_sweeps)){
  sto <- c()
  for(j in 1:iter) sto<- c(sto, mean(cpr_sweeps[[i]]$stock[[j]][,2]))
  sto <- c(sto, stock)
}

#first find out when limit and punishment correspond
eff2lim <- effort/limit

