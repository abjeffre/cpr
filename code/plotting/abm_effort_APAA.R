source("cpr/code/scripts/abm_effort_exploration.R")
########## COMPARE IN GROUP TO OUTGROUP DIFFRENCE IN HARVEST ########

temp <- readRDS("/home/jeffrey_andrews/cpr/data/abm/cpr_sweeps_leak_effort_hypo5.RDS")
cpr_sweeps<- temp$data
sweeps <- temp$par

a<-1:nrow(sweeps)


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

#for(q in 1:nrow(c)){
#  
#  par(mfrow=c(1,4))
#  for(l in 1:4){
#    d<- cpr_sweeps[[c[q,l]]]  
#    
#    plot(NULL, xlim = c(0, 250), ylim = c(0,1), main = paste(c[q,l]))
#    for(i in 1:20){
#      lines((d$punish[[i]][,2]), col=col.alpha("turquoise4", .2))
#      lines(d$leakage[[i]][,2], col=col.alpha("goldenrod3", .2))
#      for(j in 1:2) lines((d$stock[[i]][,j]), col=col.alpha("green", .2))
#      lines((d$limit [[i]][,2]), col=col.alpha("purple", .2))
#      lines((d$effort [[i]][,2]), col=col.alpha("red", .2))
#    }
#  }
#}


iter <- length(cpr_sweeps[[1]]$effort)
len <- nrow(cpr_sweeps[[1]]$effort[[1]])


low_l <- list()
for(i in 1:nrow(c)){
  d1<- cpr_sweeps[[c[i,2]]]

  
  stock <- matrix(NA, ncol = iter, nrow = len)
  punish <- matrix(NA, ncol = iter, nrow = len)
  effort <- matrix(NA, ncol = iter, nrow = len)
  effort_other <- matrix(NA, ncol = iter, nrow = len)
  limit <- matrix(NA, ncol = iter, nrow = len)
  leakage <- matrix(NA, ncol = iter, nrow = len)
  for(j in 1:iter){
    effort[,j]<- (d1$effort[[j]][,2])
    effort_other[,j]<- (d1$effort[[j]][,1])
    stock[,j]<- (d1$stock[[j]][,2])
    punish[,j]<- (d1$punish[[j]][,2])
    limit[,j]<- (d1$limit[[j]][,2])
    leakage[,j]<- (d1$leakage[[j]][,2])
    
    }
  low_l$effort[[i]] <- effort
  low_l$stock[[i]] <- stock
  low_l$punish[[i]] <- punish
  low_l$limit[[i]] <- limit
  low_l$leakage[[i]] <- leakage
  low_l$effort_other[[i]] <- effort_other
  
}

high_l <- list()
for(i in 1:nrow(c)){
  d1<- cpr_sweeps[[c[i,4]]]
  
  punish <- matrix(NA, ncol = iter, nrow = len)
  stock <-matrix(NA, ncol = iter, nrow = len)
  effort <- matrix(NA, ncol = iter, nrow = len)
  effort_other <- matrix(NA, ncol = iter, nrow = len)
  limit <- matrix(NA, ncol = iter, nrow = len)
  leakage <- matrix(NA, ncol = iter, nrow = len)
  
  for(j in 1:iter){
    effort[,j]<- (d1$effort[[j]][,2])
    effort_other[,j]<- (d1$effort[[j]][,1])
    stock[,j]<- (d1$stock[[j]][,2])
    punish[,j]<- (d1$punish[[j]][,2])
    limit[,j]<- (d1$limit[[j]][,2])
    leakage[,j]<- (d1$leakage[[j]][,2])
  }
  high_l$effort[[i]] <- effort
  high_l$stock[[i]] <- stock
  high_l$punish[[i]] <- punish
  high_l$limit[[i]] <- limit
  high_l$leakage[[i]] <- leakage
  high_l$effort_other[[i]] <- effort_other
}



