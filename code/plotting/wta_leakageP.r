source("/home/jeffrey_andrews/cpr/code/script/wta_leakage.R")

############################################## 
########### Plotting leakage WTA #############


post <- extract.samples(model_ordlog)
dev.off()
par(mfrow=c(1,2))
cumSum_plot("post$bX[,x.seq]*post$Sigma_X", x =data$X[data$X== 1 | data$X== 3], seq = c(1,3), xaxt = "n", title = "CoFMA")
cumSum_plot("post$bX[,x.seq]*post$Sigma_X", x=data$X[data$X==2 | data$X==4], seq = c(2,4), xaxt = "n", title = "Control")



post <- extract.samples(model_normal)

out <- list()
for(i in 1:2){
  
  if(i == 1) x.seq = c(1,3)
  if(i == 2) x.seq = c(2,4)


means <- list()
for(j in 1:3){
  
  link  <-  function(x.seq) post$a[,1] + post$bX[,1,x.seq,j] 
  link2 <- function(x.seq)  post$a[,2] + post$bX[,2,x.seq,j] 

   mu <- sapply(x.seq, link)
   pi <- sapply(x.seq, link2)
  
   means[[j]] <- mu*(1-inv_logit(pi))  

}
out[[i]] <- means
}


#Willing 
dens(exp(out[[1]][[3]][,2])/2500 - exp(out[[1]][[3]][,1])/2500, show.HPDI = .95)
dens(exp(out[[2]][[3]][,2])/2500 - exp(out[[2]][[3]][,1])/2500, show.HPDI = .95)

#reluctant
dens(exp(out[[1]][[2]][,2])/2500 - exp(out[[1]][[2]][,1])/2500, show.HPDI = .95)
dens(exp(out[[2]][[2]][,2])/2500 - exp(out[[2]][[2]][,1])/2500, show.HPDI = .95)

#outofmarket
dens(exp(out[[1]][[1]][,2])/2500 - exp(out[[1]][[1]][,1])/2500, show.HPDI = .95)
dens(exp(out[[2]][[1]][,2])/2500 - exp(out[[2]][[1]][,1])/2500, show.HPDI = .95)
