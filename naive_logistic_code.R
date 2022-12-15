##loading packages
library(tidyverse)
library(caret)
library(data.table)
library(R.utils)


#####
####loading data

##loading training data
#first half of training data
train1 = fread("C:/Users/Jackson DeBord/Documents/Fall_22/Data_Mining/BZAN542project/csgo_train1.gz")

#second half of training data
train2 = fread("C:/Users/Jackson DeBord/Documents/Fall_22/Data_Mining/BZAN542project/csgo_train2.gz")


#combining into overall training set
train = rbind(train1, train2)

#cleaning up
rm(list = c("train1", "train2"))

##loading test data
test = fread("C:/Users/Jackson DeBord/Documents/Fall_22/Data_Mining/BZAN542project/csgo_test.gz")

#####
## change characters to factors
train = train %>%
  mutate_if(is.character, function(x) {as.factor(x)})

test = test %>%
  mutate_if(is.character, function(x) {as.factor(x)})

##relevel bomb location variable
train$bomb_site = relevel(train$bomb_site, "")

test$bomb_site = relevel(test$bomb_site,"")

##change outcome to factor
train$T_win = relevel(as.factor(train$T_win), "0")

test$T_win = relevel(as.factor(test$T_win), "0")

#####
####fitting models



###naive model
mean(ifelse(train$T_win == "0", 0, 1))

y.naive = rep(1,length(test$T_win))

#confusion matrix
table(test$T_win, y.naive)

#accuracy
sum(test$T_win == y.naive) / length(test$T_win)




####logistic regression
mod = train(T_win ~ ., data = train, method = "glm", family = "binomial",
      trControl = trainControl(method = 'cv', number = 10))

#
y.pred = predict(mod, newdata = test[,-1])

#confusion matrix
table(test$T_win, y.pred)

#accuracy
sum(test$T_win == y.pred) / length(test$T_win)

