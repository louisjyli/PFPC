
gen_pole_info <- function() {

    # =============================================================================================

    # 加入電桿資料
    # 資料來源為政府資料開放平台(https://data.gov.tw/dataset/33305)
    poleString <- c("北北區處pole.csv",    "嘉義區處pole.csv",     "澎湖區處pole.csv",
                    "北南區處pole.csv",    "基隆區處pole.csv",     "花蓮區處pole.csv",
                    "北市區處pole.csv",    "宜蘭區處pole.csv",     "苗栗區處pole.csv",
                    "北西區處pole.csv",    "屏東區處pole.csv",     "金門區處pole.csv",
                    "南投區處pole.csv",    "彰化區處pole.csv",     "雲林區處pole.csv",
                    "台中區處pole.csv",    "新營區處pole.csv",     "馬祖區處pole.csv",
                    "台南區處pole.csv",    "新竹區處pole.csv",     "高雄區處pole.csv",
                    "台東區處pole.csv",    "桃園區處pole.csv",     "鳳山區處pole.csv")
    
    pole_wd <- c()
    for(i in 1:length(poleString)) {
        pole_wd[i] <- paste0("./data/poledata/", poleString[i])
    }

    pole <- list()

    for(i in 1:length(pole_wd)) {
        pole[[i]] <- read.csv(pole_wd[i], header=T, stringsAsFactors=F, sep="\t")
        pole[[i]] <- pole[[i]][c("縣市", "行政區", "村里", "型式")]
    }
    
    pole <- Reduce(x=pole, f=rbind)

    #清理電桿資料
    pole$縣市   <- as.factor(pole$縣市)
    pole$行政區 <- as.factor(pole$行政區)
    pole$村里   <- as.factor(pole$村里)
    pole$型式   <- as.factor(pole$型式)

    levels(pole$縣市)   <- gsub(x=levels(pole$縣市), pattern="臺", replacement="台")
    levels(pole$縣市)   <- gsub(x=levels(pole$縣市), pattern="台東", replacement="臺東")
    levels(pole$行政區) <- gsub(x=levels(pole$行政區), pattern="頭份鎮", replacement="頭份市")
    
    pole$key <- paste0(pole$縣市, pole$行政區, pole$村里) %>% as.factor()

    # ==== Correct village info ===================================================================
    
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="南投縣名間鄉部下村", replacement="南投縣名間鄉廍下村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="南投縣竹山鎮回瑤里", replacement="南投縣竹山鎮硘磘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台中市北屯區部子里", replacement="台中市北屯區廍子里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台中市外埔區部子里", replacement="台中市外埔區廍子里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台中市大安區龜殼里", replacement="台中市大安區龜壳村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台中市大肚區蔗部里", replacement="台中市大肚區蔗廍里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台中市清水區慷榔里", replacement="台中市清水區槺榔里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台中市西區公館里", replacement="台中市西區公舘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台北市萬華區糖部里", replacement="台北市萬華區糖廍里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市七股區慷榔里", replacement="台南市七股區槺榔里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市七股區鹽埕里", replacement="台南市七股區塩埕里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市佳里區頂部里", replacement="台南市佳里區頂廍里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市安南區鹽田里", replacement="台南市安南區塩田里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市官田區南部里", replacement="台南市官田區南廍里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市山上區玉峰里", replacement="台南市山上區玉峯里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市後壁區後部里", replacement="台南市後壁區後廍里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市新化區山腳里", replacement="台南市新化區山脚里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市新化區那拔里", replacement="台南市新化區𦰡拔里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市新營區舊部里", replacement="台南市新營區舊廍里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市永康區鹽洲里", replacement="台南市永康區塩洲里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市永康區鹽行里", replacement="台南市永康區塩行里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市西港區羨林里", replacement="台南市西港區檨林里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市麻豆區寮部里", replacement="台南市麻豆區寮廍里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="台南市龍崎區石曹里", replacement="台南市龍崎區石𥕢里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="嘉義市西區磚瑤里", replacement="嘉義市西區磚磘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="嘉義縣中埔鄉石弄村", replacement="嘉義縣中埔鄉石硦村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="嘉義縣中埔鄉鹽館村", replacement="嘉義縣中埔鄉塩館村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="嘉義縣朴子市雙溪里", replacement="嘉義縣朴子市双溪里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="嘉義縣梅山鄉瑞峰村", replacement="嘉義縣梅山鄉瑞峯村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="嘉義縣梅山鄉雙溪村", replacement="嘉義縣梅山鄉双溪村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="嘉義縣民雄鄉雙福村", replacement="嘉義縣民雄鄉双福村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="嘉義縣竹崎鄉文峰村", replacement="嘉義縣竹崎鄉文峯村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="宜蘭縣宜蘭市中正里", replacement="宜蘭縣宜蘭市東門里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="宜蘭縣宜蘭市和睦里", replacement="宜蘭縣宜蘭市神農里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="宜蘭縣宜蘭市大東里", replacement="宜蘭縣宜蘭市大新里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="宜蘭縣宜蘭市大道里", replacement="宜蘭縣宜蘭市南門里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="宜蘭縣宜蘭市慶和里", replacement="宜蘭縣宜蘭市北門里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="宜蘭縣宜蘭市新興里", replacement="宜蘭縣宜蘭市大新里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="宜蘭縣宜蘭市昇平里", replacement="宜蘭縣宜蘭市新民里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="宜蘭縣宜蘭市民生里", replacement="宜蘭縣宜蘭市新民里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="宜蘭縣宜蘭市鄂王里", replacement="宜蘭縣宜蘭市西門里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="屏東縣新園鄉瓦瑤村", replacement="屏東縣新園鄉瓦磘村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="屏東縣東港鎮下部里", replacement="屏東縣東港鎮下廍里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="屏東縣林邊鄉崎峰村", replacement="屏東縣林邊鄉崎峯村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="屏東縣滿州鄉響林村", replacement="屏東縣滿州鄉响林村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="屏東縣瑪家鄉涼山村", replacement="屏東縣瑪家鄉凉山村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="屏東縣萬丹鄉廈北村", replacement="屏東縣萬丹鄉厦北村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="屏東縣萬丹鄉廈南村", replacement="屏東縣萬丹鄉厦南村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="屏東縣里港鄉三部村", replacement="屏東縣里港鄉三廍村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="屏東縣霧臺鄉霧台村", replacement="屏東縣霧臺鄉霧臺村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="彰化縣二水鄉上豐村", replacement="彰化縣二水鄉上豊村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="彰化縣員林市大峰里", replacement="彰化縣員林市大峯里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="彰化縣埔心鄉南館村", replacement="彰化縣埔心鄉南舘村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="彰化縣埔心鄉埤腳村", replacement="彰化縣埔心鄉埤脚村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="彰化縣埔心鄉新館村", replacement="彰化縣埔心鄉新舘村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="彰化縣埔心鄉舊館村", replacement="彰化縣埔心鄉舊舘村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="彰化縣埔鹽鄉瓦瑤村", replacement="彰化縣埔鹽鄉瓦磘村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="彰化縣埔鹽鄉部子村", replacement="彰化縣埔鹽鄉廍子村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="彰化縣彰化市下部里", replacement="彰化縣彰化市下廍里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="彰化縣彰化市寶部里", replacement="彰化縣彰化市寶廍里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="彰化縣彰化市磚瑤里", replacement="彰化縣彰化市磚磘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="彰化縣芳苑鄉頂部村", replacement="彰化縣芳苑鄉頂廍村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新北市三峽區永館里", replacement="新北市三峽區永舘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新北市中和區灰瑤里", replacement="新北市中和區灰磘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新北市中和區瓦瑤里", replacement="新北市中和區瓦磘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新北市土城區峰廷里", replacement="新北市土城區峯廷里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新北市坪林區石曹里", replacement="新北市坪林區石𥕢里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新北市新店區五峰里", replacement="新北市新店區五峯里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新北市板橋區公館里", replacement="新北市板橋區公舘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新北市樹林區槍寮里", replacement="新北市樹林區獇寮里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新北市永和區新部里", replacement="新北市永和區新廍里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新北市瑞芳區濂新里", replacement="新北市瑞芳區濓新里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新北市瑞芳區濂洞里", replacement="新北市瑞芳區濓洞里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新北市瑞芳區爪峰里", replacement="新北市瑞芳區爪峯里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新北市萬里區崁腳里", replacement="新北市萬里區崁脚里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新竹縣北埔鄉水砌村", replacement="新竹縣北埔鄉水磜村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新竹縣竹東鎮上館里", replacement="新竹縣竹東鎮上舘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="新竹縣竹東鎮雞林里", replacement="新竹縣竹東鎮鷄林里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="桃園市大園區果林里", replacement="桃園市大園區菓林里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="桃園市新屋區慷榔里", replacement="桃園市新屋區槺榔里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="桃園市蘆竹區大華里", replacement="桃園市龜山區大華里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="澎湖縣湖西鄉果葉村", replacement="澎湖縣湖西鄉菓葉村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="澎湖縣馬公市時裡里", replacement="澎湖縣馬公市嵵裡里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="臺東縣綠島鄉公館村", replacement="臺東縣綠島鄉公舘村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="臺東縣達仁鄉台板村", replacement="臺東縣達仁鄉台坂村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="臺東縣達仁鄉土板村", replacement="臺東縣達仁鄉土坂村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="臺東縣關山鎮里龍里", replacement="臺東縣關山鎮里壠里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="苗栗縣三義鄉雙湖村", replacement="苗栗縣三義鄉双湖村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="苗栗縣三義鄉雙潭村", replacement="苗栗縣三義鄉双潭村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="苗栗縣竹南鎮公館里", replacement="苗栗縣竹南鎮公舘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="苗栗縣苑裡鎮上館里", replacement="苗栗縣苑裡鎮上舘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="苗栗縣苑裡鎮山腳里", replacement="苗栗縣苑裡鎮山脚里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="連江縣北竿鄉板里村", replacement="連江縣北竿鄉坂里村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="雲林縣元長鄉瓦瑤村", replacement="雲林縣元長鄉瓦磘村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="雲林縣北港鎮公館里", replacement="雲林縣北港鎮公舘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="雲林縣口湖鄉台子村", replacement="雲林縣口湖鄉臺子村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="雲林縣四湖鄉柏子村", replacement="雲林縣四湖鄉萡子村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="雲林縣四湖鄉柏東村", replacement="雲林縣四湖鄉萡東村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="雲林縣斗六市崙峰里", replacement="雲林縣斗六市崙峯里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="雲林縣水林鄉舊埔村", replacement="雲林縣水林鄉𣐤埔村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="雲林縣臺西鄉台西村", replacement="雲林縣臺西鄉臺西村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="雲林縣西螺鎮公館里", replacement="雲林縣西螺鎮公舘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="雲林縣麥寮鄉瓦瑤村", replacement="雲林縣麥寮鄉瓦磘村")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="高雄市左營區復興里", replacement="高雄市左營區永清里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="高雄市左營區部北里", replacement="高雄市左營區廍北里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="高雄市左營區部南里", replacement="高雄市左營區廍南里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="高雄市湖內區公館里", replacement="高雄市湖內區公舘里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="高雄市阿蓮區峰山里", replacement="高雄市阿蓮區峯山里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="高雄市鳥松區帝埔里", replacement="高雄市鳥松區坔埔里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="高雄市鳳山區海風里", replacement="高雄市鳳山區海光里")
    levels(pole$key) <- gsub(x=levels(pole$key), pattern="高雄市鳳山區誠正里", replacement="高雄市鳳山區生明里")

    # =============================================================================================
        
    pole_type <- group_by(pole, key, 型式) %>%
        summarise(n=n()) %>%
        ungroup()

    pole_type <- pole_type[apply(pole_type, 1, function(x) grepl("縣", x) || grepl("市", x)),]
    pole_type <- spread(pole_type, key=key, value=n, fill=0)
    pole_type <- t(pole_type[,-1]) %>% as.data.frame()
    
    names(pole_type) <- c("型式", "pole1", "pole2", "pole3", "pole4", "pole5", "pole6", "pole7", "pole8", "pole9", "pole10")
    # 後面讀取中文欄位有錯，先將電桿種類的欄位都改用英文
    # 原資料為："3T桿", "H桿", "木併桿", "木桿", "水泥併桿",
    # "水泥桿", "用戶自備桿", "鋼併桿", "鋼桿", "電塔"

    pole_type$key <- rownames(pole_type)
    pole_type <- pole_type[, -1]
    write.csv(pole_type, file="./data/pole.csv", row.names=F, fileEncoding="UTF-8")
    
    # ==== checking missing recorders =============================================================
    # 
    # train  <- read.csv("./data/train.csv",  fileEncoding="UTF-8")
    # train$key  <- paste0(train$CityName, train$TownName, train$VilName)
    # 
    # missing_r <- right_join(train, pole_type, by="key")
    # missing_r <- missing_r[is.na(missing_r$CityName),]
    # missing_r
}

