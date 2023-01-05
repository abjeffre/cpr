############################################
############ PLOT GAMES ####################

source("Y:\eco_andrews\Projects\CPR\code\script\compliance.R")
source("Y:\eco_andrews\Projects\CPR\code\script\punishment.R")

# Compliance
rm2<-precis(m2)
names<-attributes(rm2)$row.names
par_name = c("bloc", "bnei", "bpem", "bout", "bgov", "bbuis")
name = c("Local", "Neig", "Pemba", "Off", "Gov", "Buis")

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
dat$type = "Compliance"


# Punish


rm3<-precis(m3)
names<-attributes(rm3)$row.names
par_name = c("bloc", "bnei", "bpem", "bout", "bgov", "bbuis")
name = c("Local", "Neig", "Pemba", "Off", "Gov", "Buis")

dat2<-as.data.frame(matrix(NA, nrow = length(name), ncol = 3))
row.names(dat2) <- name
names(dat2) <- c("low", "high", "mean")

cnt <- 1
for(i in par_name){
  dat2$low[cnt] <- rm3$`5.5%`[which(names == i)]
  dat2$high[cnt] <- rm3$`94.5%`[which(names == i)]
  dat2$mean[cnt] <- rm3$mean[which(names == i)]
  cnt <- cnt+1
}

dat2$x = factor(name, levels = rev(name))
dat2$type = "Punishment"

# Bind and plot

d_par = rbind(dat, dat2)


# Plot
comply <-ggplot(dat) +
  geom_segment( aes(x=x, xend=x, y=low, yend=high), color="grey") +
  geom_point( aes(x=x, y=low), size=3 ) +
  geom_point( aes(x=x, y=high), size=3 ) +
  coord_flip()+ 
  geom_hline(yintercept = 0, color = "red") +
  theme_classic() +
  ylim(-1.8, 1.8) +
  theme(
    legend.position = "none",
  ) +
  xlab("") +
  ylab("Par Est") +
  facet_wrap(~type, scales = "free_y", ncol = 2) 


# Plot
punish <-ggplot(dat2) +
  geom_segment( aes(x=x, xend=x, y=low, yend=high), color="grey") +
  geom_point( aes(x=x, y=low), size=3 ) +
  geom_point( aes(x=x, y=high), size=3 ) +
  coord_flip()+ 
  geom_hline(yintercept = 0, color = "red") +
  theme_classic() +
  ylim(-1.8, 1.8) +
  theme(
    legend.position = "none",
  ) +
  xlab("") +
  ylab("Par Est") +
  facet_wrap(~type, scales = "free_y", ncol = 2) 


##################################################
############ GENERIC GAME STATISTICS #############



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


##################################################
############### FINAL PLOT #######################


library(cowplot)
pdf("Y:/eco_andrews/Projects/CPR/Plots/game_results.pdf", height = 3)
  plot_grid(game_p, game_h, comply, punish, ncol = 4, labels = c('a', 'b', 'c', 'd'), label_size = 10)
dev.off()


for(i in 1:nrow(df_income)){
  <-sum(df_income$buisnessinc)
  <-sum(df_income$agroforinc)
  <-sum(df_income$fishinginc)
  <-sum(df_income$fishinginc)
  <-sum(df_income$fishinginc)
}
