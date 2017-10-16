# install.packages("httr")
# install.packages("rvest")
# install.packages("xml2")
# install.packages("tidyverse")
# install.packages("xlsx")
# install.packages("randomForest")
# install.packages("rJava")

library(tidyverse)
library(rJava)

setwd("~/Work/git/Power_Failure_Prediction/Source")

# 載入颱風停電戶資料
train  <- read.csv("./data/train.csv")
submit <- read.csv("./data/submit.csv")
pole_type <- read.csv("./data/pole_type.csv")

# # 加入電桿資料
# # 資料來源為政府資料開放平台(https://data.gov.tw/dataset/33305)
# poleString <- c("北北區處pole.csv",    "嘉義區處pole.csv",     "澎湖區處pole.csv",
#                 "北南區處pole.csv",    "基隆區處pole.csv",     "花蓮區處pole.csv",
#                 "北市區處pole.csv",    "宜蘭區處pole.csv",     "苗栗區處pole.csv",
#                 "北西區處pole.csv",    "屏東區處pole.csv",     "金門區處pole.csv",
#                 "南投區處pole.csv",    "彰化區處pole.csv",     "雲林區處pole.csv",
#                 "台中區處pole.csv",    "新營區處pole.csv",     "馬祖區處pole.csv",
#                 "台南區處pole.csv",    "新竹區處pole.csv",     "高雄區處pole.csv",
#                 "台東區處pole.csv",    "桃園區處pole.csv",     "鳳山區處pole.csv")
# pole_wd <- c()
# for(i in 1:length(poleString)) {
#     pole_wd[i] <- paste0("./data/poledata/", poleString[i])
# }
# pole <- list()
# for(i in 1:length(pole_wd)){
#   pole[[i]] <- read.csv(pole_wd[i],
#                         header = T, 
#                         stringsAsFactors = F,
#                         sep = "\t"
#   )
#   pole[[i]] <- pole[[i]][1:5]
# }
# pole <- Reduce(x = pole, f = rbind)
# #清理電桿資料
# pole$縣市 <- as.factor(pole$縣市)
# pole$行政區 <- as.factor(pole$行政區)
# pole$村里 <- as.factor(pole$村里)
# levels(pole$縣市)[30] <- c("台南市")
# levels(pole$縣市)[28] <- c("台中市")
# levels(pole$縣市)[29] <- c("台北市")
# levels(pole$行政區)[332] <- c("頭份市")
# pole$縣市 <- as.character(pole$縣市)
# pole$縣市行政區 <- paste0(pole$縣市, pole$行政區)
# pole$縣市行政區 <- pole$縣市行政區 %>% as.factor()
# 
# pole$key <- paste0(pole$縣市, pole$行政區, pole$村里)
# pole$key <- pole$key %>% as.factor()
# pole$型式 <- pole$型式 %>% as.factor()
# 
# pole$key <- gsub(x=pole$key, pattern="南投縣名間鄉部下村", replacement="南投縣名間鄉廍下村")
# pole$key <- gsub(x=pole$key, pattern="南投縣竹山鎮回瑤里", replacement="南投縣竹山鎮硘磘里")
# pole$key <- gsub(x=pole$key, pattern="台中市北屯區部子里", replacement="台中市北屯區廍子里")
# pole$key <- gsub(x=pole$key, pattern="台中市外埔區部子里", replacement="台中市外埔區廍子里")
# pole$key <- gsub(x=pole$key, pattern="台中市大安區龜殼里", replacement="台中市大安區龜壳村")
# pole$key <- gsub(x=pole$key, pattern="台中市大肚區蔗部里", replacement="台中市大肚區蔗廍里")
# pole$key <- gsub(x=pole$key, pattern="台中市清水區慷榔里", replacement="台中市清水區槺榔里")
# pole$key <- gsub(x=pole$key, pattern="台中市西區公館里", replacement="台中市西區公舘里")
# pole$key <- gsub(x=pole$key, pattern="台北市萬華區糖部里", replacement="台北市萬華區糖廍里")
# pole$key <- gsub(x=pole$key, pattern="台南市七股區慷榔里", replacement="台南市七股區槺榔里")
# pole$key <- gsub(x=pole$key, pattern="台南市七股區鹽埕里", replacement="台南市七股區塩埕里")
# pole$key <- gsub(x=pole$key, pattern="台南市佳里區頂部里", replacement="台南市佳里區頂廍里")
# pole$key <- gsub(x=pole$key, pattern="台南市安南區鹽田里", replacement="台南市安南區塩田里")
# pole$key <- gsub(x=pole$key, pattern="台南市官田區南部里", replacement="台南市官田區南廍里")
# pole$key <- gsub(x=pole$key, pattern="台南市山上區玉峰里", replacement="台南市山上區玉峯里")
# pole$key <- gsub(x=pole$key, pattern="台南市後壁區後部里", replacement="台南市後壁區後廍里")
# pole$key <- gsub(x=pole$key, pattern="台南市新化區山腳里", replacement="台南市新化區山脚里")
# pole$key <- gsub(x=pole$key, pattern="台南市新化區那拔里", replacement="台南市新化區𦰡拔里")
# pole$key <- gsub(x=pole$key, pattern="台南市新營區舊部里", replacement="台南市新營區舊廍里")
# pole$key <- gsub(x=pole$key, pattern="台南市永康區鹽洲里", replacement="台南市永康區塩洲里")
# pole$key <- gsub(x=pole$key, pattern="台南市永康區鹽行里", replacement="台南市永康區塩行里")
# pole$key <- gsub(x=pole$key, pattern="台南市西港區羨林里", replacement="台南市西港區檨林里")
# pole$key <- gsub(x=pole$key, pattern="台南市麻豆區寮部里", replacement="台南市麻豆區寮廍里")
# pole$key <- gsub(x=pole$key, pattern="台南市龍崎區石曹里", replacement="台南市龍崎區石𥕢里")
# pole$key <- gsub(x=pole$key, pattern="嘉義市西區磚瑤里", replacement="嘉義市西區磚磘里")
# pole$key <- gsub(x=pole$key, pattern="嘉義縣中埔鄉石弄村", replacement="嘉義縣中埔鄉石硦村")
# pole$key <- gsub(x=pole$key, pattern="嘉義縣中埔鄉鹽館村", replacement="嘉義縣中埔鄉塩館村")
# pole$key <- gsub(x=pole$key, pattern="嘉義縣朴子市雙溪里", replacement="嘉義縣朴子市双溪里")
# pole$key <- gsub(x=pole$key, pattern="嘉義縣梅山鄉瑞峰村", replacement="嘉義縣梅山鄉瑞峯村")
# pole$key <- gsub(x=pole$key, pattern="嘉義縣梅山鄉雙溪村", replacement="嘉義縣梅山鄉双溪村")
# pole$key <- gsub(x=pole$key, pattern="嘉義縣民雄鄉雙福村", replacement="嘉義縣民雄鄉双福村")
# pole$key <- gsub(x=pole$key, pattern="嘉義縣竹崎鄉文峰村", replacement="嘉義縣竹崎鄉文峯村")
# pole$key <- gsub(x=pole$key, pattern="宜蘭縣宜蘭市中正里", replacement="宜蘭縣宜蘭市東門里")
# pole$key <- gsub(x=pole$key, pattern="宜蘭縣宜蘭市和睦里", replacement="宜蘭縣宜蘭市神農里")
# pole$key <- gsub(x=pole$key, pattern="宜蘭縣宜蘭市大東里", replacement="宜蘭縣宜蘭市大新里")
# pole$key <- gsub(x=pole$key, pattern="宜蘭縣宜蘭市大道里", replacement="宜蘭縣宜蘭市南門里")
# pole$key <- gsub(x=pole$key, pattern="宜蘭縣宜蘭市慶和里", replacement="宜蘭縣宜蘭市北門里")
# pole$key <- gsub(x=pole$key, pattern="宜蘭縣宜蘭市新興里", replacement="宜蘭縣宜蘭市大新里")
# pole$key <- gsub(x=pole$key, pattern="宜蘭縣宜蘭市昇平里", replacement="宜蘭縣宜蘭市新民里")
# pole$key <- gsub(x=pole$key, pattern="宜蘭縣宜蘭市民生里", replacement="宜蘭縣宜蘭市新民里")
# pole$key <- gsub(x=pole$key, pattern="宜蘭縣宜蘭市鄂王里", replacement="宜蘭縣宜蘭市西門里")
# pole$key <- gsub(x=pole$key, pattern="屏東縣新園鄉瓦瑤村", replacement="屏東縣新園鄉瓦磘村")
# pole$key <- gsub(x=pole$key, pattern="屏東縣東港鎮下部里", replacement="屏東縣東港鎮下廍里")
# pole$key <- gsub(x=pole$key, pattern="屏東縣林邊鄉崎峰村", replacement="屏東縣林邊鄉崎峯村")
# pole$key <- gsub(x=pole$key, pattern="屏東縣滿州鄉響林村", replacement="屏東縣滿州鄉响林村")
# pole$key <- gsub(x=pole$key, pattern="屏東縣瑪家鄉涼山村", replacement="屏東縣瑪家鄉凉山村")
# pole$key <- gsub(x=pole$key, pattern="屏東縣萬丹鄉廈北村", replacement="屏東縣萬丹鄉厦北村")
# pole$key <- gsub(x=pole$key, pattern="屏東縣萬丹鄉廈南村", replacement="屏東縣萬丹鄉厦南村")
# pole$key <- gsub(x=pole$key, pattern="屏東縣里港鄉三部村", replacement="屏東縣里港鄉三廍村")
# pole$key <- gsub(x=pole$key, pattern="屏東縣霧臺鄉霧台村", replacement="屏東縣霧臺鄉霧臺村")
# pole$key <- gsub(x=pole$key, pattern="彰化縣二水鄉上豐村", replacement="彰化縣二水鄉上豊村")
# pole$key <- gsub(x=pole$key, pattern="彰化縣員林市大峰里", replacement="彰化縣員林市大峯里")
# pole$key <- gsub(x=pole$key, pattern="彰化縣埔心鄉南館村", replacement="彰化縣埔心鄉南舘村")
# pole$key <- gsub(x=pole$key, pattern="彰化縣埔心鄉埤腳村", replacement="彰化縣埔心鄉埤脚村")
# pole$key <- gsub(x=pole$key, pattern="彰化縣埔心鄉新館村", replacement="彰化縣埔心鄉新舘村")
# pole$key <- gsub(x=pole$key, pattern="彰化縣埔心鄉舊館村", replacement="彰化縣埔心鄉舊舘村")
# pole$key <- gsub(x=pole$key, pattern="彰化縣埔鹽鄉瓦瑤村", replacement="彰化縣埔鹽鄉瓦磘村")
# pole$key <- gsub(x=pole$key, pattern="彰化縣埔鹽鄉部子村", replacement="彰化縣埔鹽鄉廍子村")
# pole$key <- gsub(x=pole$key, pattern="彰化縣彰化市下部里", replacement="彰化縣彰化市下廍里")
# pole$key <- gsub(x=pole$key, pattern="彰化縣彰化市寶部里", replacement="彰化縣彰化市寶廍里")
# pole$key <- gsub(x=pole$key, pattern="彰化縣彰化市磚瑤里", replacement="彰化縣彰化市磚磘里")
# pole$key <- gsub(x=pole$key, pattern="彰化縣芳苑鄉頂部村", replacement="彰化縣芳苑鄉頂廍村")
# pole$key <- gsub(x=pole$key, pattern="新北市三峽區永館里", replacement="新北市三峽區永舘里")
# pole$key <- gsub(x=pole$key, pattern="新北市中和區灰瑤里", replacement="新北市中和區灰磘里")
# pole$key <- gsub(x=pole$key, pattern="新北市中和區瓦瑤里", replacement="新北市中和區瓦磘里")
# pole$key <- gsub(x=pole$key, pattern="新北市土城區峰廷里", replacement="新北市土城區峯廷里")
# pole$key <- gsub(x=pole$key, pattern="新北市坪林區石曹里", replacement="新北市坪林區石𥕢里")
# pole$key <- gsub(x=pole$key, pattern="新北市新店區五峰里", replacement="新北市新店區五峯里")
# pole$key <- gsub(x=pole$key, pattern="新北市板橋區公館里", replacement="新北市板橋區公舘里")
# pole$key <- gsub(x=pole$key, pattern="新北市樹林區槍寮里", replacement="新北市樹林區獇寮里")
# pole$key <- gsub(x=pole$key, pattern="新北市永和區新部里", replacement="新北市永和區新廍里")
# pole$key <- gsub(x=pole$key, pattern="新北市瑞芳區濂新里", replacement="新北市瑞芳區濓新里")
# pole$key <- gsub(x=pole$key, pattern="新北市瑞芳區濂洞里", replacement="新北市瑞芳區濓洞里")
# pole$key <- gsub(x=pole$key, pattern="新北市瑞芳區爪峰里", replacement="新北市瑞芳區爪峯里")
# pole$key <- gsub(x=pole$key, pattern="新北市萬里區崁腳里", replacement="新北市萬里區崁脚里")
# pole$key <- gsub(x=pole$key, pattern="新竹縣北埔鄉水砌村", replacement="新竹縣北埔鄉水磜村")
# pole$key <- gsub(x=pole$key, pattern="新竹縣竹東鎮上館里", replacement="新竹縣竹東鎮上舘里")
# pole$key <- gsub(x=pole$key, pattern="新竹縣竹東鎮雞林里", replacement="新竹縣竹東鎮鷄林里")
# pole$key <- gsub(x=pole$key, pattern="桃園市大園區果林里", replacement="桃園市大園區菓林里")
# pole$key <- gsub(x=pole$key, pattern="桃園市新屋區慷榔里", replacement="桃園市新屋區槺榔里")
# pole$key <- gsub(x=pole$key, pattern="桃園市蘆竹區大華里", replacement="桃園縣龜山鄉大華村")
# pole$key <- gsub(x=pole$key, pattern="澎湖縣湖西鄉果葉村", replacement="澎湖縣湖西鄉菓葉村")
# pole$key <- gsub(x=pole$key, pattern="澎湖縣馬公市時裡里", replacement="澎湖縣馬公市嵵裡里")
# pole$key <- gsub(x=pole$key, pattern="臺東縣綠島鄉公館村", replacement="臺東縣綠島鄉公舘村")
# pole$key <- gsub(x=pole$key, pattern="臺東縣達仁鄉台板村", replacement="臺東縣達仁鄉台坂村")
# pole$key <- gsub(x=pole$key, pattern="臺東縣達仁鄉土板村", replacement="臺東縣達仁鄉土坂村")
# pole$key <- gsub(x=pole$key, pattern="臺東縣關山鎮里龍里", replacement="臺東縣關山鎮里壠里")
# pole$key <- gsub(x=pole$key, pattern="苗栗縣三義鄉雙湖村", replacement="苗栗縣三義鄉双湖村")
# pole$key <- gsub(x=pole$key, pattern="苗栗縣三義鄉雙潭村", replacement="苗栗縣三義鄉双潭村")
# pole$key <- gsub(x=pole$key, pattern="苗栗縣竹南鎮公館里", replacement="苗栗縣竹南鎮公舘里")
# pole$key <- gsub(x=pole$key, pattern="苗栗縣苑裡鎮上館里", replacement="苗栗縣苑裡鎮上舘里")
# pole$key <- gsub(x=pole$key, pattern="苗栗縣苑裡鎮山腳里", replacement="苗栗縣苑裡鎮山脚里")
# pole$key <- gsub(x=pole$key, pattern="連江縣北竿鄉板里村", replacement="連江縣北竿鄉坂里村")
# pole$key <- gsub(x=pole$key, pattern="雲林縣元長鄉瓦瑤村", replacement="雲林縣元長鄉瓦磘村")
# pole$key <- gsub(x=pole$key, pattern="雲林縣北港鎮公館里", replacement="雲林縣北港鎮公舘里")
# pole$key <- gsub(x=pole$key, pattern="雲林縣口湖鄉台子村", replacement="雲林縣口湖鄉臺子村")
# pole$key <- gsub(x=pole$key, pattern="雲林縣四湖鄉柏子村", replacement="雲林縣四湖鄉萡子村")
# pole$key <- gsub(x=pole$key, pattern="雲林縣四湖鄉柏東村", replacement="雲林縣四湖鄉萡東村")
# pole$key <- gsub(x=pole$key, pattern="雲林縣斗六市崙峰里", replacement="雲林縣斗六市崙峯里")
# pole$key <- gsub(x=pole$key, pattern="雲林縣水林鄉舊埔村", replacement="雲林縣水林鄉𣐤埔村")
# pole$key <- gsub(x=pole$key, pattern="雲林縣臺西鄉台西村", replacement="雲林縣臺西鄉臺西村")
# pole$key <- gsub(x=pole$key, pattern="雲林縣西螺鎮公館里", replacement="雲林縣西螺鎮公舘里")
# pole$key <- gsub(x=pole$key, pattern="雲林縣麥寮鄉瓦瑤村", replacement="雲林縣麥寮鄉瓦磘村")
# pole$key <- gsub(x=pole$key, pattern="高雄市左營區復興里", replacement="高雄市左營區復興里")
# pole$key <- gsub(x=pole$key, pattern="高雄市左營區部北里", replacement="高雄市左營區廍北里")
# pole$key <- gsub(x=pole$key, pattern="高雄市左營區部南里", replacement="高雄市左營區廍南里")
# pole$key <- gsub(x=pole$key, pattern="高雄市湖內區公館里", replacement="高雄市湖內區公舘里")
# pole$key <- gsub(x=pole$key, pattern="高雄市阿蓮區峰山里", replacement="高雄市阿蓮區峯山里")
# pole$key <- gsub(x=pole$key, pattern="高雄市鳥松區帝埔里", replacement="高雄市鳥松區坔埔里")
# pole$key <- gsub(x=pole$key, pattern="高雄市鳳山區海風里", replacement="高雄市鳳山區海光里")
# pole$key <- gsub(x=pole$key, pattern="高雄市鳳山區誠正里", replacement="高雄市鳳山區生明里")
# 
# # dropSet <- filter(pole, 縣市行政區 == "分#6"|縣市行政區 == "低2"|
# #                     縣市行政區 == "低1"|縣市行政區 == "9)"|
# #                     縣市行政區 == "5"|縣市行政區 == "2左低1 "|
# #                     縣市行政區 == "2左低1"|縣市行政區 == "1右低1"|
# #                     縣市行政區 == "26"|縣市行政區 == "2)"|
# #                     縣市行政區 == "2"|縣市行政區 == "1右低1 "|
# #                     縣市行政區 == "11右2"|縣市行政區 == "11"|
# #                     縣市行政區 == "1"|縣市行政區 == ")"|
# #                     縣市行政區 == " ")
# # pole <- setdiff(pole, dropSet)
# # 計算每個縣市鄉鎮區各有哪些種類、各幾支的電桿
# # 這邊我只有做到「鄉鎮區」，建議可以再進一步細做「村里」的部分
# # pole_type <- group_by(pole, 縣市行政區, 型式) %>%
# 
# pole_type <- group_by(pole, key, 型式) %>% 
#              summarise(n = n()) %>% 
#              ungroup() 
# 
# dropSet <- filter(pole_type, (!grepl('縣', key)) & (!grepl('市', key)))
# pole_type <- setdiff(pole_type, dropSet)
# 
# pole_type <- pole_type[-1,]
# # pole_type <- spread(pole_type, key = 縣市行政區, value = n, fill = 0)
# pole_type <- spread(pole_type, key=key, value=n, fill=0)
# pole_type <- t(pole_type[,-1]) %>% as.data.frame()
# names(pole_type) <- c("型式", "pole1", "pole2", "pole3", "pole4", "pole5", "pole6", "pole7", "pole8", "pole9", "pole10")
# # 後面讀取中文欄位有錯，先將電桿種類的欄位都改用英文
# # 原資料為："3T桿", "H桿", "木併桿", "木桿", "水泥併桿",
# # "水泥桿", "用戶自備桿", "鋼併桿", "鋼桿", "電塔"
# pole_type$key <- rownames(pole_type)
# # pole_type$縣市行政區 <- rownames(pole_type)
# pole_type <- pole_type[, -1]
# 
# # write.csv(pole_type, file = "pole_type.csv", row.names = FALSE, fileEncoding="UTF-8")

