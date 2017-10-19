# Working items
* More Features
  - Download the detail of wind / rain info from 颱風資料庫(http://rdc28.cwb.gov.tw/)  

* Clean data
  - Family

* Data normalization
  - Predict the percenatge of failed household instead of # of failed household

* Train
  - Try: Only use village records which 
  - Try: xgboost
  - Implement cross validation

* Scoring
  - Try: Set the predicted value of a village to zero if the failed household is always 0 at this village

* Survey
  - Paper survey - features, learning method

# Log
* 1017
  - Create a github project and upload the source, and then share this project to Louis (DONE: 1017)
* 1019  
  - Clean data - Pole (DONE: 1019)
  - Clean data - quts (DONE: 1019)
  - Add scoring function
  - Handle missing value after merge table (pole, household, set to zero)

# Submit history

* Next?
  - Cleaning partial family data (correct district / village name)

* submit_dc_1018_1449_56.67500.csv
  - Cleaning pole data (correct village name)
  - random foreset, set ntree=3000

* submit_dc_1015_vill_56.55600.csv
  - Integrating village-level data of pole, family (instead of district-level)

* submit_dc_20171016_2356
  - Change magic number
  - megi_pred <- 1.48 x soudelor_pred
  - megi_pred <- 1.45 x soudelor_pred

  - nesatAndHaitang_pred <- 1.45 x meranti_pred
  - nesatAndHaitang_pred <- 1.53 x meranti_pred

* submit_dc_20171017_0224.csv
  - Correct pole village info

* submit_dc_20171017_0253.csv
  - Use the original magic number
