##########################################################################
################# 

library(rethinking)
library(dplyr)
library("gridBase")
library(matrixStats)
setwd("C:/Users/jeffrey_andrews/OneDrive/Documents")
source("WTA/paths.R")
source(path$load)

###SOURCING####
source("functions/plotting.R")
source("functions/data_manipulation.R")
source("functions/utility.R")
source("functions/graphics.R")
source("functions/measurement.R")
forest<- read.csv("WTA/data/AmyDataSummary.csv")

## CONSTRUCT FOREST SIZES ####################

# DEFORESTATION RATES


db <- as.data.frame(matrix(NA, nrow = 0, ncol = 3))

for(i in unique(forest$Shehia)){
  tot = mean((forest$Forest + forest$NonForest)[forest$Shehia==i])
  forest2017=(forest$Forest[forest$Shehia==i & forest$Year==2017])
  db=rbind(db, c(i, tot, forest2017))
  
}

forest_total <- rep(0, 829)
land_total <- rep(0, 829)
for(i in 1:nrow(demographics)){
  ind=which(tolower(db[,1])== demographics$ward[i])
  
  land_total[i] = ifelse(length(ind) >0, db[ind,2], NA)
  forest_total[i] = ifelse(length(ind) >0, db[ind,3], NA)
}

forest_total = as.numeric(forest_total)
land_total = as.numeric(land_total)



#population data

pop<- read.csv("C:/Users/jeffrey_andrews/OneDrive/Documents/forests/data/raw/wards_households2.csv")
wpop <- rep(NA, nrow(demographics))
for(i in 1:nrow(demographics)){
  ind<-which(pop$shehia == demographics$ward[i])
  if(length(ind) > 0) wpop[i] <- pop$households[ind]
}


source("C:/Users/jeffrey_andrews/OneDrive/Documents/forests/data/dataframes/load_df.R")


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
BL = standardize(conservation$defor_prob_shehia)
HM = standardize(demographics$hh_adult_eq)
FT = standardize(log1p(forest_total))
LT = standardize(log1p(land_total))
Panga = standardize(log1p(wealth$panga))
Axes = standardize(log1p(wealth$axe))
P = standardize(log1p(wpop))
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
                 HM,
                 FT,
                 LT,
                 Axes, 
                 Panga,
                 P)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
d$alpha <- rep(2, 4)
#Run model
file.copy("Y:/eco_andrews/Projects/cpr/code/models/effort_leakage_cat_interaction.stan",
          "C:/Users/jeffrey_andrews/OneDrive/Documents/CPR/")

mfirewood_effort=stan("C:/Users/jeffrey_andrews/OneDrive/Documents/CPR/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(mfirewood_effort, 3)
post <- extract.samples(mfirewood_effort)



sim<- function(x1, x2){
  mu<-with(post,
    rnorm(4000,           a[1,] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 + bX1X2[,1,x1]*sigma_X1X2[,1]*x2, sigma)
  )
  p<-with(post,
    rbern(4000, inv_logit(a[2,] + bX[,2, x1]*sigma_X1[,2] + bX2[,2]*x2 + bX1X2[,2,x1]*sigma_X1X2[,2]*x2))
  )
  return(list(mu = mu, p=p))
}

link<- function(x1, x2){
  mu<-with(post,          a[1,] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 + bX1X2[,1,x1]*sigma_X1X2[,1]*x2)
  p<-with(post, inv_logit(a[2,] + bX[,2, x1]*sigma_X1[,2] + bX2[,2]*x2 + bX1X2[,2,x1]*sigma_X1X2[,2]*x2))
  return(list(mu = mu, p=p))
}

dens(link(2,1)$mu-link(1,0)$mu, show.HPDI = .89)
dens(link(2,1)$p-link(1,0)$p, show.HPDI = .89)


#############################################
############### Firewood Harvest ############

# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(forestproducts$firewood_prod)
E = log1p(forestproducts$firewood_time)
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
                 BL,
                 FT,
                 TO,
                 DF,
                 LT,
                 Axes, 
                 Panga,
                 P)
          

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
#Run model
file.copy("Y:/eco_andrews/Projects/cpr/code/models/effort_leakage_cat_interaction.stan",
          "C:/Users/jeffrey_andrews/OneDrive/Documents/CPR/")

firewood_harvest=stan("C:/Users/jeffrey_andrews/OneDrive/Documents/CPR/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(firewood_harvest, 3)
post <- extract.samples(firewood_harvest)


dens(link(2,1)$mu-link(1,0)$mu, show.HPDI = .89)
dens(link(2,1)$p-link(1,0)$p, show.HPDI = .89)


############################################
############### EFFORT Timber ############



# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(rowSums(data.frame(forestproducts$lumber_time, forestproducts$charcoal_time, forestproducts$building_mat_time), na.rm =T))

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
                 BL,
                 FT,
                 LT, 
                 Panga,
                 Axes,
                 P)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
