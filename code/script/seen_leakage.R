t <- table(demographics$controls, conservation$tree_stolen)
t[1,]<-t[1,]/rowSums(t)[1]
t[2,]<-t[2,]/rowSums(t)[2]


colnames(t) <- c("Victim of leakage", "Not victim of leakage")
rownames(t) <- c("cofma", "control")

df <- data.frame(Y = conservation$tree_stolen,
                 X = demographics$controls)
df<- df[complete.cases(df),]

data <- list(
  Y = as.integer(df$Y),
  X = as.integer(df$X+1),
  N = nrow(df)
)



model <- stan( file = "/home/jeffrey_andrews/cpr/code/models/seen_leakage.stan",
               data=data, iter = 2000,
               cores = 4, chains = 4, control = list(adapt_delta =0.99, max_treedepth = 10))
