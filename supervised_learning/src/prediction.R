setwd("D:\\OneDrive - Univerza v Ljubljani\\FRI\\2_letnik\\UI\\Seminarska\\1")
library(CORElearn)
# Nalozimo ucno mnozico

library(rpart)
library(randomForest)
library(CORElearn)

reg = FALSE

df = makeDf("nbadata.txt", reg)
summary(df)
hteam = "CHI"
ateam = "ORL"

df1 = makeSeasonMean(df, "2012-13", hteam, ateam, reg)
df2 = makeSeasonMean(df, "2013-14", hteam, ateam, reg)
df3 = makeSeasonMean(df, "2014-15", hteam, ateam, reg)
df4 = makeSeasonMean(df, "2015-16", hteam, ateam, reg)

train = rbind(df1, df2, df3, df4)
train = na.omit(train)


test = makeSeasonMean(df, "2016-17", hteam, ateam, reg)
test = na.omit(test)

# uporabimo atribut st. tock na koncu 3/4

#train = train[, -which(colnames(train)=='diffScore')]
#test = test[, -which(colnames(test)=='diffScore')]


summary(train)
summary(test)

remove = c("homeDayOff", "awayDayOff", "homeTRB", "awayTRB", "awayDRB")

for(col in remove) {
  col_in1 = which(colnames(train)==col)
  col_in2 = which(colnames(test)==col)
  
  train <- train[, -col_in1]
  test <- test[, -col_in2]
}



predictMatch <- function(hteam, ateam, df, id) {
  reg = FALSE
  
  df = makeDf("nbadata.txt", reg)
  
  df1 = makeSeasonMean(df, "2012-13", hteam, ateam, reg)
  df2 = makeSeasonMean(df, "2013-14", hteam, ateam, reg)
  df3 = makeSeasonMean(df, "2014-15", hteam, ateam, reg)
  df4 = makeSeasonMean(df, "2015-16", hteam, ateam, reg)
  
  train = rbind(df1, df2, df3, df4)
  train = na.omit(train)
  
  match = makeMatchMean(df, "2016-17", hteam, ateam, FALSE, id)
  
  observed = match$win
  
  test = match

  
  # uporabimo atribut st. tock na koncu 3/4
  
  match = match[, -which(colnames(match)=='diffScore')]
  train = train[, -which(colnames(train)=='diffScore')]
  
  print(match)
  
  #print(summary(train))

  
  for(col in remove) {
    col_in1 = which(colnames(train)==col)
    train <- train[, -col_in1]

  }
  
  # Random forest
  rf <- randomForest(win ~ ., data = train)
  predrf <- predict(rf, test, type="class")
  #print(paste("Predicted: ", predicted))
  #print(paste("Observed: ", observed))
  
  # Tree
  dt <- rpart(win ~ ., data = train)
  predtr <- predict(dt, test, type="class")
  
  knn <- CoreModel(win ~  ., data = train, model="knn", kInNN = 10)
  predkn <- predict(knn, test, type="class")
  
  
  return(c(observed, predrf, predtr, predkn))

}

season = "2016-17"
sid = 5070
eid = 6140
n = 200
ids = sample(5070:6140, n, replace=TRUE)
#eid = 6140

observed = c()
predrf = c()
predtr = c()
predkn = c()

for(id in ids){
  print(id)
  hteam = df[df$id == id, 'homeAbbr']
  ateam = df[df$id == id, 'awayAbbr']
  res = predictMatch(hteam, ateam, df, id)
  observed = append(observed, res[1])
  predrf = append(predrf, res[2])
  predtr = append(predtr, res[3])
  predkn = append(predkn, res[4])
}

observed

vecinski = max(table(observed)) / sum(table(observed))
rf = mean(observed == predrf)
tr = mean(observed == predtr)
knn = mean(observed == predkn)

print(paste("Vecinski: ", vecinski))
print(paste("Drevo: ", tr))
print(paste("knn: ", knn))
print(paste("Random forest: ", rf))




