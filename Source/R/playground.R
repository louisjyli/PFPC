# install.packages("httr")
# install.packages("rvest")
# install.packages("xml2")
# install.packages("tidyverse")
# install.packages("xlsx")
# install.packages("randomForest")
# install.packages("rJava")

library(tidyverse)
library(rJava)
source("./R/util.R")

setwd("~/Work/git/Power_Failure_Prediction/Source")

# =================================================================================================

# gen_pole_info()
# gen_family_info()
# gen_gust_info()

# =================================================================================================

# 載入颱風停電戶資料
train  <- read.csv("./data/train.csv",  fileEncoding="UTF-8")
submit <- read.csv("./data/submit.csv", fileEncoding="UTF-8")
pole   <- read.csv("./data/pole.csv",   fileEncoding="UTF-8", stringsAsFactors=F)
family <- read.csv("./data/family.csv", fileEncoding="UTF-8", stringsAsFactors=F)
gust   <- read.csv("./data/gust.csv",   fileEncoding="UTF-8")

train$key  <- paste0(train$CityName, train$TownName, train$VilName) 

merged <- left_join(train, pole, by="key")
merged <- left_join(merged, family, by="key")

# TODO: Correct family info
# Set the missing value to 0
merged[is.na(merged)] <- 0

# =================================================================================================

submit_new <- left_join(submit, merged[, c(3, 14:24)], by="VilCode")

# 將會用到的颱風資料先選出來
soudelor        <- select(merged, c(1:4, 13:24, 8))
meranti         <- select(merged, c(1:4, 13:24, 12))
megi            <- select(submit_new, -c(5:6))
nesatAndHaitang <- select(submit_new, -c(5:6))

# Merge gust info
soudelor        <- left_join(soudelor,        gust[,c(1:3)],      by="CityName")
megi            <- left_join(megi,            gust[,c(1, 6:7)],   by="CityName")
meranti         <- left_join(meranti,         gust[,c(1, 12:13)], by="CityName")
nesatAndHaitang <- left_join(nesatAndHaitang, gust[,c(1, 14:15)], by="CityName")

# =================================================================================================

# 建立隨機森林模型
library(randomForest)
names(soudelor)[18:19] <- c("maxWind", "gust")
names(megi)[16:17]     <- c("maxWind", "gust")
soudelor_rf <- randomForest(Soudelor~., data=soudelor[, -c(1:5)])
soudelor_pred <- predict(soudelor_rf, newdata=megi[5:17])
megi_pred <- 1.48*soudelor_pred
# megi_pred <- 1.45*soudelor_pred
# megi_pred <- soudelor_pred

names(meranti)[18:19]         <- c("maxWind", "gust")
names(nesatAndHaitang)[16:17] <- c("maxWind", "gust")
meranti_rf <- randomForest(MerantiAndMalakas~., data=meranti[, -c(1:5)])
meranti_pred <- predict(meranti_rf, newdata=nesatAndHaitang[5:17])
nesatAndHaitang_pred <- 1.45*meranti_pred
# nesatAndHaitang_pred <- 1.53*meranti_pred
# nesatAndHaitang_pred <- meranti_pred

# =================================================================================================

pred <- cbind(soudelor_pred, meranti_pred)
real <- cbind(soudelor$Soudelor, meranti$MerantiAndMalakas)
Scoring(pred, real)

# =================================================================================================

submit_dc <- cbind(submit[1:4], nesatAndHaitang_pred) %>% 
             cbind(megi_pred)
names(submit_dc)[5:6] <- c("NesatAndHaitang", "Megi")
write.csv(submit_dc, file="submit_dc.csv", row.names=FALSE, fileEncoding="UTF-8")
