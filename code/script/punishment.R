####################################################################
################# COMPLIANCE AFTER PUNISHMENT ######################


source("Y:\eco_andrews\Projects\CPR\code\script\build_game_data.R")


init <- function(x){
  df <- as.data.frame(matrix(NA, nrow = x, ncol = 26))
  names(df) <- c("id", "ward", "twealth", "comply_before", "inc", "finc", "comply_after", "rounds", "forest_before",
                 "game_id", "fcover", "p1", "before", "after", "lcover", "pop",
                 "local", "buis", "gov", "out", "pemba", "neigh",
                 "harvest_np", "final_forest_np", "gender", "age", "edu")
  return(df)
}


dfp <- init(0)
df2 <- cpr_game[cpr_game$stage == "punishment",]
uid <- unique(df2$hhid)
for(i in uid){
  ind <- which(df2$hhid == i)
  rounds_punished <- which(df2$punished[ind] > 0)
  if(length(rounds_punished) > 0){
    df <- init(1)
    df$p1 <- rounds_punished[1]
    df$id = i
    df$before <- mean(df2[ind, "per_of_max"][1:df$p1])
    df$comply_before <- mean(df2[ind, "harvest"][1:df$p1] < 2)
    df$forest_before <- df2[ind, "forest"][df$p1]/10
    end <- ifelse(length(rounds_punished) > 1, rounds_punished[2], length(ind))
    df$after <- mean(df2[ind, "per_of_max"][df$p1:end])
    df$comply_after <- sum(df2[ind, "harvest"][df$p1:end] < 2)
    df$rounds <- end-df$p1
    df$ward = demographics$ward_id[i]
    df$age = demographics$pres_age[i]
    df$fcover = forest_total[i]
    df$lcover = land_total[i]
    df$pop = wpop[i]
    df$final_forest_np <- dfg$final_forest_np[dfg$id ==i]
    df$harvest_np <- dfg$harvest_np[dfg$id ==i]
    df$gender = demographics$pres_sex[i]
    df$edu = as.integer(demographics$pres_edu[i])
    df$game_id = cpr_game$game_id[which(df2$hhid ==i)][1]
    df$local = conservation$defor_locals[i]
    df$pemba = conservation$defor_others[i]
    df$gov = conservation$defor_gov[i]
    df$twealth = rowSums(select(trees, ends_with("wealth")), na.rm =T)[i]
    df$out = conservation$defor_outsiders[i]
    df$buis = conservation$defor_buisness[i]
    df$neigh = conservation$defor_neighbors[i]
    df$cofma = demographics$controls[i]
    df$finc = log1p(df_income$forestinc[i])
    df$inc = log1p(df_income$total_inc[i])
    
    dfp<-rbind(dfp, df)
  }
}

#################################
####### BOOTSTRAP MISSINGNESS ###
bootstrap <- function(x) sample(x[!is.na(x)], sum(is.na(x)))
imp <- function(x){
  impu<-replicate(5, bootstrap(x))
  if(dims(impu) >1) out<-apply(impu,1, median)
  if(dims(impu) ==1) out<-median(impu)
  return(out)
}

dfp$buis[which(is.na(dfp$buis))] <- imp(dfp$buis)
dfp$gov[which(is.na(dfp$gov))] <- imp(dfp$gov)
dfp$pemba[which(is.na(dfp$pemba))] <- imp(dfp$pemba)
dfp$out[which(is.na(dfp$out))] <- imp(dfp$out)
dfp$finc[which(is.na(dfp$finc))] <- imp(dfp$finc)
dfp$age[which(is.na(dfp$age))] <- imp(dfp$age)

dfp <- dfp[dfp$rounds > 0, ]
dfp = dfp[complete.cases(dfp),]
d = as.list(dfp)

