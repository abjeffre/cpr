source("Y:/eco_andrews/Projects/CPR/code/script/compile_game_choices.R")
library(rethinking)
library(dplyr)

## Construct forest data ####################

forest<- read.csv("C:/Users/jeffrey_andrews/OneDrive/Documents/WTA/data/AmyDataSummary.csv")
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

pop<- read.csv("C:/Users/jeffrey_andrews/OneDrive/Documents/forests/data/raw/wards_households2.csv")
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
cpr_game$forest = NA
cpr_game$total_round_harvest <-NA
cpr_game$evaluated = as.numeric(cpr_game$evaluated)
ugid = unique(cpr_game$game_id)
for(i in ugid){
  for(j in c("no-punishment", "punishment")){
    ind <- which(cpr_game$game_id ==i & cpr_game$stage == j)
    max_round = max(cpr_game$round[ind])
    forest = 100
    for(k in 1:max_round){
      rind = which(cpr_game$game_id ==i & cpr_game$stage == j & cpr_game$round == k)
      cpr_game$forest[rind] = forest
      cpr_game$total_round_harvest[rind] = sum(cpr_game$harvest[rind])
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


################################################################################
###################### GRAVE YARD ##############################################

# 
# 
# 
# # Over
# d$alpha <- rep(2, 4)
# m2<-ulam(
#   alist(
#     over ~ binomial(rounds_p, p),
#     logit(p) <- a + bs[seen]*sigma_seen + bt[theft]*sigma_theft + bnei*sum(delta_n[1:neigh]) + + bloc*sum(delta_l[1:local]) + blc*lcover + bfc*fcover + bpop*pop  + bgn[gender]*sigma_gender + btw*twealth + ba*age + bp*prob +  bw[ward]*sigma_ward + bg[game_id]*sigma_game_id + bc[cofma]*sigma_cofma + bnp*harvest_np,
#     a ~ normal(0, .1),
#     bw[ward]  ~ normal(0, .5),
#     sigma_ward ~ dexp(2),
#     bg[game_id]  ~ normal(0, .5),
#     sigma_game_id ~ dexp(2),
#     bgn[gender]  ~ normal(0, .5),
#     sigma_gender ~ dexp(2),
#     bc[cofma]  ~ normal(0, .5),
#     sigma_cofma ~ dexp(2),
#     sigma_seen ~ dexp(1),
#     sigma_theft ~ dexp(1),
#     bs[seen] ~ normal(0, 1),
#     bt[theft] ~ normal(0, 1),
#     bnp ~ normal(0, .5),
#     bp ~ normal(0, .5),
#     ba ~ normal(0, .5),
#     vector[5]: delta_n <<- append_row(0, deltan),
#     vector[5]: delta_l <<- append_row(0, deltal),
#     simplex[4]: deltan ~ dirichlet(alpha),
#     simplex[4]: deltal ~ dirichlet(alpha),
#     bnei ~ normal(0, 1),
#     bff ~ normal(0,.5),
#     btw ~ normal(0, .5),
#     bpop ~ normal(0, .5),
#     blc ~ normal(0, .5),
#     bloc ~ normal(0, .5),
#     bfc ~ normal(0, .5),
#     sigma ~ dexp(1)
#   ), data = d, chains =1
# )
# 
# post <- extract.samples(m2)
# dens(post$bnei)
# dens(post$bloc)
# 
# 
# # To do - Generate predictions about compliance about compliance for those who blame
# # Generate scatter plot of likert for blame and not
# # Generate supply curves for WTA for those who blame and those who do not blame
# # Finish response to punishment
# 
# # Response to punishment should have the following variables 
# # Only analyize the first punishment until the second or end. 
# # Round number of punishment
# # Average harvest pre-punishment
# # Average harvest until next punishment
# # Number of previous punishments
# # The average contribution in the previous round
# 
# # Select all stage 2 games
# # for each player iterate through and see when they are punished the first time
# # Calculate the mean to and including that round
# # calculate how size of their punishment
# # calculate the size of their harvest until the next time they are punished
# # The model will then estimate the size of the reduction in their behavior
# # Thus it will be post-punishment-pre-punishment | pre punishment, neighbors, round 
# init <- function(x){
#   df <- as.data.frame(matrix(NA, nrow = x, ncol = 25))
#   names(df) <- c("id", "ward", "twealth", "comply_before", "comply_after", "rounds",
#                  "game_id", "fcover", "p1", "before", "after", "lcover", "pop",
#                  "prob", "local", "buis", "gov", "out", "pemba", "neigh",
#                  "harvest_np", "final_forest_np", "gender", "age", "seen")
#   return(df)
# }
# 
# 
# dfp <- init(0)
# df2 <- cpr_game[cpr_game$stage == "punishment",]
# uid <- unique(df2$hhid)
# for(i in uid){
#   ind <- which(df2$hhid == i)
#   rounds_punished <- which(df2$punished[ind] > 0)
#   if(length(rounds_punished) > 0){
#     df <- init(1)
#     df$p1 <- rounds_punished[1]
#     df$id = i
#     df$before <- mean(df2[ind, "per_of_max"][1:df$p1])
#     df$comply_before <- sum(df2[ind, "harvest"][1:df$p1] < 2)
#     end <- ifelse(length(rounds_punished) > 1, rounds_punished[2], length(ind))
#     df$after <- mean(df2[ind, "per_of_max"][df$p1:end])
#     df$comply_after <- sum(df2[ind, "harvest"][df$p1:end] < 2)
#     df$rounds <- end-df$p1
#     df$ward = demographics$ward_id[i]
#     df$age = demographics$pres_age[i]
#     df$fcover = forest_total[i]
#     df$lcover = land_total[i]
#     df$pop = wpop[i]
#     df$final_forest_np <- dfg$final_forest_np[dfg$id ==i]
#     df$harvest_np <- dfg$harvest_np[dfg$id ==i]
#     df$gender = demographics$pres_sex[i]
#     df$game_id = cpr_game$game_id[which(df2$hhid ==i)][1]
#     df$local = conservation$defor_locals[i]
#     df$pemba = conservation$defor_others[i]
#     df$gov = conservation$defor_gov[i]
#     df$twealth = rowSums(select(trees, ends_with("wealth")), na.rm =T)[i]
#     df$out = conservation$defor_outsiders[i]
#     df$seen = conservation$seentheft[i]
#     df$theft = conservation$tree_stolen[i]
#     df$prob = conservation$defor_prob_shehia[i]
#     df$buis = conservation$defor_buisness[i]
#     df$neigh = conservation$defor_neighbors[i]
#     df$cofma = demographics$controls[i]
#     dfp<-rbind(dfp, df)
#   }
# }
# 
# dfp <- dfp[dfp$rounds > 0, ]
# dfp = dfp[complete.cases(dfp),]
# d = as.list(dfp)
# 
# # Build Data List 
# d$harvest_np <- standardize(d$harvest_np)
# d$before <- standardize(d$before)
# d$afer <- standardize(d$after)
# 
# d$ward <- as.integer(as.factor(d$ward))
# d$game_id <- as.integer(as.factor(d$game_id))
# d$seen <- as.integer(d$seen +1)
# d$gender <- as.integer(as.numeric(d$gender)+1)
# d$cofma <- as.integer(d$cofma +1)
# d$theft <- as.integer(d$theft +1)
# d$final_forest_np <- standardize(d$final_forest_np)
# d$age <- standardize(as.numeric(d$age))
# d$twealth <- standardize(d$twealth)
# d$pop <- standardize(d$pop)
# d$fcover <- standardize(d$fcover)
# d$lcover <- standardize(d$lcover)
# d$alpha <- rep(2, 4)
# 
# # Compliance after first punishment
# 
# m5<-ulam(
#   alist(
#     comply_after ~ binomial(rounds, p),
#     logit(p) <- a + bs[seen]*sigma_seen + bt[theft]*sigma_theft + bnei*sum(delta_n[1:neigh]) + bloc*sum(delta_l[1:local]) + blc*lcover + bfc*fcover + bpop*pop  + bgn[gender]*sigma_gender + bb*before + btw*twealth + ba*age + bp*prob +  bw[ward]*sigma_ward  + bc[cofma]*sigma_cofma,
#     a ~ normal(0, .1),
#     bw[ward]  ~ normal(0, .5),
#     sigma_ward ~ dexp(2),
#     bgn[gender]  ~ normal(0, .5),
#     sigma_gender ~ dexp(2),
#     bc[cofma]  ~ normal(0, .5),
#     sigma_cofma ~ dexp(2),
#     sigma_seen ~ dexp(1),
#     sigma_theft ~ dexp(1),
#     bs[seen] ~ normal(0, 1),
#     bt[theft] ~ normal(0, 1),
#     ba ~ normal(0, .5),
#     bnei ~ normal(0, 1),
#     bb ~ normal(0, 1),
#     vector[5]: delta_n <<- append_row(0, deltan),
#     vector[5]: delta_l <<- append_row(0, deltal),
#     simplex[4]: deltan ~ dirichlet(alpha),
#     simplex[4]: deltal ~ dirichlet(alpha),
#     btw ~ normal(0, .5),
#     bpop ~ normal(0, .5),
#     blc ~ normal(0, .5),
#     bp ~ normal(0, .5),
#     bloc ~ normal(0, .5),
#     bfc ~ normal(0, .5),
#     sigma ~ dexp(1)
#   ), data = d, chains =1
# )
# 
# post <- extract.samples(m5)
# dens(post$bnei)
# 

# 
# 
# ##############################
# ########### WTA ##############
# 
# df <- data.frame(wta = standardize(prefernces$wta_final),
#                  ward = demographics$ward_id,
#                  cofma = demographics$controls+1,
#                  gender = as.numeric(demographics$pres_sex)+1,
#                  age = standardize(as.numeric(demographics$pres_age)),
#                  seen = as.integer(conservation$seentheft+1),
#                  theft = as.integer(conservation$tree_stolen+1),
#                  fcover = standardize(forest_total),
#                  lcover = standardize(land_total),
#                  pop = standardize(wpop),
#                  local = conservation$defor_locals,
#                  pemba = conservation$defor_others,
#                  gov = conservation$defor_gov,
#                  protest = ifelse(exp(prefernces$wta_final)/2500 > 4000 | prefernces$priced_out ==1, 1, 0),
#                  twealth = standardize(rowSums(select(trees, ends_with("wealth")), na.rm =T)),
#                  out = conservation$defor_outsiders,
#                  prob = conservation$defor_prob_shehia,
#                  buis = conservation$defor_buisness,
#                  neigh = conservation$defor_neighbors,
#                  e_id = as.integer(demographics$enum_id))
# 
# # add in deontologists
# df = df[complete.cases(df),]
# d = as.list(df)
# d$alpha <- rep(2, 4)
# 
# m3<-ulam(
#   alist(
#     wta ~ normal(mu, sigma),
#     mu <- a + bs[seen]*sigma_seen + bt[theft]*sigma_theft + bnei*sum(delta_n[1:neigh]) + bloc*sum(delta_l[1:local]) + blc*lcover + bfc*fcover + bpop*pop  + bgn[gender]*sigma_gender + btw*twealth + ba*age + bp*prob +  bw[ward]*sigma_ward  + bc[cofma]*sigma_cofma,
#     a ~ normal(0, .1),
#     bw[ward]  ~ normal(0, .5),
#     sigma_ward ~ dexp(2),
#     bgn[gender]  ~ normal(0, .5),
#     sigma_gender ~ dexp(2),
#     bc[cofma]  ~ normal(0, .5),
#     sigma_cofma ~ dexp(2),
#     sigma_seen ~ dexp(1),
#     sigma_theft ~ dexp(1),
#     bs[seen] ~ normal(0, 1),
#     bt[theft] ~ normal(0, 1),
#     be[e_id] ~ normal(0, 1),
#     sigma_e ~ dexp(2),
#     ba ~ normal(0, .5),
#     bnei ~ normal(0, 1),
#     vector[5]: delta_n <<- append_row(0, deltan),
#     vector[5]: delta_l <<- append_row(0, deltal),
#     simplex[4]: deltan ~ dirichlet(alpha),
#     simplex[4]: deltal ~ dirichlet(alpha),
#     btw ~ normal(0, .5),
#     bpop ~ normal(0, .5),
#     blc ~ normal(0, .5),
#     bp ~ normal(0, .5),
#     bloc ~ normal(0, .5),
#     bfc ~ normal(0, .5),
#     sigma ~ dexp(1)
#   ), data = d, chains =1
# )
# 
# 
# post <- extract.samples(m3)
# dens(post$bnei)
# 
# # TRIPLE HURLDE MODEL - probably excessive. 
# 
# 
# df <- data.frame(wta = log10(exp(prefernces$wta_final)/2500+1),
#                  ward = demographics$ward_id,
#                  cofma = demographics$controls+1,
#                  gender = as.numeric(demographics$pres_sex)+1,
#                  age = standardize(as.numeric(demographics$pres_age)),
#                  seen = as.integer(conservation$seentheft+1),
#                  theft = as.integer(conservation$tree_stolen+1),
#                  fcover = standardize(forest_total),
#                  lcover = standardize(land_total),
#                  pop = standardize(wpop),
#                  local = conservation$defor_locals,
#                  pemba = conservation$defor_others,
#                  gov = conservation$defor_gov,
#                  protest = ifelse(exp(prefernces$wta_final)/2500 > 4000 | prefernces$priced_out ==1, 1, 0),
#                  twealth = standardize(rowSums(select(trees, ends_with("wealth")), na.rm =T)),
#                  out = conservation$defor_outsiders,
#                  prob = conservation$defor_prob_shehia,
#                  buis = conservation$defor_buisness,
#                  neigh = conservation$defor_neighbors)
# 
# # add in deontologists
# df$deontologist = ifelse(df$protest == 0 & df$wta == 0, 1, 0)
# df$in_market = ifelse(df$protest == 0 & df$deontologist ==0, 1, 0)
# df = df[complete.cases(df),]
# d = as.list(df)
# d$alpha <- rep(2, 4)
# d$wta_s = standardize(d$wta)
# 
# m3.1<-ulam(
#   alist(
#     # First do the protest model
#     protest ~ dbinom(1, p_p),
#     # Next do the Deontologists
#     deontologist ~ dbinom(1, p_d),
#     # The log-normal side of the hurdle model 
#     wta_s |in_market == 1 ~ normal(mu, sigma),
#     # Linear equations
#     logit(p_p) <- a1  + bnei1*sum(delta_n1[1:neigh]) + bloc1*sum(delta_l1[1:local]) + blc1*lcover + bfc1*fcover + bpop1*pop  + bgn1[gender]*sigma_gender1 + btw1*twealth + ba1*age +  bw1[ward]*sigma_ward1  + bc1[cofma]*sigma_cofma1,
#     logit(p_d) <- a2  + bnei2*sum(delta_n2[1:neigh]) + bloc2*sum(delta_l2[1:local]) + blc2*lcover + bfc2*fcover + bpop2*pop  + bgn2[gender]*sigma_gender2 + btw2*twealth + ba2*age +  bw2[ward]*sigma_ward2  + bc2[cofma]*sigma_cofma2,
#     mu <-         a3  + bnei3*sum(delta_n3[1:neigh]) + bloc3*sum(delta_l3[1:local]) + blc3*lcover + bfc3*fcover + bpop3*pop  + bgn3[gender]*sigma_gender3 + btw3*twealth + ba3*age +  bw3[ward]*sigma_ward3  + bc3[cofma]*sigma_cofma3,
#     # Priors
#     # Intercepts     
#     a1~ normal(-3, 1),
#     a2~ normal(-3, 1),
#     a3~ normal(0, .1),
#     # Wards 
#     bw1[ward]  ~ normal(0, .5),
#     bw2[ward]  ~ normal(0, .5),
#     bw3[ward]  ~ normal(0, .5),
#     sigma_ward1 ~ dexp(2),
#     sigma_ward2 ~ dexp(2),
#     sigma_ward3 ~ dexp(2),
#     # Gender
#     bgn1[gender]  ~ normal(0, .5),
#     bgn2[gender]  ~ normal(0, .5),
#     bgn3[gender]  ~ normal(0, .5),
#     sigma_gender1 ~ dexp(2),
#     sigma_gender2 ~ dexp(2),
#     sigma_gender3 ~ dexp(2),
#     # Cofma
#     bc1[cofma]  ~ normal(0, .5),
#     bc2[cofma]  ~ normal(0, .5),
#     bc3[cofma]  ~ normal(0, .5),
#     sigma_cofma1 ~ dexp(2),
#     sigma_cofma2 ~ dexp(2),
#     sigma_cofma3 ~ dexp(2),
#     # age 
#     ba1 ~ normal(0, .5),
#     ba2 ~ normal(0, .5),
#     ba3 ~ normal(0, .5),
#     # neighbours
#     bnei1 ~ normal(0, 1),
#     bnei2 ~ normal(0, 1),
#     bnei3 ~ normal(0, 1),
#     vector[5]: delta_n1 <<- append_row(0, deltan1),
#     vector[5]: delta_n2 <<- append_row(0, deltan2),
#     vector[5]: delta_n3 <<- append_row(0, deltan3),
#     simplex[4]: deltan1 ~ dirichlet(alpha),
#     simplex[4]: deltan2 ~ dirichlet(alpha),
#     simplex[4]: deltan3 ~ dirichlet(alpha),
#     # Local 
#     bloc1 ~ normal(0, 1),
#     bloc2 ~ normal(0, 1),
#     bloc3 ~ normal(0, 1),
#     vector[5]: delta_l1 <<- append_row(0, deltal1),
#     vector[5]: delta_l2 <<- append_row(0, deltal2),
#     vector[5]: delta_l3 <<- append_row(0, deltal3),
#     simplex[4]: deltal1 ~ dirichlet(alpha),
#     simplex[4]: deltal2 ~ dirichlet(alpha),
#     simplex[4]: deltal3 ~ dirichlet(alpha),
#     # Wealth
#     btw1 ~ normal(0, .5),
#     btw2 ~ normal(0, .5),
#     btw3 ~ normal(0, .5),
#     # Population
#     bpop1 ~ normal(0, .5),
#     bpop2 ~ normal(0, .5),
#     bpop3 ~ normal(0, .5),
#     # Land size
#     blc1 ~ normal(0, .5),
#     blc2 ~ normal(0, .5),
#     blc3 ~ normal(0, .5),
#     # Forest cover
#     bfc1 ~ normal(0, .5),
#     bfc2 ~ normal(0, .5),
#     bfc3 ~ normal(0, .5),
#     # Problem
#     bp1 ~ normal(0, .5),
#     bp2 ~ normal(0, .5),
#     bp3 ~ normal(0, .5),
#     sigma ~ dexp(1)
#   ), data = d, chains =1
# )
# 


# 
# # Harvest after first punishment
# m4<-ulam(
#   alist(
#     after ~ normal(mu, sigma),
#     mu <- a + bs[seen]*sigma_seen + bt[theft]*sigma_theft + bnei*sum(delta_n[1:neigh]) + bloc*sum(delta_l[1:local]) + blc*lcover + bfc*fcover + bpop*pop  + bgn[gender]*sigma_gender + bb*before + btw*twealth + ba*age + bp*prob +  bw[ward]*sigma_ward  + bc[cofma]*sigma_cofma,
#     a ~ normal(0, .1),
#     bw[ward]  ~ normal(0, .5),
#     sigma_ward ~ dexp(2),
#     bgn[gender]  ~ normal(0, .5),
#     sigma_gender ~ dexp(2),
#     bc[cofma]  ~ normal(0, .5),
#     sigma_cofma ~ dexp(2),
#     sigma_seen ~ dexp(1),
#     sigma_theft ~ dexp(1),
#     bs[seen] ~ normal(0, 1),
#     bt[theft] ~ normal(0, 1),
#     ba ~ normal(0, .5),
#     bnei ~ normal(0, 1),
#     bb ~ normal(0, 1),
#     vector[5]: delta_n <<- append_row(0, deltan),
#     vector[5]: delta_l <<- append_row(0, deltal),
#     simplex[4]: deltan ~ dirichlet(alpha),
#     simplex[4]: deltal ~ dirichlet(alpha),
#     btw ~ normal(0, .5),
#     bpop ~ normal(0, .5),
#     blc ~ normal(0, .5),
#     bp ~ normal(0, .5),
#     bloc ~ normal(0, .5),
#     bfc ~ normal(0, .5),
#     sigma ~ dexp(1)
#   ), data = d, chains =1
# )
# 
# post <- extract.samples(m4)
# dens(post$bnei)


# 
# # Perc Harvest 
# m1<-ulam(
#   alist(
#     harvest_p ~ normal(mu, sigma),
#     mu <- a + bs[seen]*sigma_seen + bt[theft]*sigma_theft + bnei*neigh + bloc*local + blc*lcover + bfc*fcover + bpop*pop  + bgn[gender]*sigma_gender + btw*twealth + ba*age + bp*prob +  bw[ward]*sigma_ward + bg[game_id]*sigma_game_id + bc[cofma]*sigma_cofma + bnp*harvest_np,
#     a ~ normal(0, .1),
#     bw[ward]  ~ normal(0, .5),
#     sigma_ward ~ dexp(2),
#     bg[game_id]  ~ normal(0, .5),
#     sigma_game_id ~ dexp(2),
#     bgn[gender]  ~ normal(0, .5),
#     sigma_gender ~ dexp(2),
#     bc[cofma]  ~ normal(0, .5),
#     sigma_cofma ~ dexp(2),
#     sigma_seen ~ dexp(1),
#     sigma_theft ~ dexp(1),
#     bs[seen] ~ normal(0, 1),
#     bt[theft] ~ normal(0, 1),
#     bnp ~ normal(0, .5),
#     bp ~ normal(0, .5),
#     ba ~ normal(0, .5),
#     bnei ~ normal(0, 1),
#     bff ~ normal(0,.5),
#     btw ~ normal(0, .5),
#     bpop ~ normal(0, .5),
#     blc ~ normal(0, .5),
#     bloc ~ normal(0, .5),
#     bfc ~ normal(0, .5),
#     sigma ~ dexp(1)
#   ), data = d, chains =1
# )
# 
# post <- extract.samples(m1)
# dens(post$bs[,2]*post$sigma_seen - post$bs[,1]*post$sigma_seen)
# dens(post$bnei)
# dens(post$bt[,2]*post$sigma_theft - post$bt[,1]*post$sigma_theft)
# 
# dens((post$bnei*5+post$bs[,2]*post$sigma_seen + post$bt[,2]*post$sigma_theft)-
#        (post$bnei*0+post$bs[,1]*post$sigma_seen + post$bt[,1]*post$sigma_theft))
# 




