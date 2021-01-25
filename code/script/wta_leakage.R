df_income <- readRDS(paste0(path$data, "dataframes/df_income.rds"))
prefernces <- readRDS(paste0(path$data, "dataframes/prefernces.rds"))
wta <- prefernces$wta_final
wta <- log10(exp(wta)/2500)
seq_x <- -4:5
seq_y <- -4:5

in.market <- ifelse(exp(prefernces$wta_final - prefernces$wta_sds) > df_income$total_inc, 1, 2)
wta[wta < 0] <- NA


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






df <- data.frame(Y = conservation$tree_stolen,
                 X = demographics$controls,
                 W = prefernces$wta_final, 
                 C = cat_reord,
                 E = demographics$enum_id,
                 U = prefernces$wta_sds + 0.0001
                 )


df<- df[complete.cases(df),]

df$S <- as.integer(as.factor(interaction(df$X, df$Y)))


#  S = rep(NA, ncol(df))
# S<- ifelse(df&X ==0 & df$Y ==0, ,1,S) # CoFMA and not Victim
# S<- ifelse(df&X ==0 & df$Y ==1, ,2,S) # CoFMA and Victim
# S<- ifelse(df&X ==1 & df$Y ==0, ,1,S) # Control and not Victim
# S<- ifelse(df&X ==0 & df$Y ==0, ,1,S) # Control and Victim

data <- list(
  W = df$W,
  C = df$C,
  X = df$S,
  U = df$U,
  E = as.integer(df$E),
  N = as.integer(nrow(df))
  )



model_normal <- stan( file = "/home/jeffrey_andrews/cpr/code/models/wta_leakageM.stan",
               data=data, iter = 2000,
               cores = 4, chains = 4, control = list(adapt_delta =0.99, max_treedepth = 10))



model_ordlog <- stan( file = "/home/jeffrey_andrews/cpr/code/models/ordlog_leakageM.stan",
                      data=data, iter = 2000,
                      cores = 4, chains = 4, control = list(adapt_delta =0.99, max_treedepth = 10))
