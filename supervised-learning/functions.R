makeTrainSet <- function(season, team, df, home) {
  ses1 = df[df$gmSeason == season, ]
  
  print(paste("Domaci: ", home))
  print(paste("Gostje: ", away))
  print(paste("Sezona: ", season))
  
  # 1. mnozica tekem, kjer igrajo domaci (home) ali gostje (away)
  #s1 = ses1[ses1$homeAbbr == home | ses1$awayAbbr == away, ]
  if(home == TRUE){
    s1 = ses1[ses1$homeAbbr == team, ]
  } else {
    s1 = ses1[ses1$awayAbbr == team, ]
  }
  for(x in k:(nrow(s12)-1)) {
    # za vsakega nasprotnika izracunamo mean 
  }
  s1_opp <- s1_res[(k+1):length(s1_res)]
  
  print(paste("St. tekem domacih: ", nrow(ses1[ses1$homeAbbr == home, ])))
  print(paste("St. tekem gostov: ", nrow(ses1[ses1$awayAbbr == away, ])))
  print(paste("St. medsebojnih tekem: ", nrow(ses1[ses1$homeAbbr == home & ses1$awayAbbr == away, ])))
  print(paste("S1 tekem skupaj: ", nrow(s1)))
  
  # 2. izlocimo nepotrebne atribute
  #"homeTO", "awayTO", "homeSTL", "awaySTL", "homePTS34", "awayPTS34"
  s12 = s1
  remove = c("gmSeason", "gmDate", "awayAbbr", "homeAbbr", "homePTS", "awayPTS","homeTO", "awayTO", "homeSTL", "awaySTL",
             "homeDayOff", "awayDayOff")
  for(col in remove) {
    col_in = which(colnames(s12)==col)
    #print(col_in)
    s12 <- s12[, -col_in]
  }
  
  zac1 = which(colnames(s12)=="awayFGA")
  s12 <- s12[, -zac1:-(zac1+7)]
  zac2 = which(colnames(s12)=="homeFGA")
  s12 <- s12[, -zac2:-(zac2+7)]

  
  zac1 = which(colnames(s12)=="awayPTS1")
  s12 <- s12[, -zac1:-(zac1+4)]
  zac2 = which(colnames(s12)=="homePTS1")
  s12 <- s12[, -zac2:-(zac2+4)]

  
  # ekipa = povprecje statstik zadnjih k iger
  k = 5
  print(paste("k (zadnjih odigranih iger): ", k))
  
  # mnozica rezultatov
  s1_res <- s12[, c("win")]
  
  
  #s1_res <- s12[, c("win", "ID")]
  s1_res <- s1_res[(k+1):length(s1_res)]
  
  
  # s1_mean povprecene statistike tekem
  s1_mean = head(s12, 0)
  
  # Za izracun povprecji odtranimo ID in win stolpca
  
  print(paste("Prej: ", ncol(s1_mean)))
  st = ncol(s1_mean)
  #s1_mean <- s1_mean[, -c(which(colnames(s1_mean)=="win"), which(colnames(s1_mean)=="ID"))]
  s1_mean <- s1_mean[, -c(which(colnames(s1_mean)=="win"))]
  
  print(paste("Potem: ", ncol(s1_mean)))
  #print(summary(s1_mean))
  
  
  # zadnjih 10 tekem 
  #print(head(s12, 5))
  form = c()
  pts_h = c()
  pts_a = c()
  
  for(x in k:(nrow(s12)-1)) {
    rows = s12[(x-k):x, -c(which(colnames(s12)=="win"))]
    #print(head(s12, 10))
    #print(head(s1_res))
    #rows = s12[(x-k):x, -c(which(colnames(s12)=="ID"), which(colnames(s12)=="win"))]
    wins = s12[(x-k):x, 'win']
    
    # 1/4
    #pts_h <- append(pts_h, s1[x+1, 'homePTS1'])
    #pts_a <- append(pts_a, s1[x+1, 'awayPTS1'])
    
    # 2/4
    #pts_h <- append(pts_h, s1[x+1, 'homePTS1'] + s1[x+1, 'homePTS2'])
    #pts_a <- append(pts_a, s1[x+1, 'awayPTS1'] + s1[x+1, 'awayPTS2'])
    
    # 3/4
    pts_h <- append(pts_h, s1[x+1, 'homePTS1'] + s1[x+1, 'homePTS2'] + s1[x+1, 'homePTS3'])
    pts_a <- append(pts_a, s1[x+1, 'awayPTS1'] + s1[x+1, 'awayPTS2'] + s1[x+1, 'awayPTS3'])
    
    
    #print(pts_h)
    #print(pts_a)
    
    
    #val <- as.numeric(table(wins))
    #form <- append(form, val[2] / sum(val))
    
  
    #print(table(wins))
    #print(form)

    row = colMeans(rows)
    #print(row)

    #print(row)
    s1_mean[nrow(s1_mean) + 1,] = row
    #print(nrow(s1_mean))
    
  }
  
  print(paste("St. tekem s povprecjem zadnjih k tekem: ", nrow(s1_mean)))
  #print(paste("S1_res: ", nrow(s1_res)))
  #s1_mean["homeScore"] = pts_h
  #s1_mean["awayScore"] = pts_a
  s1_mean["diffScore"] = pts_h - pts_a
  #s1_mean["form"] = form
  #s1_mean["ID"] = s1_res["ID"]
  print(table(s1_res))
  s1_mean["win"] = s1_res
  #s1_mean$ID <- as.factor(s1_mean$ID)
  s1_mean$win <- as.factor(s1_mean$win)
  print("Atributi: ")
  print(colnames(s1_mean))
  
  return(s1_mean)
}


majorityClassificatior <- function(datas1) { 
  # vecinski klasifikator
  print(table(datas1$win))
  
  zmag = sum(datas1$win == TRUE) / length(datas1$win)
  poraz = sum(datas1$win == FALSE) / length(datas1$win)
  
  if(zmag >= poraz){
    print(paste("Vecinski razred = zmagali: ", zmag))
  } else {
    print(paste("Vecinski razred = izgubili: ", poraz))
  }
}

testModel <- function(train, test, attrEval, bin) {
  set.seed(0)
  library(CORElearn)
  model <- CoreModel(win ~ ., train, model="rfNear", selectionEstimator=attrEval, binaryEvaluation=bin)
  #model <- CoreModel(win ~ homeFTR + awayFTR + home3PR + homeDRB + awayORB+ away2PR + homeAST, train, model="rfNear", selectionEstimator=attrEval, binaryEvaluation=bin)
  #model <- CoreModel(win ~ ., train, model="rfNear", selectionEstimator=attrEval, binaryEvaluation=bin)
  
  observed <- test$win
  predicted <- predict(model, test, type = "class")
  tab <- table(observed, predicted)
  print(tab)
  
  return(sum(diag(tab)) / sum(tab))
}

bestAttrib <- function(attrEval, train) { 
  library(CORElearn)
  
  t1 = train 
  att = sort(attrEval(win ~ ., t1, attrEval, binaryEvaluation=T), decreasing = T)
  

  while(length(att) > 6) {
    del_att = att[length(att)]
    name = names(del_att)
    st1 = which(colnames(t1)==name)
    print(st1)
    t1 = t1[, -st1]
    #pritn(t1)

  }
  return(t1)

}