writain$縣市行政區 <- paste0(train$CityName, train$TownName, train$VilName)
# train <- left_join(train, pole_type, by = "縣市行政區")

train$key  <- paste0(train$CityName, train$TownName, train$VilName) 
train_miss <- right_join(train, pole_type, by="key")
train_miss <- train_miss[is.na(train_miss$CityName),]

train2 <- left_join(train, pole_type, by="key")

colnames(train2)
pole_coles <- c("pole1", "pole2", "pole3", "pole4", "pole5", "pole6", "pole7", "pole8", "pole9", "pole10")
# train2[,pole_coles][is.na(train2[,pole_coles]) == TRUE] <- 0
train2[,pole_coles][is.na(train2[,pole_coles])] <- 0

# for(i in 14:23){
#  train[,i][is.na(train[,i]) == TRUE] <- 0
# }

# 加入人口戶數資料
# 資料來源為政府資料開放平臺(https://data.gov.tw/dataset/32973#r0)
family <- read.csv("./data/opendata10603M030.csv")
family <- family[-1, c(2, 3, 4)]
family$site_id <- gsub(x = family$site_id, pattern = "臺", replacement = "台")
family$site_id <- gsub(x = family$site_id, pattern = "台東", replacement = "臺東")
family$site_id <- gsub(x = family$site_id, pattern = "　", replacement = "")

