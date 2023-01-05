###################################################################
################ SUMMARY STATS ####################################

df<-conservation[unique(cpr_game$hhid),3:9]

value <- c()
type <- c()
names <- c("Local", "Neig", "Pemba", "Off", "Gov", "Buis" )

for(i in 1:6){
  value<-c(value, table(df[,i])/sum(table(df[,i])))
  type <-c(type, rep(names[i], length(table(df[,i]))))
}

d <- data.frame(value = value,
                type = type,
                score = attributes(value))

d$type = factor(d$type, levels = names)
names(d) <- c("Proportions", "Type", "Response")

d$Response[d$Response==1] <- "Comp. Dis"
d$Response[d$Response==2] <- "Dis"
d$Response[d$Response==3] <- "Neut"
d$Response[d$Response==4] <- "Agr"
d$Response[d$Response==5] <- "Comp. Agr"

d$Response <- factor(d$Response, levels = c("Comp. Dis", "Dis", "Neut", "Agr", "Comp. Agr"))

ggplot(d, aes(x = Response, y = Proportions)) +
  geom_bar(stat = "identity")+
  facet_wrap(~Type, scales = "free_y", ncol = 1) +
  theme_classic()+
  ylim(0, 1)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

########################################
######## SUMMARY STATS #################

library(stargazer)

df<-dfg[,c("age", "gender", "edu", "inc", "finc", "fcover", "lcover", "pop", "local", "neigh", "pemba", "out", "gov", "buis")]
df$gender <- df$gender-1
df$inc <- exp(df$inc)/2500
df$finc <- exp(df$finc)/2500
df$edu <- df$edu>3
df$fcover <- df$fcover/100
df$lcover <- df$lcover/100


names(df) <- c("Age", "Male", "Edu", "Inc (USD)", "Forest inc (USD)", "Forest cover", "Land cover", "Households", "Local", "Neig", "Pemba", "Off", "Gov", "Buis")
df <- df[complete.cases(df),]

stargazer(df, digits = 2)