# Build Data List 
d$harvest_np <- standardize(d$harvest_np)
d$before <- standardize(d$before)
d$after <- standardize(d$after)
d$ward <- as.integer(as.factor(d$ward))
d$game_id <- as.integer(as.factor(d$game_id))
d$gender <- as.integer(as.numeric(d$gender)+1)
d$cofma <- as.integer(d$cofma +1)
d$final_forest_np <- standardize(d$final_forest_np)
d$age <- standardize(as.numeric(d$age))
d$twealth <- standardize(d$twealth)
d$pop <- standardize(d$pop)
d$fcover <- standardize(d$fcover)
d$lcover <- standardize(d$lcover)
d$alpha <- rep(2, 4)
d$round_p <- d$p1
d$pemba <- as.integer(d$pemba)
d$neigh <- as.integer(d$neigh)
d$out <- as.integer(d$out)
d$pemba <- as.integer(d$pemba)
d$buis <- as.integer(d$buis)
d$gov <- as.integer(d$gov)
d$edu <- as.integer(as.factor(d$edu))
d$inc <- standardize(d$inc)
d$finc <- standardize(d$finc)

dist <- matrix(NA, ncol = 10, nrow = 10)
for(i in 1:10){
  for(j in 1:10){
    dist[i,j] <- abs(i-j)
  }
}

d$dist <- dist
d$alpha <- rep(2, 4)
d$alpha2 <- rep(2, 6)
d$N <- length(d$id)



m3 = stan(model_code = "functions{


    matrix cov_GPL2(matrix x, real sq_alpha, real sq_rho, real delta) {
        int N = dims(x)[1];
        matrix[N, N] K;
        for (i in 1:(N-1)) {
          K[i, i] = sq_alpha + delta;
          for (j in (i + 1):N) {
            K[i, j] = sq_alpha * exp(-sq_rho * square(x[i,j]) );
            K[j, i] = K[i, j];
          }
        }
        K[N, N] = sq_alpha + delta;
        return K;
    }
}

data{
    int N;
    int round_p[N];
    vector[N] after;
    vector[N] before;
    int p1[N];
    int id[N];
    int rounds[N];
    int comply_after[N];
    vector[N] harvest_np;
    int cofma[N];
    int game_id[N];
    int ward[N];
    vector[N] age;
    vector[N] twealth;
    int gender[N];
    int edu [N];
    vector[N] pop;
    vector[N] fcover;
    vector[N] lcover;
    vector[N] finc;
    vector[N] inc;
    int local[N];
    int out[N];
    int buis[N];
    int gov[N];
    int pemba[N];
    int neigh[N];
    matrix[10, 10] dist;
    vector[N] forest_before;
    vector[N] final_forest_np;
    vector[N] comply_before;
    vector<lower=0>[4] alpha;
}
parameters{
    vector[10] k;
    real<lower=0> etasq;
    real<lower=0> rhosq;
    real a;
    vector[24] bw;
    real<lower=0> sigma_ward;
    vector[21] bg;
    real<lower=0> sigma_game_id;
    vector[2] bgn;
    real<lower=0> sigma_gender;
    vector[2] bc;
    real<lower=0> sigma_cofma;
    real bnp;
    real ba;
    real bb;
    real bf;
    real bff;
    real bfinc;
    real binc;
    simplex[4] deltan;
    simplex[4] deltal;
    simplex[4] deltao;
    simplex[4] deltap;
    simplex[4] deltab;
    simplex[4] deltag;
    simplex[4] deltaedu;
    real bnei;
    real bpem;
    real bbuis;
    real bgov;
    real bout;
    real btw;
    real bpop;
    real blc;
    real bloc;
    real bfc;
    real bedu;
    real<lower=0> sigma;
}
model{
    vector[N] p;
    matrix[10,10] SIGMA;
    vector[5] delta_n;
    vector[5] delta_o;
    vector[5] delta_l;
    vector[5] delta_p;
    vector[5] delta_b;
    vector[5] delta_g;
    vector[5] delta_edu;
    sigma ~ exponential( 1 );
    bfc ~ normal( 0 , 0.5 );
    bloc ~ normal( 0 , 0.5 );
    blc ~ normal( 0 , 0.5 );
    bpop ~ normal( 0 , 0.5 );
    btw ~ normal( 0 , 0.5 );
    bout ~ normal( 0 , 1 );
    bgov ~ normal( 0 , 1 );
    bbuis ~ normal( 0 , 1 );
    bpem ~ normal( 0 , 1 );
    bnei ~ normal( 0 , 1 );
    deltag ~ dirichlet( alpha );
    deltab ~ dirichlet( alpha );
    deltap ~ dirichlet( alpha );
    deltao ~ dirichlet( alpha );
    deltal ~ dirichlet( alpha );
    deltan ~ dirichlet( alpha );
    deltaedu ~ dirichlet( alpha );
    delta_g = append_row(0, deltag);
    delta_b = append_row(0, deltab);
    delta_p = append_row(0, deltap);
    delta_l = append_row(0, deltal);
    delta_o = append_row(0, deltao);
    delta_n = append_row(0, deltan);
    delta_edu = append_row(0, deltaedu);
    bff ~ normal( 0 , 0.5 );
    bf ~ normal( 0 , 0.5 );
    bb ~ normal( 0 , 0.5 );
    ba ~ normal( 0 , 0.5 );
    bfinc ~ normal( 0 , 0.5 );
    binc ~ normal( 0 , 0.5 );
    bnp ~ normal( 0 , 0.5 );
    sigma_cofma ~ exponential( 2 );
    bc ~ normal( 0 , 0.5 );
    sigma_gender ~ exponential( 2 );
    bgn ~ normal( 0 , 0.5 );
    sigma_game_id ~ exponential( 2 );
    bg ~ normal( 0 , 0.5 );
    sigma_ward ~ exponential( 2 );
    bw ~ normal( 0.43 , 0.1 );
    a ~ normal( 0 , 1 );
    rhosq ~ exponential( 0.5 );
    etasq ~ exponential( 2 );
    SIGMA = cov_GPL2(dist, etasq, rhosq, 0.01);
    k ~ multi_normal( rep_vector(0,10) , SIGMA );
    for ( i in 1:N ) {
        p[i] = a + + k[p1[i]] + bb * comply_before[i] + bff * final_forest_np[i] + binc*inc[i] + bfinc*finc[i] +  bf * forest_before[i] + bedu * sum(delta_edu[1:edu[i]]) + bnei * sum(delta_n[1:neigh[i]]) + bpem * sum(delta_p[1:pemba[i]]) + bgov * sum(delta_g[1:gov[i]]) + bbuis * sum(delta_b[1:buis[i]]) + bout * sum(delta_o[1:out[i]]) + bloc * sum(delta_l[1:local[i]]) + blc * lcover[i] + bfc * fcover[i] + bpop * pop[i] + bgn[gender[i]] * sigma_gender + btw * twealth[i] + ba * age[i] + bw[ward[i]] * sigma_ward + bg[game_id[i]] * sigma_game_id + bc[cofma[i]] * sigma_cofma + bnp * harvest_np[i];
        p[i] = inv_logit(p[i]);
    }
    comply_after ~ binomial( rounds , p );
}", cores = 1, chains = 1, data = d)


