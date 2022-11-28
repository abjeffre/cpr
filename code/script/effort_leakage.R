##########################################################################
################# 

library(rethinking)
library(dplyr)

setwd("C:/Users/jeffr/OneDrive/Documents/")
source("C:/Users/jeffr/OneDrive/Documents/forests/data/dataframes/load_df.R")


# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(forestproducts$firewood_time)
INT = as.integer(demographics$enum_id)
S = as.integer(demographics$ward_id)
X1 = conservation$seentheft+1L
X2 = as.integer(conservation$defor_neighbors)
W = standardize(log1p(wealth$total_wealth))
INC = standardize(log1p(df_income$total_inc))
DF = standardize(as.numeric(wealth$house1_forest_time))
TO = standardize(log1p(rowSums(select(trees, ends_with("wealth")))))
C = as.integer(demographics$controls+1L)
BL = standardize(conservation$defor_locals)
HM = standardize(demographics$hh_adult_eq)
df <- data.frame(Y = Y,
                 Y0 = forestproducts$firewood_time,
                 S,
                 C,
                 X1,
                 X2,
                 INT,
                 W,
                 INC,
                 DF,
                 TO,
                 BL,
                 HM)
df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:13]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
m1=stan("C:/Users/jeffr/Documents/Work/cpr/code/models/effort_leakage_cat.stan", data = d, cores=4)
precis(m1, 3)
post <- extract.samples(m1)



sim<- function(x1, x2){
  mu<-with(post,
    rnorm(4000, a[1,] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2, sigma)
  )
  #p<-with(post,
  #         rbern(4000, inv_logit(a[2,] + bX[,2, x1,x2] + rowMeans(bS[2,, ])*sigma_S[,2] + rowMeans(bINT[2,,])*sigma_INT[2,]))
  #)
  mu
}

link<- function(x1, x2){
  mu<-with(post, a[1,] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 + rowMeans(bINT[,2,])*sigma_INT[,2])
  #p<-with(post, inv_logit(a[2,] + bX[,2, x1,x2] + rowMeans(bS[2,, ])*sigma_S[,2] + rowMeans(bINT[2,,])*sigma_INT[2,]))
  #p*mu
}
dens(link(2,1)-link(1,2), show.HPDI = .89)


############################################
############### EFFORT FIREWOOD ############



# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(forestproducts$firewood_time)
INT = as.integer(demographics$enum_id)
S = as.integer(demographics$ward_id)
X1 = conservation$seentheft+1L
X2 = as.integer(conservation$defor_neighbors)
W = standardize(log1p(wealth$total_wealth))
INC = standardize(log1p(df_income$total_inc))
DF = standardize(as.numeric(wealth$house1_forest_time))
TO = standardize(log1p(rowSums(select(trees, ends_with("wealth")))))
C = as.integer(demographics$controls+1L)
BL = standardize(conservation$defor_locals)
HM = standardize(demographics$hh_adult_eq)
df <- data.frame(Y = Y,
                 Y0 =Y,
                 S,
                 C,
                 X1,
                 X2,
                 INT,
                 HM,
                 W,
                 TO,
                 DF,
                 BL)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
