setwd("D:\\OneDrive - Univerza v Ljubljani\\FRI\\2_letnik\\UI\\Seminarska\\1")

library(CORElearn)
# Nalozimo ucno mnozico
reg = FALSE 

df = makeDf("nbadata.txt", reg)
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


#train = train[, -which(colnames(train)=='diffScore')]
#test = test[, -which(colnames(test)=='diffScore')]

summary(train)
summary(test)

head(sort(attrEval(win ~ ., train, "Gini", binaryEvaluation=T), decreasing = T), 5)
head(sort(attrEval(win ~ ., train, "GainRatio", binaryEvaluation=T), decreasing = T), 5)
head(sort(attrEval(win ~ ., train, "ReliefFequalK", binaryEvaluation=T), decreasing = T), 5)

remove = c("homeDayOff", "awayDayOff", "homeTRB", "awayTRB", "awayDRB")

for(col in remove) {
  col_in1 = which(colnames(train)==col)
  col_in2 = which(colnames(test)==col)
  
  train <- train[, -col_in1]
  test <- test[, -col_in2]
}

observed <- test$win

# Vecinski klasifikator

majorityClassificatior(test)



# indikator razreda (potrebujemo ga za ocenjevanje verjetnostnih napovedi)
library(nnet)
obsMat <- class.ind(test$win)

# funkcija za izracun klasifikacijske tocnosti
CA <- function(observed, predicted)
{
  mean(observed == predicted)
}

# funkcija za izracun povprecne Brierjeve mere
brier.score <- function(observedMatrix, predictedMatrix)
{
  sum((observedMatrix - predictedMatrix) ^ 2) / nrow(predictedMatrix)
}

set.seed(0)

# ODLOCITVENO DREVO

library(rpart)
dt <- rpart(win ~ ., data = train)

library(rpart.plot)
rpart.plot(dt)

predicted <- predict(dt, test, type="class")
CA(observed, predicted)

predMat <- predict(dt, test, type = "prob")
brier.score(obsMat, predMat)


# Naivni Bayes

library(e1071)
set.seed(0)
nb <- naiveBayes(win ~ ., data = train)
predicted <- predict(nb, test, type="class")
CA(observed, predicted)

predMat <- predict(nb, test, type = "raw")
brier.score(obsMat, predMat)


# RANDOM FOREST 

set.seed(0)
library(randomForest)

rf <- randomForest(win ~ ., data = train)
predicted <- predict(rf, test, type="class")
CA(observed, predicted)

predMat <- predict(rf, test, type = "prob")
brier.score(obsMat, predMat)

# KNN 

set.seed(0)
library(CORElearn)
knn <- CoreModel(win ~  ., data = train, model="knn", kInNN = 5)
predicted <- predict(knn, test, type="class")
CA(observed, predicted)

predMat <- predict(knn, test, type = "prob")
brier.score(obsMat, predMat)

