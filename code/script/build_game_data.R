source("C:/Users/Jeff/Documents/cpr/code/script/compile_game_choices.R")
library(rethinking)
library(dplyr)

## Construct forest data ####################

forest<- read.csv("C:/Users/jeff/OneDrive/Documents/WTA/data/AmyDataSummary.csv")
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

##### Construct forest data #############

pop<- read.csv("C:/Users/jeff/OneDrive/Documents/forests/data/raw/wards_households2.csv")
wpop <- rep(NA, nrow(demographics))
for(i in 1:nrow(demographics)){
  ind<-which(pop$shehia == demographics$ward[i])
  if(length(ind) > 0) wpop[i] <- pop$households[ind]
}

# ANALYSIS STAGE
# Determine remaining stock for each game at each time point
# Determine the percentange of the maximum allowable stock that was harvested.
cpr_game$round <- as.numeric(cpr_game$round)
cpr_game$per_of_max = 0
cpr_game$final_forest = NA
cpr_game$punished = NA
cpr_game$evaluated = as.numeric(cpr_game$evaluated)
ugid = unique(cpr_game$game_id)
for(i in ugid){
  for(j in c("no-punishment", "punishment")){
    ind <- which(cpr_game$game_id ==i & cpr_game$stage == j)
    max_round = max(cpr_game$round[ind])
    forest = 100
    for(k in 1:max_round){
      rind = which(cpr_game$game_id ==i & cpr_game$stage == j & cpr_game$round == k)
      if(forest > 25) cpr_game$per_of_max[rind] = cpr_game$harvest[rind]/5
      if(forest < 25 & forest > 19) cpr_game$per_of_max[rind] = cpr_game$harvest[rind]/4 
      if(forest < 20 & forest > 14) cpr_game$per_of_max[rind] = cpr_game$harvest[rind]/3 
      if(forest < 15 & forest > 9) cpr_game$per_of_max[rind] = cpr_game$harvest[rind]/2
      if(forest < 10 & forest > 4) cpr_game$per_of_max[rind] = cpr_game$harvest[rind]/1
      harvest = sum(cpr_game$harvest[rind])
      if(j == "punishment"){
        p_bin = cpr_game$harvest[rind][cpr_game$evaluated[rind][1]] > 2 
        punished = rep(0, 5)
        if(is.na(p_bin)) p_bin = FALSE
        if(p_bin == TRUE){ 
          punished[cpr_game$evaluated[rind][1]] =1
        }
        cpr_game$punished[rind] = punished
      }
      forest = forest - harvest # remove harvest
      forest = forest + floor(forest*.1)
      if(forest > 100) forest = 100 
    }
    cpr_game$final_forest[ind] = forest
  }
}



init <- function(x){
  df <- as.data.frame(matrix(NA, nrow = x, ncol = 23))
  names(df) <- c("id", "ward", "twealth",  "game_id", "fcover", "lcover", "pop", "prob", "over", "local", "punished", "buis", "gov", "out", "pemba", "neigh", "harvest_p", "final_forest_p", "harvest_np", "final_forest_np", "gender", "age", "seen")
  return(df)
}



uid = unique(cpr_game$hhid)
dfg = init(0)
for(i in uid){
    df <- init(1)
    df$id <- i
    for(j in c("no-punishment", "punishment")){
      if(j == "no-punishment"){
        ind <- which(cpr_game$hhid ==i & cpr_game$stage == j)
        df$final_forest_np = cpr_game$final_forest[ind][1]
        df$harvest_np = mean(cpr_game$per_of_max[ind])
      }
      if(j == "punishment"){
        ind <- which(cpr_game$hhid ==i & cpr_game$stage == j)
        df$final_forest_p = cpr_game$final_forest[ind][1]
        df$harvest_p = mean(cpr_game$per_of_max[ind])
        df$over = sum(cpr_game$harvest[ind] > 1)
        df$punished = sum(cpr_game$punished[ind])
      }
    }
    df$ward = demographics$ward_id[i]
    df$age = demographics$pres_age[i]
    df$fcover = forest_total[i]
    df$lcover = land_total[i]
    df$pop = wpop[i]
    df$gender = demographics$pres_sex[i]
    df$game_id = cpr_game$game_id[which(cpr_game$hhid ==i)][1]
    df$local = conservation$defor_locals[i]
    df$pemba = conservation$defor_others[i]
    df$gov = conservation$defor_gov[i]
    df$twealth = rowSums(select(trees, ends_with("wealth")), na.rm =T)[i]
    df$out = conservation$defor_outsiders[i]
    df$seen = conservation$seentheft[i]
    df$theft = conservation$tree_stolen[i]
    df$prob = conservation$defor_prob_shehia[i]
    df$buis = conservation$defor_buisness[i]
    df$neigh = conservation$defor_neighbors[i]
    df$cofma = demographics$controls[i]
    dfg = rbind(dfg, df)
}