post <- extract.samples(m3)
dens(post$bnei)
dens(post$bloc, add = TRUE, col = "red")
dens(post$bpem, add = TRUE, col = "blue")
dens(post$bout, add = TRUE, col = "green")
dens(post$bgov, add = TRUE, col = "purple")
dens(post$bbuis, add = TRUE, col = "orange")


rm3<-precis(m3)
names<-attributes(rm3)$row.names
par_name = c("bloc", "bnei", "bpem", "bout", "bgov", "bbuis")
name = c("Local", "Neig", "Other", "Off", "Gov", "Buis")

dat<-as.data.frame(matrix(NA, nrow = length(name), ncol = 3))
row.names(dat) <- name
names(dat) <- c("low", "high", "mean")

cnt <- 1
for(i in par_name){
  dat$low[cnt] <- rm3$`5.5%`[which(names == i)]
  dat$high[cnt] <- rm3$`94.5%`[which(names == i)]
  dat$mean[cnt] <- rm3$mean[which(names == i)]
  cnt <- cnt+1
}

dat$x = factor(name, levels = rev(name))

# Plot
punish <-ggplot(dat) +
  geom_segment( aes(x=x, xend=x, y=low, yend=high), color="grey") +
  geom_point( aes(x=x, y=low), size=3 ) +
  geom_point( aes(x=x, y=high), size=3 ) +
  coord_flip()+ 
  geom_hline(yintercept = 0, color = "red") +
  theme_classic() +
  ylim(-2.5, 2.5) +
  theme(
    legend.position = "none",
  ) +
  xlab("") +
  ylab("Parameter Esitmate")

