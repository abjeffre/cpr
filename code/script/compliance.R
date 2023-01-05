######################################################
############## COMPLIANCE MODEL ######################

source("Y:\eco_andrews\Projects\CPR\code\script\build_game_data.R")


init <- function(x){
  df <- as.data.frame(matrix(NA, nrow = x, ncol = 26))
  names(df) <- c("id", "ward", "twealth", "edu", "inc", "finc", "game_id", "rounds_p", "fcover", "lcover", "pop", "prob", "comply", "local", "punished", "buis", "gov", "out", "pemba", "neigh", "harvest_p", "final_forest_p", "harvest_np", "final_forest_np", "gender", "age")
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
      df$comply = sum(cpr_game$harvest[ind] < 2)
      df$punished = sum(cpr_game$punished[ind])
      df$rounds_p = length(ind)
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
  df$prob = conservation$defor_prob_shehia[i]
  df$buis = conservation$defor_buisness[i]
  df$edu = demographics$pres_edu[i]
  df$neigh = conservation$defor_neighbors[i]
  df$cofma = demographics$controls[i]
  df$finc = log1p(df_income$forestinc[i])
  df$inc = log1p(df_income$total_inc[i])
  dfg = rbind(dfg, df)
}


#################################
####### Impute MISSINGNESS #####
bootstrap <- function(x) sample(x[!is.na(x)], sum(is.na(x)))
imp <- function(x){
  impu<-replicate(5, bootstrap(x))
  if(dims(impu) >1) out<-apply(impu,1, median)
  if(dims(impu) ==1) out<-median(impu)
  return(out)
}

dfg$buis[which(is.na(dfg$buis))] <- imp(dfg$buis)
dfg$gov[which(is.na(dfg$gov))] <- imp(dfg$gov)
dfg$pemba[which(is.na(dfg$pemba))] <- imp(dfg$pemba)
dfg$out[which(is.na(dfg$out))] <- imp(dfg$out)
dfg$finc[which(is.na(dfg$finc))] <- imp(as.numeric(dfg$finc))
dfg$age[which(is.na(dfg$age))] <- imp(dfg$age)

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
d$final_forest_np <- standardize(d$final_forest_np)
# d$over <- standardize(d$over) Do not standardize if using Binomial
d$age <- standardize(d$age)
d$twealth <- standardize(d$twealth)
d$pop <- standardize(d$pop)
d$fcover <- standardize(d$fcover)
d$lcover <- standardize(d$lcover)
d$edu <- as.integer(as.factor(d$edu))
d$inc <- standardize(d$inc)
d$finc <- standardize(d$finc)
# Over
d$alpha <- rep(2, 4)
d$alpha2 <- rep(2, 6)
m2<-ulam(
  alist(
    comply ~ binomial(rounds_p, p),
    logit(p) <- a + bedu*sum(delta_edu[1:edu]) + bnei*sum(delta_n[1:neigh]) + bpem*sum(delta_p[1:pemba]) + bgov*sum(delta_g[1:gov])  + bbuis*sum(delta_b[1:buis]) + bout*sum(delta_o[1:out]) + bloc*sum(delta_l[1:local]) + blc*lcover + bfc*fcover + bpop*pop  + bgn[gender]*sigma_gender + btw*twealth + ba*age  +  bw[ward]*sigma_ward + bg[game_id]*sigma_game_id + bc[cofma]*sigma_cofma + bnp*harvest_np + bfinc*finc + binc*inc,
    a ~ normal(0, .1),
    bw[ward]  ~ normal(0, .5),
    sigma_ward ~ dexp(2),
    bg[game_id]  ~ normal(0, .5),
    sigma_game_id ~ dexp(2),
    bgn[gender]  ~ normal(0, .5),
    sigma_gender ~ dexp(2),
    bc[cofma]  ~ normal(0, .5),
    sigma_cofma ~ dexp(2),
    bnp ~ normal(0, .5),
    ba ~ normal(0, .5),
    bfinc ~ normal(0, .5),
    binc ~ normal(0, .5),
    vector[5]: delta_n <<- append_row(0, deltan),
    vector[5]: delta_o <<- append_row(0, deltao),
    vector[5]: delta_l <<- append_row(0, deltal),
    vector[5]: delta_p <<- append_row(0, deltap),
    vector[5]: delta_b <<- append_row(0, deltab),
    vector[5]: delta_g <<- append_row(0, deltag),
    vector[7]: delta_edu <<- append_row(0, deltaedu),
    simplex[4]: deltan ~ dirichlet(alpha),
    simplex[4]: deltal ~ dirichlet(alpha),
    simplex[4]: deltao ~ dirichlet(alpha),
    simplex[4]: deltap ~ dirichlet(alpha),
    simplex[4]: deltab ~ dirichlet(alpha),
    simplex[4]: deltag ~ dirichlet(alpha),
    simplex[6]: deltaedu ~ dirichlet(alpha2),
    bedu ~ normal(0, .5),
    bnei ~ normal(0, 1),
    bpem ~ normal(0, 1),
    bbuis ~ normal(0, 1),
    bgov ~ normal(0, 1),
    bout ~ normal(0, 1),
    bloc ~ normal(0, .5),
    btw ~ normal(0, .5),
    bpop ~ normal(0, .5),
    blc ~ normal(0, .5),
    bfc ~ normal(0, .5),
    sigma ~ dexp(1)
  ), data = d, chains =1
)

post <- extract.samples(m2)
dens(post$bnei)
dens(post$bloc, add = TRUE, col = "red")
dens(post$bpem, add = TRUE, col = "blue")
dens(post$bout, add = TRUE, col = "green")
dens(post$bgov, add = TRUE, col = "purple")
dens(post$bbuis, add = TRUE, col = "orange")


rm2<-precis(m2)
names<-attributes(rm2)$row.names
par_name = c("bloc", "bnei", "bpem", "bout", "bgov", "bbuis")
name = c("Local", "Neig", "Other", "Off", "Gov", "Buis")

dat<-as.data.frame(matrix(NA, nrow = length(name), ncol = 3))
row.names(dat) <- name
names(dat) <- c("low", "high", "mean")

cnt <- 1
for(i in par_name){
  dat$low[cnt] <- rm2$`5.5%`[which(names == i)]
  dat$high[cnt] <- rm2$`94.5%`[which(names == i)]
  dat$mean[cnt] <- rm2$mean[which(names == i)]
  cnt <- cnt+1
}

dat$x = factor(name, levels = rev(name))


# Plot
comply <-ggplot(dat) +
  geom_segment( aes(x=x, xend=x, y=low, yend=high), color="grey") +
  geom_point( aes(x=x, y=low), size=3 ) +
  geom_point( aes(x=x, y=high), size=3 ) +
  coord_flip()+ 
  geom_hline(yintercept = 0, color = "red") +
  theme_classic() +
  ylim(-1, 1) +
  theme(
    legend.position = "none",
  ) +
  xlab("") +
  ylab("Parameter Esitmate")