gen_family_info <- function() {

    # 加入人口戶數資料
    # 資料來源為政府資料開放平臺(https://data.gov.tw/dataset/32973#r0)

    family <- read.csv("./data/opendata10603M030.csv", stringsAsFactors=F, fileEncoding="UTF-8-BOM")
    # family[263,3]
    
    family <- family[-1, c("site_id", "village", "household_no")]
    family$site_id <- gsub(x=family$site_id, pattern="　",           replacement="")
    family$site_id <- gsub(x=family$site_id, pattern="臺北",         replacement="台北")
    family$site_id <- gsub(x=family$site_id, pattern="臺中",         replacement="台中")
    family$site_id <- gsub(x=family$site_id, pattern="臺南",         replacement="台南")
    family$site_id <- gsub(x=family$site_id, pattern="高雄市三民一", replacement="高雄市三民區")
    family$site_id <- gsub(x=family$site_id, pattern="高雄市三民二", replacement="高雄市三民區")
    family$site_id <- gsub(x=family$site_id, pattern="高雄市鳳山一", replacement="高雄市鳳山區")
    family$site_id <- gsub(x=family$site_id, pattern="高雄市鳳山二", replacement="高雄市鳳山區")
    family$key <- paste0(family$site_id, family$village)
    
    family$key <- gsub(x=family$key, pattern="台北市信義區富台里",   replacement="台北市信義區富臺里")
    family$key <- gsub(x=family$key, pattern="台南市麻豆區晋江里",   replacement="台南市麻豆區晉江里")
    family$key <- gsub(x=family$key, pattern="新竹縣竹北市中崙里",   replacement="新竹縣竹北市斗崙里")
    family$key <- gsub(x=family$key, pattern="彰化縣彰化市南瑶里",   replacement="彰化縣彰化市南瑤里")
    family$key <- gsub(x=family$key, pattern="雲林縣臺西鄉台西村",   replacement="雲林縣臺西鄉臺西村")
    family$key <- gsub(x=family$key, pattern="雲林縣口湖鄉台子村",   replacement="雲林縣口湖鄉臺子村")
    family$key <- gsub(x=family$key, pattern="嘉義縣中埔鄉塩舘村",   replacement="嘉義縣中埔鄉塩館村")
    family$key <- gsub(x=family$key, pattern="屏東縣霧臺鄉霧台村",   replacement="屏東縣霧臺鄉霧臺村")
    
    family$household_no <- as.character(family$household_no) %>% as.numeric()
    family_grp <- group_by(family, key) %>% summarise(household=sum(household_no)) 
    write.csv(family_grp, file="./data/family.csv", row.names=F, fileEncoding="UTF-8")

    # TODO: 17 missing recorders    
    # ==== checking missing recorders =============================================================
    # 
    # train  <- read.csv("./data/train.csv",  fileEncoding="UTF-8")
    # train$key  <- paste0(train$CityName, train$TownName, train$VilName)
    # 
    # missing_r <- right_join(train, family, by="key")
    # missing_r <- missing_r[is.na(missing_r$CityName),]
    # missing_r
}