family$key <- paste0(family$site_id, family$village)
# family$key <- family$key %>% as.factor()

# names(family)[1] <- "縣市行政區"
# family <- group_by(family, 縣市行政區) %>% 
#           summarise(household = mean(household_no)) 
# train <- left_join(train, family, by = "縣市行政區")
# train$household[is.na(train$household) == TRUE] <- rep(134958, 183) #高雄市三民區有134958戶
# submit <- left_join(submit, train[, c(3, 14:24)], by = "VilCode")

family$household_no <- as.character(family$household_no) %>% as.numeric()
family <- group_by(family, key) %>%
          summarise(household = mean(household_no))
train3 <- left_join(train2, family, by="key")
train3[is.na(train3$household) == TRUE,]

# TODO: some household is missing
# train_new$household[is.na(train_new$household) == TRUE] <- rep(134958, 183) #高雄市三民區有134958戶
train3$household[is.na(train3$household) == TRUE] <- 0
submit_new <- left_join(submit, train3[, c(3, 14:24)], by = "VilCode")

# 將會用到的颱風資料先選出來
soudelor <- select(train3, c(1:4, 13:24, 8))
meranti <- select(train3, c(1:4, 13:24, 12))
megi <- select(submit_new, -c(5:6))
nesatAndHaitang <- select(submit_new, -c(5:6))

