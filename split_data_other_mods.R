####loading packages
library(tidyverse)
library(caret)
library(data.table)
library(R.utils)


####reading in overall data csv file from directory where it's located
csgo_processed = fread("D:/game_state_data.csv")


####variables used
predictors = c('seconds', 'is_bomb_planted', 'bomb_site', 'CT1_health', 'CT2_health', 'CT3_health',
               'CT4_health', 'CT5_health', 'T1_health', 'T2_health', 'T3_health', 'T4_health', 'T5_health', 'map',
               'round_type', 'ct_eq_val', 't_eq_val', 'T1_dead', 'T2_dead', 'T3_dead', 'T4_dead', 'T5_dead',
               'CT1_dead', 'CT2_dead', 'CT3_dead', 'CT4_dead', 'CT5_dead', 'T_dead', 'CT_dead')
outcome = 'T_win'


####select relevant variables and create factors
csgo_processed = csgo_processed %>%
  select(outcome, predictors) %>%  #choosing the outcome variable and features selected
  mutate_if(is.character, function(x) {as.factor(x)}) #converts char variables into factors 


####create training and testing data
set.seed(0)

#use function from 
tr.set = createDataPartition(y=csgo_processed$T_win, p = .75, list = F)


#training data
csgo.train = csgo_processed[tr.set,]

#test data
csgo.test = csgo_processed[-tr.set,]

#check if reasonably balance
table(csgo.train$T_win); table(csgo.test$T_win)


#file limit still exceeds 100 MB, split train data into two dfs

#take ceiling of length / 2
spl.n = ceiling(nrow(csgo.train)/2)

#train 1
csgo.train1 = csgo.train[1:spl.n,]

#train 2
csgo.train2 = csgo.train[-(1:spl.n),]


####saving compressed files for each

#training data 1
fwrite(csgo.train1, "D:/csgo_train1.gz")

#training data 2
fwrite(csgo.train2, "D:/csgo_train2.gz")

#test data
fwrite(csgo.test, "D:/csgo_test.gz")