# Code variables
dfg$ward <- as.factor(dfg$ward)
dfg$game_id <- as.integer(as.factor(dfg$game_id))
dfg$cofma <- as.integer(as.factor(dfg$cofma))
dfg$age <- as.numeric(dfg$age)
dfg$gender <- as.integer(as.numeric(dfg$gender)+1)
dfg$diff = dfg$harvest_p- dfg$harvest_np

# Build Data List 
df <- dfg[complete.cases(dfg),]
d <- as.list(df)
d$harvest_p <- standardize(d$harvest_p)
d$harvest_np <- standardize(d$harvest_np)
d$ward <- as.integer(d$ward)
d$seen <- as.integer(d$seen +1)
d$theft <- as.integer(d$theft +1)
d$final_forest_np <- standardize(d$final_forest_np)
d$over <- standardize(d$over)
d$age <- standardize(d$age)
d$twealth <- standardize(d$twealth)
d$pop <- standardize(d$pop)
d$fcover <- standardize(d$fcover)
d$lcover <- standardize(d$lcover)

# Perc Harvest 
m1<-ulam(
  alist(
    harvest_p ~ normal(mu, sigma),
    mu <- a + bs[seen]*sigma_seen + bt[theft]*sigma_theft + bnei*neigh + bloc*local + blc*lcover + bfc*fcover + bpop*pop  + bgn[gender]*sigma_gender + btw*twealth + ba*age + bp*prob +  bw[ward]*sigma_ward + bg[game_id]*sigma_game_id + bc[cofma]*sigma_cofma + bnp*harvest_np,
    a ~ normal(0, .1),
    bw[ward]  ~ normal(0, .5),
    sigma_ward ~ dexp(2),
    bg[game_id]  ~ normal(0, .5),
    sigma_game_id ~ dexp(2),
    bgn[gender]  ~ normal(0, .5),
    sigma_gender ~ dexp(2),
    bc[cofma]  ~ normal(0, .5),
    sigma_cofma ~ dexp(2),
    sigma_seen ~ dexp(1),
    sigma_theft ~ dexp(1),
    bs[seen] ~ normal(0, 1),
    bt[theft] ~ normal(0, 1),
    bnp ~ normal(0, .5),
    bp ~ normal(0, .5),
    ba ~ normal(0, .5),
    bnei ~ normal(0, 1),
    bff ~ normal(0,.5),
    btw ~ normal(0, .5),
    bpop ~ normal(0, .5),
    blc ~ normal(0, .5),
    bloc ~ normal(0, .5),
    bfc ~ normal(0, .5),
    sigma ~ dexp(1)
  ), data = d, chains =1
)

post <- extract.samples(m1)
dens(post$bs[,2]*post$sigma_seen - post$bs[,1]*post$sigma_seen)
dens(post$bnei)
dens(post$bt[,2]*post$sigma_theft - post$bt[,1]*post$sigma_theft)

dens((post$bnei*5+post$bs[,2]*post$sigma_seen + post$bt[,2]*post$sigma_theft)-
  (post$bnei*0+post$bs[,1]*post$sigma_seen + post$bt[,1]*post$sigma_theft))


# Over
m2<-ulam(
  alist(
    over ~ normal(mu, sigma),
    mu <- a + bs[seen]*sigma_seen + bt[theft]*sigma_theft + bnei*neigh + bloc*local + blc*lcover + bfc*fcover + bpop*pop  + bgn[gender]*sigma_gender + btw*twealth + ba*age + bp*prob +  bw[ward]*sigma_ward + bg[game_id]*sigma_game_id + bc[cofma]*sigma_cofma + bnp*harvest_np,
    a ~ normal(0, .1),
    bw[ward]  ~ normal(0, .5),
    sigma_ward ~ dexp(2),
    bg[game_id]  ~ normal(0, .5),
    sigma_game_id ~ dexp(2),
    bgn[gender]  ~ normal(0, .5),
    sigma_gender ~ dexp(2),
    bc[cofma]  ~ normal(0, .5),
    sigma_cofma ~ dexp(2),
    sigma_seen ~ dexp(1),
    sigma_theft ~ dexp(1),
    bs[seen] ~ normal(0, 1),
    bt[theft] ~ normal(0, 1),
    bnp ~ normal(0, .5),
    bp ~ normal(0, .5),
    ba ~ normal(0, .5),
    bnei ~ normal(0, 1),
    bff ~ normal(0,.5),
    btw ~ normal(0, .5),
    bpop ~ normal(0, .5),
    blc ~ normal(0, .5),
    bloc ~ normal(0, .5),
    bfc ~ normal(0, .5),
    sigma ~ dexp(1)
  ), data = d, chains =1
)

