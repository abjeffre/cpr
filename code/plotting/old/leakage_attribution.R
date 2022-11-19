
library(tidyr)

df <- conservation[,4:9]

table1 <- matrix(nrow = nrow(df), ncol = 4)

temp <- as.matrix(df)

temp[df <= 2] <- 1
temp[df > 2 &  df < 4 ] <- 2
temp[df >= 4] <- 3



temp2 <- array(NA, c(3, 6, 2))
for(j in 0:1){
  for(i in 1:6){
    for(k in 1:3){
      temp2[k,i, j+1] <- sum(temp[demographics$controls==j,i]==k, na.rm = T)
    }
     temp2[,i,j+1]  <- temp2[,i,j+1]/colSums(temp2[,,j+1])[i]
  }
}

leakage <- temp2
colnames(leakage) <- c("Locals", "Neighbors", "Other Pembans", "Non-Pembans", "Government", "Buisness")
rownames(leakage) <- c("Minor", "Moderate", "Important")


png(file = paste0("/home/jeffrey_andrews/cpr/output/leakage_bar.png"))
par(mfrow =c(1,2), oma = c(3,1,2,7), mar = c(4,2,1,2),xpd=TRUE)
barplot(leakage[,,1], ylab = "Perceived Risk of Punishment - Proportion", col = c(col.alpha("black",.5),col.alpha("goldenrod3", .5), col.alpha("firebrick3", .5)), las =3)
barplot(leakage[,,2], ylab = "Perceived Risk of Punishment - Proportion",  col = c(col.alpha("black",.5),col.alpha("goldenrod3", .5), col.alpha("firebrick3", .5)), las=3)
legend("topright",
       inset=c(-.9,0),
       rownames(leakage),
       title = "Source of Deforestation",
       cex = .8,
       fill = c(col.alpha("black",.5),col.alpha("goldenrod3", .5), col.alpha("firebrick3", .5)), xpd = "TRUE"
)
mtext("Attribution of Deforestation", line = 1, adj = .8, outer = TRUE)
mtext("CoFMA", line = -0.6, adj = .20, outer = TRUE, cex = .85)
mtext("Control", line = -0.6, adj = .75, outer = TRUE, cex = .85)
mtext("Proportion of Residents", side =2, outer = TRUE, cex = .90, adj = .6)
dev.off()