mfirewood_effort=stan("C:/Users/jeffr/Documents/Work/cpr/code/models/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(m1, 3)
post <- extract.samples(m1)



sim<- function(x1, x2){
  mu<-with(post,
           rnorm(4000, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 + bX1X2[,1,x1]*sigma_X1X2[,1]*x2, sigma)
  )
  #p<-with(post,
  #         rbern(4000, inv_logit(a[2,] + bX[,2, x1,x2] + rowMeans(bS[2,, ])*sigma_S[,2] + rowMeans(bINT[2,,])*sigma_INT[2,]))
  #)
  mu
}


link<- function(x1, x2){
  mu<-with(post, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 +  + bX1X2[,1,x1]*sigma_X1X2[,1]*x2)
  #p<-with(post, a[,2] + bX[,2, x1]*sigma_X1[,2] + bX2[,2]*x2 +  + bX1X2[,2,x1]*sigma_X1X2[,2]*x2)
  mu
}
dens(link(1,0)-link(2,1), show.HPDI = .89)





############################################
############### EFFORT Timber ############



# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(rowSums(data.frame(forestproducts$lumber_time, forestproducts$charcoal_time, forestproducts$building_mat_time), na.rm =T))
INT = as.integer(demographics$enum_id)
S = as.integer(demographics$ward_id)
X1 = conservation$seentheft+1L
X2 = as.integer(conservation$defor_neighbors)
W = standardize(log1p(wealth$total_wealth))
INC = standardize(log1p(df_income$total_inc))
DF = standardize(as.numeric(wealth$house1_forest_time))
TO = standardize(log1p(rowSums(select(trees, ends_with("wealth")))))
C = as.integer(demographics$controls+1L)
BL = standardize(conservation$defor_locals)
HM = standardize(demographics$hh_adult_eq)
df <- data.frame(Y = Y,
                 Y0 =Y,
                 S,
                 C,
                 X1,
                 X2,
                 INT,
                 HM,
                 W,
                 TO,
                 DF,
                 BL)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
mtimber_effort=stan("C:/Users/jeffr/Documents/Work/cpr/code/models/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(mtimber_effort, 3)
post <- extract.samples(mtimber_effort)



sim<- function(x1, x2){
  mu<-with(post,
           rnorm(4000, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 + bX1X2[,1,x1]*sigma_X1X2[,1]*x2, sigma)
  )
  #p<-with(post,
  #         rbern(4000, inv_logit(a[2,] + bX[,2, x1,x2] + rowMeans(bS[2,, ])*sigma_S[,2] + rowMeans(bINT[2,,])*sigma_INT[2,]))
  #)
  mu
}


link<- function(x1, x2){
  #mu<-with(post, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 +  + bX1X2[,1,x1]*sigma_X1X2[,1]*x2)
  p<-with(post, a[,2] + bX[,2, x1]*sigma_X1[,2] + bX2[,2]*x2 +  + bX1X2[,2,x1]*sigma_X1X2[,2]*x2)
  p
}
dens(link(2,1)-link(1,0), show.HPDI = .89)


################################################################################
############################ TIMBER HARVEST ####################################


# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(forestproducts$timber)
E = log1p(rowSums(data.frame(forestproducts$lumber_time, forestproducts$charcoal_time, forestproducts$building_mat_time), na.rm =T))
INT = as.integer(demographics$enum_id)
S = as.integer(demographics$ward_id)
X1 = conservation$seentheft+1L
X2 = as.integer(conservation$defor_neighbors)
W = standardize(log1p(wealth$total_wealth))
INC = standardize(log1p(df_income$total_inc))
DF = standardize(as.numeric(wealth$house1_forest_time))
TO = standardize(log1p(rowSums(select(trees, ends_with("wealth")))))
C = as.integer(demographics$controls+1L)
BL = standardize(conservation$defor_locals)
HM = standardize(demographics$hh_adult_eq)
df <- data.frame(Y = Y,
                 Y0 =Y,
                 S,
                 C,
                 X1,
                 X2,
                 INT,
                 HM,
                 W,
                 E,
                 TO,
                 DF,
                 BL)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
mtimber_harvest=stan("C:/Users/jeffr/Documents/Work/cpr/code/models/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(mtimber_harvest, 3)
post <- extract.samples(mtimber_harvest)



sim<- function(x1, x2){
  mu<-with(post,
           rnorm(4000, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 + bX1X2[,1,x1]*sigma_X1X2[,1]*x2, sigma)
  )
  #p<-with(post,
  #         rbern(4000, inv_logit(a[2,] + bX[,2, x1,x2] + rowMeans(bS[2,, ])*sigma_S[,2] + rowMeans(bINT[2,,])*sigma_INT[2,]))
  #)
  mu
}


link<- function(x1, x2){
  mu<-with(post, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 +  + bX1X2[,1,x1]*sigma_X1X2[,1]*x2)
  #p<-with(post, a[,2] + bX[,2, x1]*sigma_X1[,2] + bX2[,2]*x2 +  + bX1X2[,2,x1]*sigma_X1X2[,2]*x2)
  
}
dens(link(2,1)-link(1,0), show.HPDI = .89)













################################################################################
########################## NTFP EFFORT #######################################



# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(rowSums(data.frame(forestproducts$pegs_time, forestproducts$string_time, forestproducts$honey_time,
          forestproducts$fish_time, forestproducts$ukindu_time, forestproducts$fruit_time,
          forestproducts$seeds_time, forestproducts$medicine_time, forestproducts$mchikichi_time, forestproducts$utembo_time), na.rm = T))
