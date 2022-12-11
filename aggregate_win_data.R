###importing data
#loading tidyverse for aggregation later
library(tidyverse)

#Note: damage from friendly fire is included in the damage calculation


#create dummy if attacker's team won
raw_csgo$win = ifelse(raw_csgo$winner_team == raw_csgo$att_team, 1, 0)

#remove instances of damage from the map
#create unique match round team identifier for each observation
raw_csgo = raw_csgo %>%
  filter(att_team != "World" & !((att_team == vic_team) & (att_side != vic_side))) %>%
  mutate(match_round_team = str_c(file, round, att_team, sep = "_"))



csgo.win = raw_csgo %>%
  #group by match round team identifier
  group_by(match_round_team) %>%
  #summarise if team wins
  summarize(win = unique(win)[1],
            #create match id feature
            match = unique(file)[1],
            #create round id feature
            round_no = unique(round)[1],
            #create number of hits feature
            inst_dam = n(),
            #create total damage feature
            tot_damage = sum(hp_dmg),
            #create map feature
            map = unique(map)[1],
            #create side feature
            side = unique(att_side)[1],
            #create date feature
            date = unique(date)[1],
            #create number of unique weapons feature
            num_wp = length(unique(wp))[1],
            #create round type feature
            round_type = unique(round_type)[1],
            #create average match rank feature
            avg_match_rank = unique(avg_match_rank)[1])


#write aggregated data to csv, use desired file location
write.csv(csgo.win,"C:/Users/Jackson DeBord/Documents/Fall_22/Data_Mining/csgo_aggregated_data.csv",
          row.names = FALSE)
            
            
            


