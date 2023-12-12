setwd("D:\\OneDrive - Univerza v Ljubljani\\FRI\\2_letnik\\UI\\Seminarska\\1")

library(CORElearn)
# Nalozimo ucno mnozico
reg = TRUE

df = makeDf("nbadata.txt", reg)
hteam = "CHI"
ateam = "ORL"
summary(df)

df1 = makeSeasonMean(df, "2012-13", hteam, ateam, reg)
df2 = makeSeasonMean(df, "2013-14", hteam, ateam, reg)
df3 = makeSeasonMean(df, "2014-15", hteam, ateam, reg)
df4 = makeSeasonMean(df, "2015-16", hteam, ateam, reg)

train = rbind(df1, df2, df3, df4)
train = na.omit(train)


test = makeSeasonMean(df, "2016-17", hteam, ateam, reg)
test = na.omit(test)


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

observed <- test$win


#
#
# Mere za ocenjevanje ucenja v regresiji
#
#

# srednja absolutna napaka
mae <- function(obs, pred)
{
  mean(abs(obs - pred))
}

# srednja kvadratna napaka
mse <- function(obs, pred)
{
  mean((obs - pred)^2)
}



# Relativne mere ocenjujejo model v primerjavi s trivialno predikcijo

# relativna srednja absolutna napaka
rmae <- function(obs, pred, mean.val) 
{  
  sum(abs(obs - pred)) / sum(abs(obs - mean.val))
}

# relativna srednja kvadratna napaka
rmse <- function(obs, pred, mean.val) 
{  
  sum((obs - pred)^2)/sum((obs - mean.val)^2)
}

set.seed(0)

# DREVO 

library(rpart)
library(rpart.plot)

rt.model <- rpart(diff ~ ., data=train)
rpart.plot(rt.model)
predicted <- predict(rt.model, test)
mae(test$diff, predicted)
rmae(test$diff, predicted, mean(train$diff))

# do boljsega rezultat lahko pridemo z usreznim rezanjem drevesa

# najprej zgradimo veliko drevo (nastavitev cp=0)
rt.model <- rpart(diff ~ ., data=train, cp=0)
rpart.plot(rt.model)

# rpart med gradnjo drevesa interno ocenjuje njegovo kvaliteto 
tab <- printcp(rt.model)

# izberemo vrednost parametra cp, ki ustreza minimalni napaki internega presnega preverjanja
row <- which.min(tab[,"xerror"])
th <- mean(c(tab[row, "CP"], tab[row-1, "CP"]))
th

# porezemo drevo z izbrano nastavitvijo
rt.model <- prune(rt.model, cp=th)
rpart.plot(rt.model)

predicted <- predict(rt.model, test)
mae(test$diff, predicted)
rmae(test$diff, predicted, mean(train$diff))

# GOZD
library(randomForest)

rf.model <- randomForest(diff ~ ., train)
predicted <- predict(rf.model, test)
mae(test$diff, predicted)
rmae(test$diff, predicted, mean(train$diff))

#
# svm
#

library(e1071)

svm.model <- svm(diff ~ ., train)
predicted <- predict(svm.model, test)
mae(test$diff, predicted)
rmae(test$diff, predicted, mean(train$diff))



#
# k-najblizjih sosedov
#

library(kknn)

knn.model <- kknn(diff ~ ., train, test, k = 10)
predicted <- fitted(knn.model)
mae(test$diff, predicted)
rmae(test$diff, predicted, mean(train$diff))

# -------------------- PREDICTION ---------------------
library(rpart)
library(randomForest)
library(CORElearn)



predictMatch <- function(hteam, ateam, df, id) {
  reg = TRUE
  
  df = makeDf("nbadata.txt", reg)
  
  df1 = makeSeasonMean(df, "2012-13", hteam, ateam, reg)
  df2 = makeSeasonMean(df, "2013-14", hteam, ateam, reg)
  df3 = makeSeasonMean(df, "2014-15", hteam, ateam, reg)
  df4 = makeSeasonMean(df, "2015-16", hteam, ateam, reg)
  print(13)
  
  train = rbind(df1, df2, df3, df4)
  train = na.omit(train)
  
  match = makeMatchMean(df, "2016-17", hteam, ateam, reg, id)
  
  observed = match$diff
  
  test = match
  
  
  # uporabimo atribut st. tock na koncu 3/4
  
  #match = match[, -which(colnames(match)=='diffScore')]
  #train = train[, -which(colnames(train)=='diffScore')]
  
  print(match)
  
  #print(summary(train))

  
  # Random forest
  rf.model <- randomForest(diff ~ ., train)
  predrf <- predict(rf.model, test)
  
  # Tree
  rt.model <- rpart(diff ~ ., data=train)
  predtr <- predict(rt.model, test)
  
  # knn
  knn.model <- kknn(diff ~ ., train, test, k = 10)
  predkn <- fitted(knn.model)
  
  
  return(c(observed, predrf, predtr, predkn, mean(train$diff)))
  
}
reg = TRUE

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
traindiff = c()

for(id in ids){
  print(id)
  hteam = df[df$id == id, 'homeAbbr']
  ateam = df[df$id == id, 'awayAbbr']
  res = predictMatch(hteam, ateam, df, id)
  observed = append(observed, res[1])
  predrf = append(predrf, res[2])
  predtr = append(predtr, res[3])
  predkn = append(predkn, res[4])
  traindiff = append(traindiff, res[5])
}

observed
rmaerf = round(sum(abs(observed - predrf)) / sum(abs(observed - traindiff)), digits=3)
rmaetr = round(sum(abs(observed - predtr)) / sum(abs(observed - traindiff)), digits=3)
rmaeknn = round(sum(abs(observed - predkn)) / sum(abs(observed - traindiff)), digits=3)

rf = mean(abs(observed - predrf))
tr = mean(abs(observed - predtr))
knn = mean(abs(observed - predkn))


print(paste("Drevo: (mae)", round(tr, digits=3), "(rmae) ", rmaetr))
print(paste("knn: (mae)", round(knn, digits=3), "(rmae) ", rmaeknn))
print(paste("Random forest: (mae)", round(rf, digits=3), "(rmae) ", rmaerf))