file.copy("Y:/eco_andrews/Projects/cpr/code/models/effort_leakage_cat_interaction.stan",
          "C:/Users/jeffrey_andrews/OneDrive/Documents/CPR/")

timber_effort=stan("C:/Users/jeffrey_andrews/OneDrive/Documents/CPR/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(timber_effort, 3)
post <- extract.samples(timber_effort)


dens(link(2,1)$mu-link(1,0)$mu, show.HPDI = .89)
dens(link(2,1)$p-link(1,0)$p, show.HPDI = .89)

################################################################################
############################ TIMBER HARVEST ####################################


# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(rowSums(data.frame(forestproducts$lumber_prod, forestproducts$charcoal_prod, forestproducts$building_mat_prod), na.rm =T))
E = log1p(rowSums(data.frame(forestproducts$lumber_time, forestproducts$charcoal_time, forestproducts$building_mat_time), na.rm =T))

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
                 BL,
                 FT,
                 LT,
                 Axes,
                 Panga,
                 P)

df <- df[complete.cases(df), ]

d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
mtimber_harvest=stan("C:/Users/jeffrey_andrews/OneDrive/Documents/CPR/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(mtimber_harvest, 3)
post <- extract.samples(mtimber_harvest)


dens(link(2,1)$mu-link(1,0)$mu, show.HPDI = .89)
dens(link(2,1)$p-link(1,0)$p, show.HPDI = .89)


################################################################################
########################## NTFP EFFORT #######################################



# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(rowSums(data.frame(forestproducts$pegs_time, forestproducts$string_time, forestproducts$honey_time,
          forestproducts$fish_time, forestproducts$ukindu_time, forestproducts$fruit_time,
          forestproducts$seeds_time, forestproducts$medicine_time, forestproducts$mchikichi_time, forestproducts$utembo_time), na.rm = T))
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
                 BL,
                 FT,
                 LT,
                 Axes, 
                 Panga,
                 P)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
ntfp_effort=stan("C:/Users/jeffrey_andrews/OneDrive/Documents/CPR/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(ntfp_effort, 3)
post <- extract.samples(ntfp_effort)


dens(link(2,1)$mu-link(1,0)$mu, show.HPDI = .89)
dens(link(2,1)$p-link(1,0)$p, show.HPDI = .89)



################################################################################
########################## NTFP Harvest #######################################



# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(forestproducts$ntfp_prod)
E = log1p(rowSums(data.frame(forestproducts$pegs_time, forestproducts$string_time, forestproducts$honey_time,
                             forestproducts$fish_time, forestproducts$ukindu_time, forestproducts$fruit_time,
                             forestproducts$seeds_time, forestproducts$medicine_time, forestproducts$mchikichi_time, forestproducts$utembo_time), na.rm = T))
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
                 FT,
                 BL,
                 LT,
                 TO,
                 DF,
                 Axes, 
                 Panga,
                 P)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
ntfp_harvest=stan("C:/Users/jeffrey_andrews/OneDrive/Documents/CPR/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(ntfp_harvest, 3)
post <- extract.samples(ntfp_harvest)

dens(link(2,1)$mu-link(1,0)$mu, show.HPDI = .89)
dens(link(2,1)$p-link(1,0)$p, show.HPDI = .89)



################################################################################
######################## Aggregate EFFORT ######################################


Y = log1p(rowSums(select(forestproducts, ends_with("time")), na.rm = T))

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
                 BL,
                 FT,
                 LT,
                 Axes, 
                 Panga,
                 P)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
meffort=stan("C:/Users/jeffrey_andrews/OneDrive/Documents/CPR/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(meffort, 3)
post <- extract.samples(meffort)

dens(link(2,1)$mu-link(1,0)$mu, show.HPDI = .89)
dens(link(2,1)$p-link(1,0)$p, show.HPDI = .89)


##################################################
############### FOREST HARVEST ###################



# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(df_income$forestinc)
E = standardize(log1p(rowSums(select(forestproducts, ends_with("time")), na.rm = T)))
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
                 DF,
                 FT,
                 BL,
                 LT,
                 Axes, 
                 Panga,
                 P))

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
forest_income=stan("C:/Users/jeffrey_andrews/OneDrive/Documents/CPR/effort_leakage_cat_interaction.stan", data = d, cores=4)
precis(forest_income, 3)
post <- extract.samples(forest_income)

dens(link(2,1)$mu-link(1,0)$mu, show.HPDI = .89)
dens(link(2,1)$p-link(1,0)$p, show.HPDI = .89)

##########################################
############### Total Income ############

# The effect of leakage on forest income
new=select(forestproducts, ends_with("time"))
Y = log1p(df_income$total_inc-df_income$forestinc)
E = standardize(log1p(rowSums(select(forestproducts, ends_with("time")), na.rm = T)))
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
                 DF,
                 FT,
                 LT,
                 P)

df <- df[complete.cases(df), ]