##############################################################
############## MAKE PLOT #####################################
dev.off()
l1 <- Reduce('+', high_l$effort)/nrow(c)
l2 <- Reduce('+', low_l$effort)/nrow(c)
lo1 <- Reduce('+', high_l$effort_other)/nrow(c)
lo2 <- Reduce('+', low_l$effort_other)/nrow(c)

s1 <- Reduce('+', high_l$stock)/nrow(c)
s2 <- Reduce('+', low_l$stock)/nrow(c)
p1 <- Reduce('+', high_l$punish)/nrow(c)
p2 <- Reduce('+', low_l$punish)/nrow(c)
t1 <- Reduce('+', high_l$limit)/nrow(c)
t2 <- Reduce('+', low_l$limit)/nrow(c)
k1 <- Reduce('+', high_l$leakage)/nrow(c)
k2 <- Reduce('+', low_l$leakage)/nrow(c)


par(mfrow = c(1,1), mar=c(3,2,2,.5), oma =c(2, 3, 0, 0))
plot(NULL, ylim=c(0, 1), xlim = c(3, 250), ylab = "", xlab = "")
for(i in 1:20)lines(l1[,i], col = col.alpha("goldenrod", .3))
for(i in 1:20)lines(s1[,i], col = col.alpha("forestgreen", .1))
for(i in 1:20)lines(k1[,i], col = col.alpha("red", .1))
#for(i in 1:20)lines(lo1[,i], col = col.alpha("grey", .1))
for(i in 1:20)lines(l2[,i], col = col.alpha("turquoise", .3))
for(i in 1:20)lines(s2[,i], col = col.alpha("forestgreen", .1))
for(i in 1:20)lines(k2[,i], col = col.alpha("purple", .1))
#for(i in 1:20)lines(lo2[,i], col = col.alpha("black", .1))
#lines(c(-100, 300), c(0, 0), col = 'red')
mtext(side = 1, "Time", outer = T, adj = .55)
mtext(side = 2, "Harvest Effort", outer = T, adj = .55)
legend("bottomleft",title = "Effort",c("Low Competition", "High Competition"), fill =c("turquoise", "goldenrod"), cex = .7)
#legend("topright", title= "Leakage",c("Low Competition", "High Competition"), fill =c("purple", "red"), cex = .8)




par(mfrow = c(1,1), mar=c(3,2,2,.5), oma =c(2, 3, 0, 0))
plot(NULL, ylim=c(0, 1), xlim = c(3, 250), ylab = "", xlab = "")
for(i in 1:20)lines(l1[,i], col = col.alpha("goldenrod", .3))
for(i in 1:20)lines(s1[,i], col = col.alpha("forestgreen", .1))
for(i in 1:20)lines(k1[,i], col = col.alpha("red", .1))
for(i in 1:20)lines(l2[,i], col = col.alpha("turquoise", .3))
for(i in 1:20)lines(s2[,i], col = col.alpha("forestgreen", .1))
for(i in 1:20)lines(k2[,i], col = col.alpha("purple", .1))
#lines(c(-100, 300), c(0, 0), col = 'red')
mtext(side = 1, "Time", outer = T, adj = .55)
mtext(side = 2, "Harvest Effort", outer = T, adj = .55)
legend("bottomleft",title = "Effort", c("Low Competition", "High Competition"), fill =c("turquoise", "goldenrod"), cex = .7)
legend("topright", title= "Leakage",c("Low Competition", "High Competition"), fill =c("purple", "red"), cex = .7)

#########################################################################
############# SUBSET PLOTS ##############################################

#choose here what variables you want to subset on 
ind <- which(((((sweeps$outgroup==.01 & sweeps$REDD == FALSE) &
  sweeps$defensibility == 900)& sweeps$monitor_tech == .5) &
  sweeps$fine == 0) & sweeps$wages==.1)
sub<-which(apply(c, 1,function(x)any(x %in% ind)))

high_l_s <- list()
low_l_s <- list()
for(i in 1:length(high_l))high_l_s[[i]] <- high_l[[i]][sub]
for(i in 1:length(low_l))low_l_s[[i]] <- low_l[[i]][sub]
names(low_l_s) <- names(low_l)
names(high_l_s) <- names(high_l)


