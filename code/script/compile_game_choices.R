#################################
########## 
setwd("C:/Users/jeff/OneDrive/Documents/")
#setwd("C:/Users/jeffrey_andrews/OneDrive/Documents/")
source("C:/Users/jeff/OneDrive/Documents/forests/data/dataframes/load_df.R")


##########################################
########### BUILD SHEHIA LIST ############

cl <- choices_long

# This will be used to reduce errors in matching processes
shehia_games=unique(cl$game_id)
shehia<-unique(demographics$ward)
shehia_codes <- c("changaweni",
                  "changaweni",
                  "chumbageni",
                  "chumbageni",
                  "fundo",
                  "fundo",
                  "gando",
                  "gando",
                  "kambini",
                  "kambini",
                  "kangani",
                  "kangani",
                  "kifundi",
                  "kifundi",
                  "kilindi",
                  "kilindi",
                  "kisiwa panza",
                  "kisiwa panza",
                  "mgelema",
                  "mgelema",
                  "mgogoni",
                  "mgogoni",
                  "michenzani",
                  "michenzani",
                  "mjimbini",
                  "mjimbini",
                  "mjini wingwi",
                  "mjini wingwi",
                  "msuka magharibi",
                  "msuka magharibi",
                  "mtambwe kaskazini",
                  "mtambwe kaskazini",
                  "mtambwe kusini",
                  "mtambwe kusini",
                  "piki",
                  "piki",
                  "shumba mjini",
                  "shumba mjini",
                  "shungi",
                  "shungi",
                  "tondooni",
                  "tondooni",
                  "tumbe magharibi",
                  "tumbe magharibi",
                  "ukunjwi",
                  "ukunjwi",
                  "ziwani",
                  "ziwani")

cl$shehia = NA                  
for(i in 1:nrow(cl)){
  cl$shehia[i] = shehia_codes[which(cl$game_id[i] == shehia_games)]
}
  
                  
                  
#########################################
######## NAME MATCHING ##################
method = c("osa", "lv", "dl", "hamming", "lcs", "qgram", "cosine", "jaccard", "jw",
           "soundex")

getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}


game_names <- unique(cl$entry[cl$attribute == "player"])
df=data.frame(name=rep(NA, length(game_names)),
           pname = rep(NA, length(game_names)),
           shehia = rep(NA, length(game_names)),
           player_id = rep(NA, length(game_names)),
           game_id = rep(NA, length(game_names)))

library(stringdist)
for(i in 1:length(game_names)){
  name = tolower(game_names[i])
  player_number = cl$player_num[which(game_names[i] == cl$entry)][1]
  shehia  = cl$shehia[which(game_names[i] == cl$entry)][1]
  game    = cl$game_id[which(game_names[i] == cl$entry)][1]
  hhh_names <-demographics$hhh_name[demographics$ward == shehia]
  pres_names <- tolower(demographics$pres_name[demographics$ward == shehia])
  
  best = c()    
  for(k in method){
    out=stringdist(name, pres_names, method = k)
    best = c(best, which.min(out))    
  }
  proposed_name=pres_names[getmode(best)]
  df$name[i] = name
  df$pname[i] = proposed_name
  df$shehia[i] = shehia
  df$game_id[i] = game
  df$player_id[i] = player_number 
}

check <-c(21, 33, 149, 208, 228)

df$pname[21] <- "ali abrahman ufunguo"
df$pname[149] <- "mkubwa adnan abdalla"                  
df$pname[208] <- "bizume khatib omar"                  

hhid = rep(NA, nrow(df))
for(i in 1:nrow(df)){
  ind = which(df$pname[i]== tolower(demographics$pres_name) & df$shehia[i] == demographics$ward)
  hhid[i]=ind
  if(length(ind) >1) print(ind)
}

# for the errors take the younger because one is father the other is son and we always chose the younger
 # or assa!

cl$hhid = NA
for(i in 1:nrow(cl)){
  gid=cl$game_id[i]
  pid=cl$player_num[i]
  ind=which(df$player_id== pid  & df$game_id == gid)
  cl$hhid[i]=hhid[ind]
}

df_temp<- cl[cl$attribute=="player",]
df_temp$harvest = cl[cl$attribute=="value", "entry"]

names(df_temp)[8] <- "player_name"


########################################
######### MAKE THE FINAL DATAFRAME ##### 

cpr_game <- df_temp[,-7]

cpr_game$harvest <- as.numeric(cpr_game$harvest)




