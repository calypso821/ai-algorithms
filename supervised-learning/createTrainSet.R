makeDf <- function(file, reg) {
  df <- read.table(file, header = T, sep = ",", stringsAsFactors = T)
  
  df$gmSeason <- as.factor(df$gmSeason)
  if(reg == FALSE) {
    df$win = df$homePTS > df$awayPTS
    df$win <- as.factor(df$win)
  } else {
    df$diff = df$homePTS - df$awayPTS
  }
  df$id <- seq.int(nrow(df))
  nrow(df)
  # vizualizacija 
  # zmage domaci, gostje 
  
  # dodamo razmerja zadetih (namesto vseh in uspesnih)
  # FG - ratio
  
  df['awayFGR'] = df$awayFGM / df$awayFGA
  df['homeFGR'] = df$homeFGM / df$homeFGA
  
  df['away2PR'] = df$away2PM / df$away2PA
  df['home2PR'] = df$home2PM / df$home2PA
  
  df['away3PR'] = df$away3PM / df$away3PA
  df['home3PR'] = df$home3PM / df$home3PA
  
  df['awayFTR'] = df$awayFTM / df$awayFTA
  df['homeFTR'] = df$homeFTM / df$homeFTA
  summary(df)
  
  napadi_h = df$homeFGA + df$homeTO + df$homeSTL
  #print(df$homeFGM / napadi_h)
  df["homeAttR"] = df$homeFGM / napadi_h
  
  napadi_a = df$awayFGA + df$awayTO + df$awaySTL
  #print(df$awayFGM / napadi)
  df["awayAttR"] = df$awayFGM / napadi_a
  
  # razmerje uspesnih napadov 
  # st zadetkov / vseh napadov 
  # vseh napadov = st. vseh metov + izgubjene zoge + ukradene zoge 
  
  #df['homePTS34'] = df$homePTS1 + df$homePTS2 + df$homePTS3 + df$homePTS4
  #df['awayPTS34'] = df$awayPTS1 + df$awayPTS2 + df$awayPTS3 + df$awayPTS4
  
  return(df)
}



makeTeamMean <- function(df, season, team, id, home, reg) {
  
  
  ses1 = df[df$gmSeason == season, ]
  if(home==TRUE) {
    s1 = ses1[ses1$homeAbbr == team, ]
  } else {
    s1 = ses1[ses1$awayAbbr == team, ]
  }
  
  head(s1, 5)
  # regresija
  if(reg == TRUE){
    cilj = 'diff'
    diff = s1[s1$id == id, cilj]
  } else {
    cilj = 'win'
    win = s1[s1$id == id, cilj]
  }
  
  row = s1[s1$id == id, ] 
  
  k = 5
  # vse tekme, ki so zgodile pred napovedovano 
  rows = s1[s1$id < id, ] 
  head(rows)
  #print(nrow(rows))
  st = nrow(rows)
  
  if(st < k)
    k = st
  
  # pogledamo k prejsnjih tekem
  mean_rows = rows[(st-k+1):st, ]
  head(mean_rows, 10)
  
  # odstranmo nepotrebne atribute
  s12 = mean_rows
  
  val <- as.numeric(table(mean_rows$win))
  tform <- as.double(val[2]) / as.double(sum(val))
  if(home == TRUE){
    
    # , "awayPTS34"
    remove_away = c("id", cilj, "gmSeason", "gmDate", "homeAbbr", "homePTS", "homeTO", "homeSTL", "awayAttR", "awayFTR", "away3PR", "away2PR", "awayFGR")
    for(col in remove_away) {
      col_in = which(colnames(s12)==col)
      s12 <- s12[, -col_in]
   
    }
    
    # remove Away 
    zac1 = which(colnames(s12)=="awayAbbr")
    s12 <- s12[, -zac1:-(zac1+23)]
    
    zac2 = which(colnames(s12)=="homeFGA")
    s12 <- s12[, -zac2:-(zac2+7)]
    
    zac2 = which(colnames(s12)=="homePTS1")
    s12 <- s12[, -zac2:-(zac2+4)]
    
  } else {
    # , "awayPTS34"
    remove_home = c("id", cilj, "gmSeason", "gmDate", "awayAbbr", "awayPTS", "awayTO", "awaySTL", "homeAttR", "homeFTR", "home3PR", "home2PR", "homeFGR")
    
    for(col in remove_home) {
      col_in = which(colnames(s12)==col)
      s12 <- s12[, -col_in]
    }

    # remove Home
    zac1 = which(colnames(s12)=="homeAbbr")
    s12 <- s12[, -zac1:-(zac1+23)]
    
    zac1 = which(colnames(s12)=="awayFGA")
    s12 <- s12[, -zac1:-(zac1+7)]
    
    zac1 = which(colnames(s12)=="awayPTS1")
    s12 <- s12[, -zac1:-(zac1+4)]
  }
  
  head(s12)
  
  # izracunamo povprecje 
  
  s1_mean_row = colMeans(s12)
  s1_mean = head(s12, 0)
  s1_mean[1, ] = s1_mean_row
  
  
  # stevilo tock po cetrtinah 
  
  pts_h = c()
  pts_a = c()
  
  # 1/4
  #pts_h <- row$homePTS1
  #pts_a <- row$awayPTS1
  
  # 2/4
  #pts_h <- row$homePTS1 + row$homePTS2
  #pts_a <- row$awayPTS1 + row$awayPTS2
  
  # 3/4
  pts_h <- row$homePTS1 + row$homePTS2 + row$homePTS3
  pts_a <- row$awayPTS1 + row$awayPTS2 + row$awayPTS3
  
  
  
  
  s1_mean["diffScore"] = pts_h - pts_a 
  
  if(reg == TRUE) {
    s1_mean['diff'] = diff
  } else {
    if(home==TRUE){
      s1_mean["homeForm"] = tform
    } else {
      s1_mean["awayForm"] = 1 - tform
    }
    
    s1_mean['win'] = win
    s1_mean$win <- as.factor(s1_mean$win)
  }
  
  
  return(s1_mean)
}