l1 <- Reduce('+', high_l_s$effort)/(length(ind)/4)
l2 <- Reduce('+', low_l_s$effort)/(length(ind)/4)
lo1 <- Reduce('+', high_l_s$effort_other)/(length(ind)/4)
lo2 <- Reduce('+', low_l_s$effort_other)/(length(ind)/4)

s1 <- Reduce('+', high_l_s$stock)/(length(ind)/4)
s2 <- Reduce('+', low_l_s$stock)/(length(ind)/4)
p1 <- Reduce('+', high_l_s$punish)/(length(ind)/4)
p2 <- Reduce('+', low_l_s$punish)/(length(ind)/4)
t1 <- Reduce('+', high_l_s$limit)/(length(ind)/4)
t2 <- Reduce('+', low_l_s$limit)/(length(ind)/4)
k1 <- Reduce('+', high_l_s$leakage)/(length(ind)/4)
k2 <- Reduce('+', low_l_s$leakage)/(length(ind)/4)

#effort
par(mfrow = c(2,2), mar=c(3,2,2,.5), oma =c(0, 0, 0, 0))
plot(NULL, ylim=c(0, 1), xlim = c(3, 1000), ylab = "", xlab = "", main = "effort")
for(i in 1:iter)lines(l1[,i], col = col.alpha("goldenrod", .3))
for(i in 1:iter)lines(s1[,i], col = col.alpha("forestgreen", .1))
#for(i in 1:20)lines(lo1[,i], col = col.alpha("grey", .1))
for(i in 1:iter)lines(l2[,i], col = col.alpha("turquoise", .3))
for(i in 1:iter)lines(s2[,i], col = col.alpha("green", .1))

#for(i in 1:iter)lines(lo2[,i], col = col.alpha("black", .1))
#lines(c(-100, 300), c(0, 0), col = 'red')
mtext(side = 1, "Time", outer = T, adj = .55)
mtext(side = 2, "Harvest Effort", outer = T, adj = .55)
#legend("bottomleft",title = "Effort",c("Low Competition", "High Competition"), fill =c("turquoise", "goldenrod"), cex = .7)
#legend("topright", title= "Leakage",c("Low Competition", "High Competition"), fill =c("purple", "red"), cex = .8)


plot(NULL, ylim=c(0, 1), xlim = c(3, 1000), ylab = "", xlab = "", main = "enforce")
for(i in 1:iter)lines(s2[,i], col = col.alpha("green", .1))
for(i in 1:iter)lines(p2[,i], col = col.alpha("purple", .1))
for(i in 1:iter)lines(p1[,i], col = col.alpha("red", .1))
for(i in 1:iter)lines(s1[,i], col = col.alpha("forestgreen", .1))


plot(NULL, ylim=c(-1, 1), xlim = c(3, 1000), ylab = "", xlab = "", main = "limit-effort")
#for(i in 1:iter)lines(s2[,i], col = col.alpha("green", .1))

for(i in 1:iter)lines(t1[,i]-l1[,i], col = col.alpha("firebrick", .1))
for(i in 1:iter)lines(t2[,i]-l2[,i], col = col.alpha("dodgerblue", .1))
for(i in 1:iter)lines(t2[,i], col = col.alpha("purple", .2))
for(i in 1:iter)lines(t1[,i], col = col.alpha("yellow", .1))
lines(c(-100, 2000), c(0, 0), col = "red")
#for(i in 1:iter)lines(s1[,i], col = col.alpha("forestgreen", .1))


plot(NULL, ylim=c(0, 1), xlim = c(3, 1000), ylab = "", xlab = "", main = "leakage")
for(i in 1:iter)lines(s2[,i], col = col.alpha("green", .1))
for(i in 1:iter)lines(k2[,i], col = col.alpha("black", .1))
for(i in 1:iter)lines(k1[,i], col = col.alpha("grey", .1))
for(i in 1:iter)lines(s1[,i], col = col.alpha("forestgreen", .1))