d<-as.list(df[1:7])
d$N <- nrow(df)
d$Z <- df[, 8:ncol(df)]
d$K <- ncol(d$Z)
d$alpha <- rep(2, 4)
d$mu_1 <- mean(d$Y[d$Y >0])
#Run model
file.copy("Y:/eco_andrews/Projects/cpr/code/models/total_income_leakage.stan",
          "C:/Users/jeffrey_andrews/OneDrive/Documents/CPR/")


total_income=stan("C:/Users/jeffrey_andrews/OneDrive/Documents/CPR/total_income_leakage.stan", data = d, cores=4)
precis(total_income, 3)
post <- extract.samples(total_income)



sim_ti<- function(x1, x2){
  mu<-with(post,
           rnorm(4000, a[,1] + bX[,1, x1]*sigma_X1[,1] + bX2[,1]*x2 + bX1X2[,1,x1]*sigma_X1X2[,1]*x2, sigma)
  )
  #p<-with(post,
  #         rbern(4000, inv_logit(a[2,] + bX[,2, x1,x2] + rowMeans(bS[2,, ])*sigma_S[,2] + rowMeans(bINT[2,,])*sigma_INT[2,]))
  #)
  mu
}


link_ti<- function(x1, x2){
  mu<-with(post, a + bX[, x1]*sigma_X1 + bX2*x2 +  + bX1X2[,x1]*sigma_X1X2*x2)
  mu
}
dens(link_ti(2,1)- link_ti(1,0), show.HPDI = .89)






####################################################
############ PLOTTING ##############################

d<- list( forest_effort = meffort,
      forest_income = forest_income,
      other_income = total_income,
      firewood_effort = mfirewood_effort,
      firewood_harvest = firewood_harvest,
      timber_effort = timber_effort,
      timber_harvest = mtimber_harvest,
      NTFP_effort = ntfp_effort,
      NTFP_harvest = ntfp_harvest
       )


df= as.data.frame(matrix(NA, ncol = 3, nrow = 0))

for(i in 1:length(d)){
  post<-extract.samples(d[[i]])
  if(i == 3){ 
    out=HPDI(link_ti(2,1)- link_ti(1,0))
    df=rbind(df, c(NA, out))
    
  }else{
    out=HPDI(link(2,1)$mu- link(1,0)$mu)
    df=rbind(df, c(NA,out))
    out=HPDI(link(2,1)$p- link(1,0)$p)
    df=rbind(df, c(NA,out))
  }
}


d2<-df[c(1,2,3,5,6,7,8,10,11,12,14,15,16),]

d2[,1]<-c("Forest Effort", "P(Forests)", "Forests Income",
  "Non-Forest Income",
  "Firewood effort", "P(Firewood)", "Firewood Income",
  "Timber effort", "P(Timber)", "Timber Income",
  "NTFP effort", "P(NTFP)", "NFTP Income")

names(d2) <- c("name", "v1", "v2")
d2$name = factor(d2$name, levels = rev(c("Forest Effort", "P(Forests)", "Forests Income",
                                       "Non-Forest Income",
                                       "Firewood effort", "P(Firewood)", "Firewood Income",
                                       "Timber effort", "P(Timber)", "Timber Income",
                                       "NTFP effort", "P(NTFP)", "NFTP Income")))

# Plot
ggplot(d2) +
  geom_segment( aes(x=name, xend=name, y=v1, yend=v2), color="red") +
  geom_point( aes(x=name, y=v1), color=rgb(0.2,0.7,0.1,0.5), size=3 ) +
  geom_point( aes(x=name, y=v2), color=rgb(0.7,0.2,0.1,0.5), size=3 ) +
  coord_flip()+
  geom_vline(aes(xintercept = 0))
  theme_ipsum() +
  theme(
    legend.position = "none",
  ) +
  xlab("") +
  ylab("Value of Y")


a=standardize(conservation$defor_neighbors)*standardize(conservation$seentheft)

b = ifelse(conservation$defor_neighbors > 2 & conservation$seentheft == 1, 1, 0)
new=select(forestproducts, ends_with("time"))

non_forest_income = df_income$total_inc- df_income$forestinc  
summary(lm(log1p( ) ~ b))


summary(lm(log1p(df_income$forestinc) ~ b + log1p(df_income$total_inc) +  log1p(wealth$total_wealth)))
summary(lm(log1p(non_forest_income) ~ exposure  +  log1p(wealth$total_wealth)))
summary(lm(log1p(forestproducts$firewood_time) ~ b  + log1p(wealth$total_wealth)))
summary(lm(prefernces$wta_final ~ b + log1p(df_income$forestinc) + log1p(wealth$total_wealth)))
summary(lm(conservation$reddrank ~ b + log1p(df_income$forestinc) + log1p(wealth$total_wealth)))
summary(lm(conservation$jumijazaanimfu ~ b + log1p(df_income$forestinc) + log1p(wealth$total_wealth)))


summary(lm(log1p(df_income$forestinc) ~ conservation$defor_neighbors + conservation$seentheft + conservation$defor_neighbors*conservation$seentheft + log1p(effort)))