post <- extract.samples(m2)
dens(post$bnei)

dens((post$bnei*5+post$bs[,2]*post$sigma_seen + post$bt[,2]*post$sigma_theft)-
       (post$bnei*0+post$bs[,1]*post$sigma_seen + post$bt[,1]*post$sigma_theft))

dens(post$bnei*5)

# WTA

# Over

df <- data.frame(wta = standardize(prefernces$wta_final),
                 ward = demographics$ward_id,
                 cofma = demographics$controls+1,
                 gender = as.numeric(demographics$pres_sex)+1,
                 age = standardize(as.numeric(demographics$pres_age)),
                 seen = as.integer(conservation$seentheft+1),
                 theft = as.integer(conservation$tree_stolen+1),
                 fcover = standardize(forest_total),
                 lcover = standardize(land_total),
                 pop = standardize(wpop),
                 local = conservation$defor_locals,
                 pemba = conservation$defor_others,
                 gov = conservation$defor_gov,
                 twealth = standardize(rowSums(select(trees, ends_with("wealth")), na.rm =T)),
                 out = conservation$defor_outsiders,
                 prob = conservation$defor_prob_shehia,
                 buis = conservation$defor_buisness,
                 neigh = conservation$defor_neighbors)
                 
df = df[complete.cases(df),]
d = as.list(df)
m3<-ulam(
  alist(
    wta ~ normal(mu, sigma),
    mu <- a + bs[seen]*sigma_seen + bt[theft]*sigma_theft + bnei*neigh + bloc*local + blc*lcover + bfc*fcover + bpop*pop  + bgn[gender]*sigma_gender + btw*twealth + ba*age + bp*prob +  bw[ward]*sigma_ward  + bc[cofma]*sigma_cofma,
    a ~ normal(0, .1),
    bw[ward]  ~ normal(0, .5),
    sigma_ward ~ dexp(2),
    bgn[gender]  ~ normal(0, .5),
    sigma_gender ~ dexp(2),
    bc[cofma]  ~ normal(0, .5),
    sigma_cofma ~ dexp(2),
    sigma_seen ~ dexp(1),
    sigma_theft ~ dexp(1),
    bs[seen] ~ normal(0, 1),
    bt[theft] ~ normal(0, 1),
    ba ~ normal(0, .5),
    bnei ~ normal(0, 1),
    btw ~ normal(0, .5),
    bpop ~ normal(0, .5),
    blc ~ normal(0, .5),
    bp ~ normal(0, .5),
    bloc ~ normal(0, .5),
    bfc ~ normal(0, .5),
    sigma ~ dexp(1)
  ), data = d, chains =1
)


post <- extract.samples(m3)
dens(post$bs[,2]*post$sigma_seen - post$bs[,1]*post$sigma_seen)
dens(post$bnei)
dens(post$bt[,2]*post$sigma_theft - post$bt[,1]*post$sigma_theft)



# To do - Generate predictions about compliance about compliance for those who blame
# ** Improve models to be proper ordered categoricals.
# neighbors and those who do not blame neighboors
# Generate scatter plot of likert for blame and not
# Generate supply curves for WTA for those who blame and those who do not blame
# Finish response to punishment



# Response to punishment should have the following variables 
# Only analyize the first punishment until the second or end. 
# Round number of punishment
# Average harvest pre-punishment
# Average harvest until next punishment
# Number of previous punishments
# The average contribution in the previous round

# Select all stage 2 games
# for each player iterate through and see when they are punished the first time
# Calculate the mean to and including that round
# calculate how size of their punishment
# calculate the size of their harvest until the next time they are punished
# The model will then estimate the size of the reduction in their behavior
# Thus it will be post-punishment-pre-punishment | pre punishment, neighbors, round 

df2 <- cpr_game[]
