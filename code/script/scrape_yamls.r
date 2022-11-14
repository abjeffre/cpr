
library(yamltools) # devtools::install_github("babeheim/yamltools", ref="experimental")
library(tidyr)

setwd("Y:/eco_andrews/Wave2/CommonPoolResourceResults/")
dat <- scrape_yamls("./interviews", top_name = "games")
setwd("C:/Users/jeffrey_andrews/Documents")


games <- dat$games
rounds <- dat$rounds
players <- dat$player_names

rounds$game_id <- games$game_id[rounds$parent_table_index]
rounds$player1 <- players$name1[match(rounds$parent_table_index, players$parent_table_index)]
rounds$dbpid1 <- players$dbpid1[match(rounds$parent_table_index, players$parent_table_index)]
rounds$player2 <- players$name2[match(rounds$parent_table_index, players$parent_table_index)]
rounds$dbpid2 <- players$dbpid2[match(rounds$parent_table_index, players$parent_table_index)]
rounds$player3 <- players$name3[match(rounds$parent_table_index, players$parent_table_index)]
rounds$dbpid3 <- players$dbpid3[match(rounds$parent_table_index, players$parent_table_index)]
rounds$player4 <- players$name4[match(rounds$parent_table_index, players$parent_table_index)]
rounds$dbpid4 <- players$dbpid4[match(rounds$parent_table_index, players$parent_table_index)]
rounds$player5 <- players$name5[match(rounds$parent_table_index, players$parent_table_index)]
rounds$dbpid5 <- players$dbpid5[match(rounds$parent_table_index, players$parent_table_index)]

rounds %>%
  tidyr::pivot_longer(
    cols = c(
      starts_with("player"),
      starts_with("dbpid"),
      starts_with("value")
    ),
    names_to = "attribute",
    values_to = "entry"
  ) %>% as.data.frame() -> choices_long

choices_long$player_num <- gsub("[[:alpha:]]", "", choices_long$attribute)
choices_long$attribute <- gsub("[[:digit:]]", "", choices_long$attribute)

choices_long %>%
  tidyr::pivot_wider(
    names_from = attribute,
    values_from = entry
  ) %>% as.data.frame() -> choices

# two tables: games, and choices

saveRDS(choices_long, "REDD+/data/dataframes/choices_long.rds")