makeSeasonMean <- function(df, season, hteam, ateam, reg) {
  # ------------------- DOMACI ------------------ 
  
  ses1 = df[df$gmSeason == season, ]
  #print(ses1)
  s1 = ses1[ses1$homeAbbr == hteam, ]
  
  ids = s1$id
  df_home = list()
  
  #print(s1)
  
  for(id in ids[2:length(ids)]){
    row_home = makeTeamMean(df, season, hteam, id, TRUE, reg)
    #print(row_home)
    away = df[df$id == id, 'awayAbbr']
    row_away = makeTeamMean(df, season, away, id, FALSE, reg)
    #print(row_away)
    row = merge(row_home, row_away)
    df_home = rbind(df_home, row)
  }
  #print(head(df_home))
 # print(paste("St. tekem team 1: ", nrow(df_home)))
  #print(df_home)

  
  # ------------------- GOSTJE ------------------
  
  
  ses1 = df[df$gmSeason == season, ]
  s1 = ses1[ses1$awayAbbr == ateam & ses1$homeAbbr != hteam , ]
  #head(s1, 5)
  
  ids = s1$id
  df_away = list()
  
  for(id in ids[2:length(ids)]){
    row_away = makeTeamMean(df, season, ateam, id, FALSE, reg)
    home = df[df$id == id, 'homeAbbr']
    row_home = makeTeamMean(df, season, home, id, TRUE, reg)
    
    row = merge(row_home, row_away)
    df_away = rbind(df_away, row)
  }
  
 # print(paste("St. tekem team 2: ", nrow(df_away)))
  #print(head(df_away))
  
  
  # ------------ SKUPAJ ---------------
  df_all = rbind(df_home, df_away)
  
  s1 = ses1[ses1$homeAbbr == hteam | ses1$awayAbbr == ateam, ]
  
 # print(paste("St. tekem skupaj (old): ", nrow(s1) -2))
 # print(paste("St. tekem skupaj (new): ", nrow(df_all)))
  
 # if(reg == FALSE) {
#    print("Wins (old):")
#    print(table(s1$win))
    
 #   print("Wins (new):")
 #   print(table(df_all$win))
 # }

  return(df_all)
  
}

makeMatchMean <- function(df, season, hteam, ateam, reg, id1) {
  # ------------------- DOMACI ------------------ 

  
  ses1 = df[df$gmSeason == season, ]
  s1 = ses1[ses1$homeAbbr == hteam, ]
  
  
  df_home = list()
  
  row_home = makeTeamMean(df, season, hteam, id1, TRUE, reg)
  #print(row_home)

  away = df[df$id == id1, 'awayAbbr']
  row_away = makeTeamMean(df, season, away, id1, FALSE, reg)
  #print(row_away)

  row = merge(row_home, row_away)
  df_home = rbind(df_home, row)

  #print(head(df_home))
  #print(paste("St. tekem team 1: ", nrow(df_home)))
  #print(df_home)

  
  return(df_home)
  
}

