setwd("D:\\OneDrive - Univerza v Ljubljani\\FRI\\2_letnik\\UI\\Seminarska\\1")
library(CORElearn)
# Nalozimo ucno mnozico

library(rpart)
library(randomForest)
library(CORElearn)

reg = FALSE


# povprecno stevilo zmag domacih in gostov
df = makeDf("nbadata.txt", reg)
wins1 = nrow(df[df$win == T, ])
loses1 = nrow(df[df$win == F, ])



barplot(height= c(wins1, loses1), names=c("Domaci", "Gostje"), ylab="Stevilo zmag", main="Stevilo zmag domaci/gostje")


df = makeDf("nbadata.txt", reg)

seasons = c("2012-13", "2013-14", "2014-15", "2015-16", "2016-17", "2017-18")

domaci_arr = c()
gosti_arr = c()

for(ses in seasons){
  domaci_w = nrow(df[df$gmSeason == ses & df$win == T, ])
  gosti_w = nrow(df[df$gmSeason == ses & df$win == F, ])
  domaci_arr = append(domaci_arr, domaci_w )
  gosti_arr = append(gosti_arr, gosti_w )
}
barplot(height= rbind(domaci_arr, gosti_arr), names=seasons, xlab="Sezone", ylab="Razmerje zmag", main="Razmerje zmag domaci/gostje")

team = 'DAL'
wins_arr = c()
for(ses in seasons){
  df1 = df[df$homeAbbr == team, ]
  df2 = df[df$awayAbbr == team, ]
  wins1 = nrow(df1[df1$gmSeason == ses & df1$win == T, ]) # zmaga kot domaci
  wins2 = nrow(df2[df2$gmSeason == ses & df2$win == F, ]) # zmaga kot gostje
  wins_arr = append(wins_arr, (wins1 + wins2) )
}

x <- c(1, 2, 3, 4, 5, 6)

plot(x, wins_arr, type = "b", xlab = "sezone", ylab = "stevilo zmag", main="Stevilo zmag ekipe Dallas po sezonah")

df = makeDf("nbadata.txt", reg)

teams = levels(df$awayAbbr)

teams_arr = c()

for(team in teams){
  print(team)
  df2 = df[df$homeAbbr == team, ]
  wins = nrow(df2[df2$win == T, ]) # zmaga kot domaci
  loses = nrow(df2[df2$win == F, ])
  
  
  df2 = df[df$awayAbbr == team, ]
  wins1 = nrow(df2[df2$win == F, ]) # zmaga kot gostje
  loses1 = nrow(df2[df2$win == T, ])

  
  
  teams_arr[team] = (wins+wins1)/(loses+loses1)
}

y = sort(teams_arr, decreasing=T)
y

barplot(height=y, names=names(y), cex.names=0.7, ylab="razmerje zmag", xlab="ekipe", main="Najboljse ekipe po razmerju zmag")



nrow(df[df$homeAbbr == 'GS' & df$win == T, ])
nrow(df[df$homeAbbr == 'GS' & df$win == F, ])

nrow(df[df$awayAbbr == 'GS' & df$win == T, ])
nrow(df[df$awayAbbr == 'GS' & df$win == F, ])

boxplot(df$win == T)
summary(df)