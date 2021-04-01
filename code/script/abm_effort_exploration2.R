
data <- readRDS(file = paste0(path$dataAbm, "cpr_sweeps_leak_effort_hypo2.RDS"))

a<-which(sweeps$experiment==0.1 & sweeps$REDD == FALSE)

match <- rep(NA, length(a))
for(i in 1:length(a)){
  ma<-sweeps[a,-which(colnames(sweeps)=="REDD")]
  m <- sweeps[,-which(colnames(sweeps)=="REDD")]
  for(i in 1:nrow(ma)){
    for(j in 1:nrow(m)){
      if(a[i]!=j){
        if(all(ma[i,]==m[j,])){
          match[i] <- j
          break
        }
      }
    }
  }
}

b<-match


c<- matrix(c(a,b),ncol=2)

for(q in 1:nrow(c)){
  
  par(mfrow=c(1,2))
  d<- data$data[[c[q,1]]]  
  
    plot(NULL, xlim = c(0, 250), ylim = c(0,1), main = paste(c[q,1]))
    for(i in 1:30){
      lines((d$punish[[i]][,1]), col=col.alpha("turquoise4", .2))
      lines(d$leakage[[i]][,1], col=col.alpha("goldenrod3", .2))
      for(j in 1:2) lines((d$stock[[i]][,j]), col=col.alpha("green", .2))
      lines((d$limit [[i]][,1]), col=col.alpha("purple", .2))
      lines((d$effort [[i]][,1]), col=col.alpha("red", .2))
    }
    
    d<- data$data[[c[q,2]]]  
    
    plot(NULL, xlim = c(0, 250), ylim = c(0,1), main = paste(c[q,2]))
    for(i in 1:30){
      lines((d$punish[[i]][,1]), col=col.alpha("turquoise4", .2))
      lines(d$leakage[[i]][,1], col=col.alpha("goldenrod3", .2))
      for(j in 1:2) lines((d$stock[[i]][,j]), col=col.alpha("green", .2))
      lines((d$limit [[i]][,1]), col=col.alpha("purple", .2))
      lines((d$effort [[i]][,1]), col=col.alpha("red", .2))
    }
}

#BIFURCATION
c(3, 7, 9,11,47) 

#partial Evolution
sweeps[c(61, 59, 53, 51, 37, 49, 55, 57),]

#instituion fully evolves
sweeps[c(47, 45, 43, 41, 39, 35, 33), ]


#################################################
############ INSTITUTIONS .5 ####################
a<-which(sweeps$experiment==0.5 & sweeps$REDD == FALSE)

match <- rep(NA, length(a))
for(i in 1:length(a)){
  ma<-sweeps[a,-which(colnames(sweeps)=="REDD")]
  m <- sweeps[,-which(colnames(sweeps)=="REDD")]
  for(i in 1:nrow(ma)){
    for(j in 1:nrow(m)){
      if(a[i]!=j){
        if(all(ma[i,]==m[j,])){
          match[i] <- j
          break
        }
      }
    }
  }
}

b<-match


c<- matrix(c(a,b),ncol=2)

for(q in 1:nrow(c)){
  
  par(mfrow=c(1,2))
  d<- data$data[[c[q,1]]]  
  
  plot(NULL, xlim = c(0, 250), ylim = c(0,1), main = paste(c[q,1]))
  for(i in 1:30){
    lines((d$punish[[i]][,1]), col=col.alpha("turquoise4", .2))
    lines(d$leakage[[i]][,1], col=col.alpha("goldenrod3", .2))
    for(j in 1:2) lines((d$stock[[i]][,j]), col=col.alpha("green", .2))
    lines((d$limit [[i]][,1]), col=col.alpha("purple", .2))
    lines((d$effort [[i]][,1]), col=col.alpha("red", .2))
  }
  
  d<- data$data[[c[q,2]]]  
  
  plot(NULL, xlim = c(0, 250), ylim = c(0,1), main = paste(c[q,2]))
  for(i in 1:30){
    lines((d$punish[[i]][,1]), col=col.alpha("turquoise4", .2))
    lines(d$leakage[[i]][,1], col=col.alpha("goldenrod3", .2))
    for(j in 1:2) lines((d$stock[[i]][,j]), col=col.alpha("green", .2))
    lines((d$limit [[i]][,1]), col=col.alpha("purple", .2))
    lines((d$effort [[i]][,1]), col=col.alpha("red", .2))
  }
}