gen_gust_info <- function() {

    # 各颱風風力資料
    # 資料來源為颱風資料庫(http://rdc28.cwb.gov.tw/)
    library(xlsx)
    gust <- xlsx::read.xlsx("./data/gust.xlsx", 1)
    names(gust)[1] <- "CityName"
    write.csv(gust, file="./data/gust.csv", row.names=F, fileEncoding="UTF-8")
}

# =================================================================================================

gen_village_info <- function(raw=train) {

    pole   <- read.csv("./data/pole.csv",   fileEncoding="UTF-8", stringsAsFactors=F)
    family <- read.csv("./data/family.csv", fileEncoding="UTF-8", stringsAsFactors=F)

    col_sel <- c("CityName", "TownName", "VilName", "VilCode", "key")

    raw$key  <- paste0(raw$CityName, raw$TownName, raw$VilName)
    raw <- left_join(raw[col_sel], pole, by="key")
    raw <- left_join(raw, family,  by="key")

    # TODO: Correct family info
    # Set the missing value to 0
    raw[is.na(raw)] <- 0

    return (raw)
}

# =================================================================================================

gen_tp_raw <- function(vil, gust, tp, col_tp, is_training=T) {

    col_city <- c("CityName")
    raw <- list()

    for (i in 1:NROW(col_tp)) {
        tp_name  <- col_tp[i]
        col_sel  <- c("VilCode", tp_name)

        col_tp_maxWind <- paste0(tolower(tp_name), "_maxWind")
        col_tp_gust    <- paste0(tolower(tp_name), "_gust")
        col_gust       <- c(col_city, col_tp_maxWind, col_tp_gust)

        if ((col_gust[2] %in% colnames(gust))) {
            raw[[i]] <- left_join(vil, gust[, col_gust], by="CityName")

            colnames(raw[[i]])[colnames(raw[[i]]) == tp_name] <- "tp"
            colnames(raw[[i]])[colnames(raw[[i]]) == col_tp_maxWind] <- "maxWind"
            colnames(raw[[i]])[colnames(raw[[i]]) == col_tp_gust]    <- "gust"

            if (!is_training) 
               next

            raw[[i]] <- left_join(raw[[i]], tp[, col_sel], by="VilCode")
            colnames(raw[[i]])[colnames(raw[[i]]) == tp_name] <- "tp"

        } else {
            message(paste0("[W] No info in table gust, skip: ", tp_name))
        }
    }

    names(raw) <- col_tp 

   return (raw)
}

