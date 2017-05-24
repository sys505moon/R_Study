# count by author
library(data.table)

author <- read.csv("author.csv")
author1_5 <- read.csv("author1-5.csv")
author6_10 <- read.csv("author6-10.csv")
author11_15 <- read.csv("author11-15.csv")
author16_21 <- read.csv("author16-21.csv")

A <- unlist(as.list(author))
uni_A <- unique(A)

 # 저자별 논문횟수 카운
SearchCount <- function(author){
  author1 <- as.data.frame(author[,1])
  author2 <- as.data.frame(author[,2])
  author3 <- as.data.frame(author[,3])
  author4 <- as.data.frame(author[,4])
  author5 <- as.data.frame(author[,5])
  author6 <- as.data.frame(author[,6])
  author7 <- as.data.frame(author[,7])
  
  colnames(author1) = "author"
  colnames(author2) = "author"
  colnames(author3) = "author"
  colnames(author4) = "author"
  colnames(author5) = "author"
  colnames(author6) = "author"
  colnames(author7) = "author"
  
  author_r <- rbind(author1, author2, author3, author4, author5, author6, author7)
  author_r <- as.data.table(author_r)
  result <- author_r[, .N, by = "author"][order(-N)]
}

book1_21 <- SearchCount(author)
book1_5 <- SearchCount(author1_5)
book6_10 <- SearchCount(author6_10)
book11_15 <- SearchCount(author11_15)
book16_21 <- SearchCount(author16_21)

write.csv(book1_5, "book1_5.csv")
write.csv(book6_10, "book6_10.csv")
write.csv(book11_15, "book11_15.csv")
write.csv(book16_21, "book16_21.csv")
write.csv(book1_21, "book1_21.csv")
