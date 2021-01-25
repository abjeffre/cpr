###################################################################################
##################### BUILDING GAMES ##############################################

choices$game_id %>% as.factor %>% as.integer -> choices$game_id2
choices$stage %>% as.factor %>% as.integer -> choices$stage2
choices$player_num <- as.numeric(choices$player_num)
choices$value <- as.numeric(choices$value)
choices$value_perc <- rep(NA, nrow(choices))

tree_rem <- matrix(nrow = length(unique(choices$game_id)), ncol = 3)
rounds <- matrix(nrow = length(unique(choices$game_id)), ncol = 3)
avg_har <- matrix(nrow = length(unique(choices$game_id)), ncol = 3)
avg_pay <- matrix(nrow = length(unique(choices$game_id)), ncol = 3)
sd_har <- matrix(nrow = length(unique(choices$game_id)), ncol = 3)
bf_psh <- matrix()
af_psh
af2_psh

rnd_har <- array(NA, c(10, 3, 48))

for(i in 1:length(unique(choices$game_id))){
  for(j in 1:length(unique(choices$stage))){
    trees <- 100
    max_har <- 5
    for(k in 1:length(unique(choices$round[choices$game_id2 == i & choices$stage2==j]))){
      if(trees > 100) trees <- 100
      if(trees <= 0)  trees <- 0
      trees <- trees + floor(trees * .1)
      if(trees > 100) trees <- 100
      if(trees <= 0)  trees <- 0
        if(trees < 25) max_har <- 4  
        if(trees < 20) max_har <- 3
        if(trees < 15) max_har <- 2
        if(trees < 10) max_har <- 1
        if(trees < 5)  max_har <- 0
        harvest <- sum(as.numeric(choices$value[choices$game_id2==i & choices$stage2==j & choices$round==k]))
        for(n in 1:5){
          choices$value_perc[choices$game_id2==i & choices$stage2==j & choices$round==k & choices$player_num==n] <- choices$value[choices$game_id2==i & choices$stage2==j & choices$round==k & choices$player_num==n]/max_har
          if(as.numeric(choices$value[choices$game_id2==i & choices$stage2==j & choices$round==k & choices$player_num==n]) > max_har){
          v <- as.numeric(choices$value[choices$game_id2==i & choices$stage2==j & choices$round==k & choices$player_num==n])
          warning(paste("WARNING: Player", n, "in round", k, "in stage", j, "in game", i, "harvested", v,  "which is over max, of", max_har))
          choices$value_perc[choices$game_id2==i & choices$stage2==j & choices$round==k & choices$player_num==n] <- 1
          }
        }
        trees <- trees - harvest
        rnd_har[k, j, i] <- mean(choices$value_perc[choices$game_id2==i & choices$stage2==j & choices$round==k], na.rm = T) 
    }
    tree_rem[i, j] <- ifelse(trees <0, 0, trees)
    rounds[i,j] <- length(unique(choices$round[choices$game_id2 == i & choices$stage2==j]))
    avg_har[i, j] <- mean(choices$value_perc[choices$game_id2==i & choices$stage2==j])
    avg_pay[i, j] <- mean(sum(choices$value[choices$game_id2==i & choices$stage2==j]))
    sd_har[i, j] <- sd(choices$value_perc[choices$game_id2==i & choices$stage2==j])
  }
}

hist(tree_rem[,1], 11)
hist(tree_rem[,3], 11)
hist(avg_har[,1],10)
hist(avg_har[,3])
hist(avg_pay[,1], 20)
hist(avg_pay[,3], 10)
hist(sd_har[,3])
hist(sd_har[,1])


plot(avg_har[,1], tree_rem[,1])
plot(avg_har[,3], tree_rem[,3])
plot(avg_pay[,1], tree_rem[,1])
plot(avg_pay[,3], tree_rem[,3])

plot(avg_har[,1], avg_pay[,1])
plot(avg_har[,3], avg_pay[,3])

plot(sd_har[,1], avg_har[,1])
plot(sd_har[,3], avg_har[,3])
plot(sd_har[,1], tree_rem[,1])
plot(sd_har[,3], tree_rem[,3])


plot(avg_har[,1], avg_har[,3])
plot(avg_pay[,1], avg_pay[,3])

apply(rnd_har[,1,], 1, mean, na.rm = T)

rnd_stg1 <- ((rnd_har[,1,]))
plot(rep(1:10, 48), rnd_stg1)
lm(rnd_stg1 ~ rep(1:10, 48))

summary(lm(choices$value_perc[choices$stage2==1] ~ as.numeric(choices$round[choices$stage2==1])))
