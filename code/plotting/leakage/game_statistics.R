###################################################################
##################### GAME STATS ##################################

source("Y:\eco_andrews\Projects\CPR\code\script\build_game_data.R")


dp = cpr_game[cpr_game$stage == "no-punishment", ]
forest = c()
round = c()
game = c()


for(i in unique(dp$game_id)){
  for(j in 1:max(dp$round[which(dp$game_id==i)])){
    forest = c(forest, dp$forest[which(dp$game_id==i &dp$round==j)][1])
    round = c(round, j)
    game = c(game, i)
  }
}
game <- as.integer(as.factor(game))
d1=data.frame(Forest= forest,
           game = game,
           Round = as.integer(round))
d1$type = "Stage 1"

game_np<-ggplot(d, aes(x = Round, y = Forest, group =  game)) +
  geom_line(alpha = .5) +
  geom_point(alpha = .5) +
  theme_classic()

dp = cpr_game[cpr_game$stage == "punishment", ]
forest = c()
round = c()
game = c()


for(i in unique(dp$game_id)){
  for(j in 1:max(dp$round[which(dp$game_id==i)])){
    forest = c(forest, dp$forest[which(dp$game_id==i &dp$round==j)][1])
    round = c(round, j)
    game = c(game, i)
  }
}
game <- as.integer(as.factor(game))
d2=data.frame(Forest = forest,
             game = game,
             Round = as.integer(round))

d2=d2[-which(d$game == 16),]
d2$type = "Stage 2"

game_p<-ggplot(d, aes(x = Round, y = Forest, group =  game)) +
  geom_line(alpha = .5) +
  geom_point(alpha = .5) +
  theme_classic() +
  ylim(0, 100)


d<- rbind(d1, d2)


game_p<-ggplot(d, aes(x = Round, y = Forest, group =  game)) +
  geom_line(alpha = .5) +
  geom_point(alpha = .5) +
  theme_classic() +
  ylim(0, 100) + 
  facet_wrap(~type, scales = "free_y", ncol = 1)




##########################################
########## AVERAGE HARVEST ###############


dp = cpr_game[cpr_game$stage == "no-punishment", ]
harvest = c()
round = c()
game = c()

for(j in 1:10){
  harvest = c(harvest, mean(dp$per_of_max[which(dp$round==j)]))
  round = c(round, j)
}


d3=data.frame(Harvest = harvest,
             Round = as.integer(round))


d3$type = "Stage 1"


dp = cpr_game[cpr_game$stage == "punishment", ]
harvest = c()
round = c()
game = c()

for(j in 1:10){
    harvest = c(harvest, mean(dp$per_of_max[which(dp$round==j)]))
    round = c(round, j)
}


d4=data.frame(Harvest = harvest,
             Round = as.integer(round))

d4$type = "Stage 2"


dh <- rbind(d3, d4)

game_h<-ggplot(dh, aes(x = Round, y = Harvest)) +
  geom_col(alpha = .5) +
  theme_classic() +
  ylim(0, 1) +
  facet_wrap(~type, scales = "free_y", ncol = 1) 



library(cowplot)
plot_grid(game_p, game_h, comply, punish, ncol = 4)

