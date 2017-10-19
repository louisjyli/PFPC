# install.packages("httr")
# install.packages("rvest")
# install.packages("xml2")
# install.packages("tidyverse")
# install.packages("xlsx")
# install.packages("randomForest")
# install.packages("rJava")

# setwd("~/Work/git/Power_Failure_Prediction/Source")
setwd("~/Repo/Frank/Power_Failure_Prediction/Source")

library(tidyverse)
library(rJava)
source("./R/util.R")

# =================================================================================================

pd_path <- paste(c(getwd(), "/prediction/"), collapse='')
if ( !dir.exists(pd_path) ) { 
    dir.create(pd_path) 
} 

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

# =================================================================================================
# Define column and row index

col_tp      <- c("Hagibis", "Chan.hom", "Dujuan", "Soudelor", "Fung.wong", "Matmo", "Nepartak", "MerantiAndMalakas")
col_feature <- c("pole1", "pole2", "pole3", "pole4", "pole5", "pole6", "pole7", "pole8", "pole9", "pole10", "household", "maxWind", "gust")

tmp_sum <- rowSums(train[, col_tp])
row_zero <- which(tmp_sum == 0)
row_none_zero <- which(tmp_sum > 0)

sprintf("total rows: %d, zero: %d, non-zero: %d", NROW(tmp_sum), NROW(row_zero), NROW(row_none_zero))

# =================================================================================================

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
soudelor_pred <- predict(soudelor_rf, newdata=soudelor[col_feature])

names(meranti)[18:19]         <- c("maxWind", "gust")
names(nesatAndHaitang)[16:17] <- c("maxWind", "gust")
meranti_rf <- randomForest(MerantiAndMalakas~., data=meranti[, -c(1:5)])
meranti_pred <- predict(meranti_rf, newdata=meranti[col_feature])

# =================================================================================================

magic_1 = mean(soudelor[soudelor$Soudelor != 0,17] / soudelor_pred[soudelor$Soudelor != 0])
magic_2 = mean(meranti[meranti$MerantiAndMalakas != 0, 17] / meranti_pred[meranti$MerantiAndMalakas != 0]) / 12.5

rows_1 = NROW(soudelor[soudelor$Soudelor != 0,17])
rows_2 = NROW(meranti[meranti$MerantiAndMalakas != 0, 17])

sprintf("magic 1: %2.2f (%d), magic 2: %2.2f (%d)", magic_1, rows_1, magic_2, rows_2)

# =================================================================================================

# TODO: Set zero (All historical items)

megi_pred <- magic_1*soudelor_pred
nesatAndHaitang_pred <- magic_2*meranti_pred

megi_pred[soudelor$Soudelor == 0] <- 0
nesatAndHaitang_pred[meranti$MerantiAndMalakas == 0] <- 0

# =================================================================================================

pred <- cbind(soudelor_pred, meranti_pred)
real <- cbind(soudelor$Soudelor, meranti$MerantiAndMalakas)
Scoring(pred, real)

pred <- cbind(soudelor_pred*magic_1, meranti_pred*magic_2)
Scoring(pred, real)

# =================================================================================================

pred_1 = soudelor_pred
pred_2 = meranti_pred

pred <- cbind(pred_1, pred_2)
real <- cbind(soudelor$Soudelor, meranti$MerantiAndMalakas)
Scoring(pred, real)

pred_1[row_zero] <- 0
pred_2[row_zero] <- 0

pred <- cbind(pred_1, pred_2)
real <- cbind(soudelor$Soudelor, meranti$MerantiAndMalakas)
Scoring(pred, real)

# =================================================================================================

megi_pred            <- predict(soudelor_rf, newdata=megi[col_feature]) * 1.45
nesatAndHaitang_pred <- predict(meranti_rf,  newdata=nesatAndHaitang[col_feature]) * 1.53

megi_pred[row_zero] <- 0
nesatAndHaitang_pred[row_zero] <- 0

f_submit <- paste(c(pd_path, "submit_dc_", format(Sys.time(), "%m%d_%H%M%S"), ".csv"), collapse='')
submit_dc <- cbind(submit[1:4], nesatAndHaitang_pred) %>% cbind(megi_pred)
names(submit_dc)[5:6] <- c("NesatAndHaitang", "Megi")
write.csv(submit_dc, file=f_submit, row.names=FALSE, fileEncoding="UTF-8")
