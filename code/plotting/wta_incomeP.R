

df_income <- readRDS(paste0(path$data, "dataframes/df_income.rds"))
prefernces <- readRDS(paste0(path$data, "dataframes/prefernces.rds"))
wta <- prefernces$wta_final
wta <- log10(exp(wta)/2500)
seq_x <- -4:5
seq_y <- -4:5


in.market <- ifelse(exp(prefernces$wta_final - prefernces$wta_sds) > df_income$total_inc, 1, 2)
wta[wta < 0] <- NA
PI <- matrix(ncol = length(seq_x), nrow = 2)
PI[1, ] <- seq_x-sd(log10(exp(prefernces$wta_sds)/2500), na.rm = T)
PI[2, ] <- seq_x+sd(log10(exp(prefernces$wta_sds)/2500), na.rm = T)

collist1 <- c("red", "black")

png("/home/jeffrey_andrews/cpr/output/wta_plots.png", width = 800, heigh = 400)
par(mfrow = c(1, 2))
plot(log10(df_income$total_inc/2500), wta, xlim = c(0, 5), ylim =c(0, 5), col = collist1[in.market], 
     xlab = "Total Household Income (USD) ", ylab = "Willingness to Accept (USD)" , xaxt = "n", yaxt = "n",
     main = "Willigness to accept and household income")
axis(1, at=0:5, labels=c(0, 10^(1:5)))
axis(2, at=0:5, labels=c(0, 10^(1:5)))
rethinking::shade(PI, seq_x)
lines(seq_x, seq_y, lty = 2)




wta <- prefernces$wta_final
wta <- log10(exp(wta)/2500)
seq_x <- -4:5
seq_y <- -4:5

wta[wta < 0] <- NA
PI <- matrix(ncol = length(seq_x), nrow = 2)
PI[1, ] <- seq_x-sd(log10(exp(prefernces$wta_sds)/2500), na.rm = T)
PI[2, ] <- seq_x+sd(log10(exp(prefernces$wta_sds)/2500), na.rm = T)


willing <- ifelse(exp(prefernces$wta_final - prefernces$wta_sds) > (df_income$forestinc + df_income$secondinc), 1, 2)
wta[wta < 0] <- NA


df <- data.frame(wta = wta)
df$inmarket <- in.market
df$uncertanty <- prefernces$wta_sds
df$forestinc <- log1p(df_income$forestinc)


willing <- ifelse(exp(prefernces$wta_final - prefernces$wta_sds) > (df_income$forestinc+df_income$secondinc), 1, 2)

categ <- rep(NA, nrow(prefernces))

for (i in 1:nrow(prefernces)){
  if((in.market[i] == 1 & willing[i] == 1) %in% T)categ[i] <- 3
  if((in.market[i] == 2 & willing[i] == 1) %in% T)categ[i] <- 2
  if((in.market[i] == 2 & willing[i] == 2) %in% T)categ[i] <- 1
}


cat_reord <- rep(NA, length(categ))
cat_reord[categ ==3] <- 1
cat_reord[categ ==2] <- 2
cat_reord[categ ==1] <- 3



plot(log10((df_income$forestinc + df_income$secondinc)/2500), wta, xlim = c(0, 5), ylim = c(0, 5), yaxt = "n", xaxt = "n",
     col = rev(collist_master[[2]])[categ], 
     xlab = "Total Forest Income (USD)", ylab = "Willingness to Accept (USD)",
     main = "Willingness to accept and forest income")
axis(1, at=0:5, labels=c(0, 10^(1:5)))
axis(2, at=0:5, labels=c(0, 10^(1:5)))
rethinking::shade(PI, seq_x)
lines(seq_x, seq_y, lty = 2)

dev.off()