# =================================================================================================

build_rf_model <- function(raw, col_feature) {
    rf <- list()

    col_real <- c("tp")
    col_sel  <- c(col_feature, col_real)

    for (i in 1:length(raw)) {
        if ( is.null(raw[[i]]) ) {
            rf[[i]] <- NULL
        } else {
            rf[[i]] <- randomForest(tp~., data=raw[[i]][, col_sel],ntree=5000)
            real <- raw[[i]][, col_real]
            pred <- gen_predict(model=rf[[i]], raw=raw[[i]][, col_feature], row_zero=row_zero, row_max=fp_max, magic_value=1.53)
            score <- CM(real, pred)
            message(sprintf("Training score: %2.6f - %s", score, names(raw[i])))
        }
    }

    names(rf) <- names(raw)

    return (rf)
}

# =================================================================================================

#  Morisita Similarity (CM)
CM <- function(x, y) {
    # Check variable type
    x <- as.numeric(x)
    y <- as.numeric(y)

    x <- ifelse(x < 0, 0, x)
    y <- ifelse(y < 0, 0, y)

    # The formula
    sim <- 2*sum(x*y)/(sum(x^2+y^2))
    
    return(sim)
}

Scoring <- function(real, pred) {
    
    score_1 <- CM(real[, 1], pred[, 1])
    score_2 <- CM(real[, 2], pred[, 2])
    score <- (score_1 + score_2) / 2.0
    score <- ifelse(score < 0, 0, score) * 100
    
    message("score 1: ", score_1)
    message("score 2: ", score_2)
    message("  Final: ", score)
}

gen_predict <- function(model, raw, row_zero, row_max, magic_value=1) {
    pd <- predict(model, newdata=raw) * magic_value
    pd[row_zero] <- 0
    pd <- apply(cbind(row_max, pd), 1, min)

    return(pd)
}
