# install.packages("httr")
# install.packages("rvest")
# install.packages("xml2")
# install.packages("tidyverse")
# install.packages("xlsx")
# install.packages("randomForest")
# install.packages("rJava")

setwd("~/Work/git/Power_Failure_Prediction/Source")
# setwd("~/Repo/Frank/Power_Failure_Prediction/Source")

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

fp_max <- apply(train[, col_tp], 1, max)

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
names(soudelor)[18:19]        <- c("maxWind", "gust")
names(megi)[16:17]            <- c("maxWind", "gust")
names(meranti)[18:19]         <- c("maxWind", "gust")
names(nesatAndHaitang)[16:17] <- c("maxWind", "gust")

soudelor_rf <- randomForest(Soudelor~.,          data=soudelor[, -c(1:5)])
meranti_rf  <- randomForest(MerantiAndMalakas~., data=meranti[, -c(1:5)])

# =================================================================================================

soudelor_pred        <- gen_predict(model=soudelor_rf, raw=soudelor[col_feature],        row_zero=row_zero, row_max=fp_max)
meranti_pred         <- gen_predict(model=meranti_rf,  raw=meranti[col_feature],         row_zero=row_zero, row_max=fp_max)
megi_pred            <- gen_predict(model=soudelor_rf, raw=megi[col_feature],            row_zero=row_zero, row_max=fp_max, magic_value=1.45)
nesatAndHaitang_pred <- gen_predict(model=meranti_rf,  raw=nesatAndHaitang[col_feature], row_zero=row_zero, row_max=fp_max, magic_value=1.53)

# =================================================================================================

soudelor_pred <- gen_predict(model=soudelor_rf, raw=soudelor[col_feature], row_zero=row_zero, row_max=fp_max)
meranti_pred  <- gen_predict(model=meranti_rf,  raw=meranti[col_feature],  row_zero=row_zero, row_max=fp_max)
tn_real <- cbind(soudelor$Soudelor, meranti$MerantiAndMalakas)
tn_pred <- cbind(soudelor_pred, meranti_pred)
Scoring(tn_pred, tn_real)

soudelor_pred <- gen_predict(model=soudelor_rf, raw=soudelor[col_feature], row_zero=row_zero, row_max=fp_max, magic_value=1.45)
meranti_pred  <- gen_predict(model=meranti_rf,  raw=meranti[col_feature],  row_zero=row_zero, row_max=fp_max, magic_value=1.53)
tn_real <- cbind(soudelor$Soudelor, meranti$MerantiAndMalakas)
tn_pred <- cbind(soudelor_pred, meranti_pred)
Scoring(tn_pred, tn_real)

# =================================================================================================

megi_pred            <- gen_predict(model=soudelor_rf, raw=megi[col_feature],            row_zero=row_zero, row_max=fp_max, magic_value=1.45)
nesatAndHaitang_pred <- gen_predict(model=meranti_rf,  raw=nesatAndHaitang[col_feature], row_zero=row_zero, row_max=fp_max, magic_value=1.53)

f_submit <- paste(c(pd_path, "submit_dc_", format(Sys.time(), "%m%d_%H%M%S"), ".csv"), collapse='')
submit_dc <- cbind(submit[1:4], nesatAndHaitang_pred) %>% cbind(megi_pred)
names(submit_dc)[5:6] <- c("NesatAndHaitang", "Megi")
write.csv(submit_dc, file=f_submit, row.names=FALSE, fileEncoding="UTF-8")