#87, or 85 71 is beautiful




#################################################
############ INSTITUTIONS .9 ####################


a<-which(sweeps$experiment==0.9 & sweeps$REDD == FALSE)

match <- rep(NA, length(a))
for(i in 1:length(a)){
  ma<-sweeps[a,-which(colnames(sweeps)=="REDD")]
  m <- sweeps[,-which(colnames(sweeps)=="REDD")]
  for(i in 1:nrow(ma)){
    for(j in 1:nrow(m)){
      if(a[i]!=j){
        if(all(ma[i,]==m[j,])){
          match[i] <- j
          break
        }
      }
    }
  }
}

b<-match


c<- matrix(c(a,b),ncol=2)

for(q in 1:nrow(c)){
  
  par(mfrow=c(1,2))
  d<- data$data[[c[q,1]]]  
  
  plot(NULL, xlim = c(0, 250), ylim = c(0,1), main = paste(c[q,1]))
  for(i in 1:30){
    lines((d$punish[[i]][,1]), col=col.alpha("turquoise4", .2))
    lines(d$leakage[[i]][,1], col=col.alpha("goldenrod3", .2))
    for(j in 1:2) lines((d$stock[[i]][,j]), col=col.alpha("green", .2))
    lines((d$limit [[i]][,1]), col=col.alpha("purple", .2))
    lines((d$effort [[i]][,1]), col=col.alpha("red", .2))
  }
  
  d<- data$data[[c[q,2]]]  
  
  plot(NULL, xlim = c(0, 250), ylim = c(0,1), main = paste(c[q,2]))
  for(i in 1:30){
    lines((d$punish[[i]][,1]), col=col.alpha("turquoise4", .2))
    lines(d$leakage[[i]][,1], col=col.alpha("goldenrod3", .2))
    for(j in 1:2) lines((d$stock[[i]][,j]), col=col.alpha("green", .2))
    lines((d$limit [[i]][,1]), col=col.alpha("purple", .2))
    lines((d$effort [[i]][,1]), col=col.alpha("red", .2))
  }
}

##############################################################################
################## FIND OUT DIFFRENCE IN EFFORT AS A FUNCTION OF LEAKAGE #####

a<-which(sweeps$REDD == FALSE)


match <- matrix(NA, nrow=nrow(sweeps), 2)

  
  ma<-sweeps[a,-which(colnames(sweeps)=="experiment")]
  m <- sweeps[a,-which(colnames(sweeps)=="experiment")]

  for(i in 1:nrow(ma)){
    cnt <- 1
    for(j in 1:nrow(m)){
      if(i!=j){
        if(all(ma[i,]==m[j,])){
          match[i,cnt] <- a[j]
          cnt <- cnt +1
          if(cnt == 3)break
        }
      }
    }
  }

c <-cbind(a, match)
c <- c[1:32,]





for(q in 1:nrow(c)){
  
  par(mfrow=c(1,3))
  for(l in 1:3){
  d<- data$data[[c[q,l]]]  
  
  plot(NULL, xlim = c(0, 250), ylim = c(0,1), main = paste(c[q,l]))
  for(i in 1:30){
    lines((d$punish[[i]][,1]), col=col.alpha("turquoise4", .2))
    lines(d$leakage[[i]][,1], col=col.alpha("goldenrod3", .2))
    for(j in 1:2) lines((d$stock[[i]][,j]), col=col.alpha("green", .2))
    lines((d$limit [[i]][,1]), col=col.alpha("purple", .2))
    lines((d$effort [[i]][,1]), col=col.alpha("red", .2))
  }
  }
}