# 加入特各颱風風力資料
# 資料來源為颱風資料庫(http://rdc28.cwb.gov.tw/)
library(xlsx)
gust <- xlsx::read.xlsx("./data/gust.xlsx", 1)
names(gust)[1] <- "CityName"
gust$CityName <- as.factor(gust$CityName)
soudelor <- left_join(soudelor, gust[,c(1:3)], by = "CityName")
megi <- left_join(megi, gust[,c(1, 6:7)], by = "CityName")
meranti <- left_join(meranti, gust[,c(1, 12:13)], by = "CityName")
nesatAndHaitang <- left_join(nesatAndHaitang, gust[,c(1, 14:15)], by = "CityName")

# 建立隨機森林模型
library(randomForest)
names(soudelor)[18:19] <- c("maxWind", "gust")
names(megi)[16:17] <- c("maxWind", "gust")
soudelor_rf <- randomForest(Soudelor~., data = soudelor[, -c(1:5)])
soudelor_pred <- predict(soudelor_rf, newdata = megi[5:17])
megi_pred <- 1.48*soudelor_pred
# megi_pred <- 1.45*soudelor_pred
# megi_pred <- soudelor_pred

names(meranti)[18:19] <- c("maxWind", "gust")
names(nesatAndHaitang)[16:17] <- c("maxWind", "gust")
meranti_rf <- randomForest(MerantiAndMalakas~., data = meranti[, -c(1:5)])
meranti_pred <- predict(meranti_rf, newdata = nesatAndHaitang[5:17])
nesatAndHaitang_pred <- 1.45*meranti_pred
# nesatAndHaitang_pred <- 1.53*meranti_pred
# nesatAndHaitang_pred <- meranti_pred

submit_dc <- cbind(submit[1:4], nesatAndHaitang_pred) %>% 
             cbind(megi_pred)
names(submit_dc)[5:6] <- c("NesatAndHaitang", "Megi")
write.csv(submit_dc, file = "submit_dc.csv", row.names = FALSE, fileEncoding="UTF-8")

