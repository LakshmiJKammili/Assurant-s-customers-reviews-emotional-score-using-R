install.packages("tidyverse")
library(tidyverse)
library(rvest)
library(purrr)
library(XML)
library(magrittr)
#tidyverse_conflicts()
#If conflicts occur need to execute below lines
install.packages("conflicted")
library(conflicted)
library(dplyr)
#> Error: filter found in 2 packages. You must indicate which one you want with ::
#>  * dplyr::filter
#>  * stats::filter
filter <- dplyr::filter
#<conflicts>
a<-10
Assurant_Review<-NULL
url <- "https://www.assurant.com/our-story/Assurant-reviews?start=" 
url %>% 
  map2_chr(1:10,paste0) %>% 
  map(. %>% 
        read_html() %>% 
        html_nodes(".section-content") %>% 
        html_text()
  ) %>% 
  unlist() -> more_reviews
more_reviews
write.table(more_reviews,file="Assurant_Review.csv")
txt <- read.csv(file.choose(), header = TRUE)
View(txt)
str(txt)
length(txt)
y<-as.character(txt$x)
str(y)
length(y)
install.packages("tm")
library(tm)
y<-Corpus(VectorSource(y))
str(y)
inspect(y[1])
inspect(y[575])
y1<- tm_map(y,tolower)
inspect(y1[1])
y2<- tm_map(y1, removePunctuation)
inspect(y2[1])
y3<- tm_map(y2, removeNumbers)
inspect(y3[1])
y4<- tm_map(y3, removeWords, stopwords('english'))
inspect(y4[1])
y5<- tm_map(y4, stripWhitespace)
inspect(y5[1])
y6<- tm_map(y5, removeWords, c('insurance'))

#TDM
tdm<- TermDocumentMatrix(y6)
dtm<- t(tdm)
tdm<- as.matrix(tdm)
tdm[1:20, 1:20]
a<- rowSums(tdm)
a
a_sub<- subset(a, a>=80)
a_sub
barplot(a_sub, las=3, col = rainbow(20))

# installed.packages("wordcloud")
# library(wordcloud)
# wordcloud(words = names(a_sub), freq = a_sub)
# a_sub1<- sort(rowSums(tdm), decreasing = TRUE)
# wordcloud(words = names(a_sub1), freq = a_sub1,random.order=F,colors=rainbow(30),scale=c(4,1),rot.per=0.1)
# warnings()
# pos.words=scan(file.choose(),what = "character",comment.char = ";")
# neg.words=scan(file.choose(),what = "character",comment.char = ";")
# pos.words= c(pos.words,"oscar")
# pos.matches= match(names(a_sub1),c(pos.words))
# pos.matches=!is.na(pos.matches)
# freq_pos<-a_sub1[pos.matches]
# p_names<-names(freq_pos)
# windows()
# wordcloud(p_names,freq_pos,scale = c(4,1),colors = rainbow(20))
# 
# neg.matches= match(names(a_sub1),c(neg.words))
# neg.matches=!is.na(neg.matches)
# freq_neg<-a_sub1[neg.matches]
# n_names<-names(freq_neg)
# windows()
# wordcloud(n_names,freq_neg,scale = c(5,1),colors = brewer.pal(8,"Dark2"))

installed.packages("syuzhet")
library("syuzhet")
library(lubridate)
library(ggplot2)
library(scales)
library(dbplyr)
library(reshape2)
View(txt)
txt<-iconv(txt,"UTF-8")
s<-get_nrc_sentiment(txt)
head(s)
colSums(s)
barplot(colSums(s),las = 2,col = rainbow(10),ylab = 'count',main = 'emotion scores')