INT = as.integer(demographics$enum_id)
S = as.integer(demographics$ward_id)
X1 = conservation$seentheft+1L
X2 = as.integer(conservation$defor_neighbors)
W = standardize(log1p(wealth$total_wealth))
INC = standardize(log1p(df_income$total_inc))
DF = standardize(as.numeric(wealth$house1_forest_time))
TO = standardize(log1p(rowSums(select(trees, ends_with("wealth")))))
C = as.integer(demographics$controls+1L)
BL = standardize(conservation$defor_locals)
HM = standardize(demographics$hh_adult_eq)
df <- data.frame(Y = Y,
                 Y0 =Y,
                 S,
                 C,
                 X1,
                 X2,
                 INT,
                 HM,
                 W,
                 TO,
                 DF,
                 BL)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
ntfp_effort=stan("C:/Users/jeffr/Documents/Work/cpr/code/models/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(mtimber_effort, 3)
post <- extract.samples(mtimber_effort)



sim<- function(x1, x2){
  mu<-with(post,
           rnorm(4000, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 + bX1X2[,1,x1]*sigma_X1X2[,1]*x2, sigma)
  )
  #p<-with(post,
  #         rbern(4000, inv_logit(a[2,] + bX[,2, x1,x2] + rowMeans(bS[2,, ])*sigma_S[,2] + rowMeans(bINT[2,,])*sigma_INT[2,]))
  #)
  mu
}


link<- function(x1, x2){
  mu<-with(post, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 +  + bX1X2[,1,x1]*sigma_X1X2[,1]*x2)
  p<-with(post, a[,2] + bX[,2, x1]*sigma_X1[,2] + bX2[,2]*x2 +  + bX1X2[,2,x1]*sigma_X1X2[,2]*x2)
  mu
}
dens(link(2,1)-link(1,0), show.HPDI = .89)




################################################################################
########################## NTFP Harvest #######################################



# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(forestproducts$ntfp_prod)
E = log1p(rowSums(data.frame(forestproducts$pegs_time, forestproducts$string_time, forestproducts$honey_time,
                             forestproducts$fish_time, forestproducts$ukindu_time, forestproducts$fruit_time,
                             forestproducts$seeds_time, forestproducts$medicine_time, forestproducts$mchikichi_time, forestproducts$utembo_time), na.rm = T))
INT = as.integer(demographics$enum_id)
S = as.integer(demographics$ward_id)
X1 = conservation$seentheft+1L
X2 = as.integer(conservation$defor_neighbors)
W = standardize(log1p(wealth$total_wealth))
INC = standardize(log1p(df_income$total_inc))
DF = standardize(as.numeric(wealth$house1_forest_time))
TO = standardize(log1p(rowSums(select(trees, ends_with("wealth")))))
C = as.integer(demographics$controls+1L)
BL = standardize(conservation$defor_locals)
HM = standardize(demographics$hh_adult_eq)
df <- data.frame(Y = Y,
                 Y0 =Y,
                 S,
                 C,
                 X1,
                 X2,
                 INT,
                 HM,
                 W,
                 E,
                 TO,
                 DF,
                 BL)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
ntfp_harvest=stan("C:/Users/jeffr/Documents/Work/cpr/code/models/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(ntfp_harvest, 3)
post <- extract.samples(ntfp_harvest)



sim<- function(x1, x2){
  mu<-with(post,
           rnorm(4000, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 + bX1X2[,1,x1]*sigma_X1X2[,1]*x2, sigma)
  )
  #p<-with(post,
  #         rbern(4000, inv_logit(a[2,] + bX[,2, x1,x2] + rowMeans(bS[2,, ])*sigma_S[,2] + rowMeans(bINT[2,,])*sigma_INT[2,]))
  #)
  mu
}


link<- function(x1, x2){
  mu<-with(post, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 +  + bX1X2[,1,x1]*sigma_X1X2[,1]*x2)
  p<-with(post, a[,2] + bX[,2, x1]*sigma_X1[,2] + bX2[,2]*x2 +  + bX1X2[,2,x1]*sigma_X1X2[,2]*x2)
  p
}
dens(link(2,1)-link(1,0), show.HPDI = .89)





################################################################################
######################## Aggregate EFFORT ########################################


Y = log1p(rowSums(select(forestproducts, ends_with("time")), na.rm = T))
INT = as.integer(demographics$enum_id)
S = as.integer(demographics$ward_id)
X1 = conservation$seentheft+1L
X2 = as.integer(conservation$defor_neighbors)
W = standardize(log1p(wealth$total_wealth))
INC = standardize(log1p(df_income$total_inc))
DF = standardize(as.numeric(wealth$house1_forest_time))
TO = standardize(log1p(rowSums(select(trees, ends_with("wealth")))))
C = as.integer(demographics$controls+1L)
BL = standardize(conservation$defor_locals)
HM = standardize(demographics$hh_adult_eq)
df <- data.frame(Y = Y,
                 Y0 =Y,
                 S,
                 C,
                 X1,
                 X2,
                 INT,
                 HM,
                 W,
                 TO,
                 DF,
                 BL)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
meffort=stan("C:/Users/jeffr/Documents/Work/cpr/code/models/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(meffort, 3)
post <- extract.samples(meffort)



sim<- function(x1, x2){
  mu<-with(post,
           rnorm(4000, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 + bX1X2[,1,x1]*sigma_X1X2[,1]*x2, sigma)
  )
  #p<-with(post,
  #         rbern(4000, inv_logit(a[2,] + bX[,2, x1,x2] + rowMeans(bS[2,, ])*sigma_S[,2] + rowMeans(bINT[2,,])*sigma_INT[2,]))
  #)
  mu
}


link<- function(x1, x2){
  mu<-with(post, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 +  + bX1X2[,1,x1]*sigma_X1X2[,1]*x2)
  #p<-with(post, a[,2] + bX[,2, x1]*sigma_X1[,2] + bX2[,2]*x2 +  + bX1X2[,2,x1]*sigma_X1X2[,2]*x2)
  mu
}
dens(link(2,1)-link(1,0), show.HPDI = .89)




##########################################
############### FOREST INCOME ############



# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(df_income$forestinc)
E = standardize(log1p(rowSums(select(forestproducts, ends_with("time")), na.rm = T)))
INT = as.integer(demographics$enum_id)
S = as.integer(demographics$ward_id)
X1 = conservation$seentheft+1L
X2 = as.integer(conservation$defor_neighbors)
W = standardize(log1p(wealth$total_wealth))
INC = standardize(log1p(df_income$total_inc))
DF = standardize(as.numeric(wealth$house1_forest_time))
TO = standardize(log1p(rowSums(select(trees, ends_with("wealth")))))
C = as.integer(demographics$controls+1L)
BL = standardize(conservation$defor_locals)
HM = standardize(demographics$hh_adult_eq)
df <- data.frame(Y = Y,
                 Y0 =Y,
                 S,
                 C,
                 X1,
                 X2,
                 INT,
                 E,
                 HM,
                 W,
                 TO,
                 DF)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
forest_income=stan("C:/Users/jeffr/Documents/Work/cpr/code/models/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(forest_income, 3)
post <- extract.samples(forest_income)



sim<- function(x1, x2){
  mu<-with(post,
           rnorm(4000, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 + bX1X2[,1,x1]*sigma_X1X2[,1]*x2, sigma)
  )
  #p<-with(post,
  #         rbern(4000, inv_logit(a[2,] + bX[,2, x1,x2] + rowMeans(bS[2,, ])*sigma_S[,2] + rowMeans(bINT[2,,])*sigma_INT[2,]))
  #)
  mu
}


link<- function(x1, x2){
  mu<-with(post, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 +  + bX1X2[,1,x1]*sigma_X1X2[,1]*x2)
  #p<-with(post, a[,2] + bX[,2, x1]*sigma_X1[,2] + bX2[,2]*x2 +  + bX1X2[,2,x1]*sigma_X1X2[,2]*x2)
  mu
}
dens(link(2,1)-link(1,0), show.HPDI = .89)






##########################################
############### Total Income ############



# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(df_income$total_inc-df_income$forestinc)
E = standardize(log1p(rowSums(select(forestproducts, ends_with("time")), na.rm = T)))
INT = as.integer(demographics$enum_id)
S = as.integer(demographics$ward_id)
X1 = conservation$seentheft+1L
X2 = as.integer(conservation$defor_neighbors)
W = standardize(log1p(wealth$total_wealth))
INC = standardize(log1p(df_income$total_inc))
DF = standardize(as.numeric(wealth$house1_forest_time))
TO = standardize(log1p(rowSums(select(trees, ends_with("wealth")))))
C = as.integer(demographics$controls+1L)
BL = standardize(conservation$defor_locals)
HM = standardize(demographics$hh_adult_eq)
df <- data.frame(Y = Y,
                 S,
                 C,
                 X1,
                 X2,
                 INT,
                 E,
                 HM,
                 W,
                 TO,
                 DF)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
total_income=stan("C:/Users/jeffr/Documents/Work/cpr/code/models/total_income_leakage.stan", data = d, cores=4)
precis(total_income, 3)
post <- extract.samples(total_income)



sim<- function(x1, x2){
  mu<-with(post,
           rnorm(4000, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 + bX1X2[,1,x1]*sigma_X1X2[,1]*x2, sigma)
  )
  #p<-with(post,
  #         rbern(4000, inv_logit(a[2,] + bX[,2, x1,x2] + rowMeans(bS[2,, ])*sigma_S[,2] + rowMeans(bINT[2,,])*sigma_INT[2,]))
  #)
  mu
}


link<- function(x1, x2){
  mu<-with(post, a + bX[, x1]*sigma_X1 + bX2*x2 +  + bX1X2[,x1]*sigma_X1X2*x2)
  #p<-with(post, a[,2] + bX[,2, x1]*sigma_X1[,2] + bX2[,2]*x2 +  + bX1X2[,2,x1]*sigma_X1X2[,2]*x2)
  mu
}
dens(link(2,1)- link(1,0), show.HPDI = .89)




























a=standardize(conservation$defor_neighbors)*standardize(conservation$seentheft)

b = ifelse(conservation$defor_neighbors > 2 & conservation$seentheft == 1, 1, 0)
new=select(forestproducts, ends_with("time"))

non_forest_income = df_income$total_inc- df_income$forestinc  
summary(lm(log1p( ) ~ b))


summary(lm(log1p(df_income$forestinc) ~ exposure + log1p(df_income$total_inc) +  log1p(wealth$total_wealth)))
summary(lm(log1p(non_forest_income) ~ exposure  +  log1p(wealth$total_wealth)))
summary(lm(log1p(effort) ~ b + log1p(df_income$forestinc) + log1p(wealth$total_wealth)))
summary(lm(prefernces$wta_final ~ b + log1p(df_income$forestinc) + log1p(wealth$total_wealth)))
summary(lm(conservation$reddrank ~ b + log1p(df_income$forestinc) + log1p(wealth$total_wealth)))
summary(lm(conservation$jumijazaanimfu ~ b + log1p(df_income$forestinc) + log1p(wealth$total_wealth)))


summary(lm(log1p(df_income$forestinc) ~ conservation$defor_neighbors + conservation$seentheft + conservation$defor_neighbors*conservation$seentheft + log1p(effort)))
