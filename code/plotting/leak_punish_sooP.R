##############################
### CHECK PUNISH #############

dat <- leak$data

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

# Define variable that contains the Max Punishment
settings <- leak$par[a,]


par(mfrow =c(1,1))
options(bitmapType='cairo')
png(paste0(path$output, "leak_punish_soo.png"), width = 600, height = 400)

i=3

plot(rowMeans(dat[[a]]$punish[[i]]), type = "l", col=col.alpha("turquoise4", 1),
       ylim = c(0,1), ylab = "Proportion of pop", xlab = "Generation",
       main = "Relationship between leakage and insitutional enforcement", cex = .8)
       lines(rowMeans(dat[[a]]$leakage[[i]]), col=col.alpha("goldenrod3", 1))
       
legend("topleft", c("Enforcers", "Leakers"),
       fill = sapply(c("goldenrod3", "turquoise4"), col.alpha, .8), cex = 1)

dev.off()

##########################################################################################
############ To find multiple subsets based on multiple simultatnous conditions ################

items <- rownames(subset(noleak$par, n == settings$n &
         regrow == settings$regrow &
         monitor_tech==settings$monitor_tech &
         labor == settings$labor &
         tech == settings$tech &
         defensibility == settings$defensibility &
         outgroup == settings$outgroup &
         wages == settings$wages &
         var_forest == settings$var_forest &
         max_forest == settings$max_forest))

items <- as.numeric(items)



#####  Now plot the dynamics 


for(j in 1:length(items)){
  for(i in 1:10){
plot(rowMeans(noleak$dat[[items[j]]]$punish[[i]]), type = "l", col=col.alpha("turquoise4", 1),
     ylim = c(0,1), ylab = "Proportion of pop", xlab = "Generation",
     main = "Relationship between leakage and insitutional enforcement", cex = .8)
lines(rowMeans(noleak$dat[[items[j]]]$limit[[i]]), col=col.alpha("goldenrod3", 1))
lines(rowMeans(noleak$dat[[items[j]]]$stock[[i]]), col=col.alpha("darkgreen", 1))
lines(noleak$dat[[items[j]]]$effort[[i]], col=col.alpha("purple", 1))
  }
}




