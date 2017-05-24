rm(list=ls())
gc()
# install.packages("sna")
# install.packages("data.table")
library(sna)
library(data.table)
setwd("c:/R/SNA_practice/data_treat/SNA_practice_data_treat")
data <- read.csv("전자상거래학회지 논문목록 6권~10권.csv")

data$Author1 <- as.character(data$Author1)
data$Author2 <- as.character(data$Author2)
data$Author3 <- as.character(data$Author3)
data$Author4 <- as.character(data$Author4)
data$Author5 <- as.character(data$Author5)
data$Author6 <- as.character(data$Author6)
data$Author7 <- as.character(data$Author7)
str(data)

class(data)
data_DT <- as.data.table(data)
data_DT

# 단독저자 행 지움
setkey(data_DT, Author2)
data_DT <- data_DT[!""]
data_DT

# Author1을 중심으로 melting
data_DT_melted1 <- melt.data.table(data_DT, id.vars = "Author1")
data_DT_melted1
#  한melting 데이터 테이블에서 value 없는행 지움
# 왜냐하면 melt는 일단 다 녹이니까 data_DT_melted에는 Author7이 없다면 공란으로 들어가기 때문
setkey(data_DT_melted1, value)
data_DT_melted1 <- data_DT_melted1[!""]
# data_DT_melted1는 Author1을 중심으로 함
data_DT_melted1

# Author1 지우고 위 과정 반복
data_DT[,Author1 := NULL]
setkey(data_DT, Author3)
data_DT <- data_DT[!""]
data_DT_melted2 <- melt.data.table(data_DT, id.vars = "Author2")
data_DT_melted2
setkey(data_DT_melted2, value)
data_DT_melted2 <- data_DT_melted2[!""]
data_DT_melted2

# Author2 지우고 반복
data_DT[,Author2 := NULL]
setkey(data_DT, Author4)
data_DT <- data_DT[!""]
data_DT_melted3 <- melt.data.table(data_DT, id.vars = "Author3")
setkey(data_DT_melted3, value)
data_DT_melted3 <- data_DT_melted3[!""]


# Author3 지우고 반복
data_DT[,Author3 := NULL]
setkey(data_DT, Author5)
data_DT <- data_DT[!""]
data_DT_melted4 <- melt.data.table(data_DT, id.vars = "Author4")
setkey(data_DT_melted4, value)
data_DT_melted4 <- data_DT_melted4[!""]


# Author4 지우고 반복
data_DT[,Author4 := NULL]
setkey(data_DT, Author6)
data_DT <- data_DT[!""]
data_DT_melted5 <- melt.data.table(data_DT, id.vars = "Author5")
setkey(data_DT_melted5, value)
data_DT_melted5 <- data_DT_melted5[!""]


# Author5 지우고 반복
data_DT
data_DT[,Author5 := NULL]
data_DT
setkey(data_DT, Author7)
data_DT <- data_DT[!""]
data_DT_melted6 <- melt.data.table(data_DT, id.vars = "Author6")
setkey(data_DT_melted6, value)
data_DT_melted6 <- data_DT_melted6[!""]
data_DT_melted6

# remove "variable" column
data_DT_melted1[,variable := NULL]
data_DT_melted2[,variable := NULL]
data_DT_melted3[,variable := NULL]
data_DT_melted4[,variable := NULL]
data_DT_melted5[,variable := NULL]
data_DT_melted6[,variable := NULL]

data_DT_melted1
data_DT_melted2
data_DT_melted3
data_DT_melted4
data_DT_melted5
data_DT_melted6

names(data_DT_melted1) <- c("Start","End")
names(data_DT_melted2) <- c("Start","End")
names(data_DT_melted3) <- c("Start","End")
names(data_DT_melted4) <- c("Start","End")
names(data_DT_melted5) <- c("Start","End")
names(data_DT_melted6) <- c("Start","End")

data_DT_melted_rbind <- rbind(data_DT_melted1,data_DT_melted2,data_DT_melted3,
                              data_DT_melted4,data_DT_melted5,data_DT_melted6)

data_DT_melted_rbind_1 <- data_DT_melted_rbind
data_DT_melted_rbind_2 <- data_DT_melted_rbind[,.(Start=End, End=Start)]

data_DT_melted_rbind_1[,count:=1]
data_DT_melted_rbind_2[,count:=1]


lastrbind <- rbind(data_DT_melted_rbind_1,data_DT_melted_rbind_2)
lastrbind <- lastrbind[,.(sum=sum(count)),by=.(Start,End)]


matrix <- as.data.frame.matrix(xtabs(sum~Start+End, lastrbind))
gplot(matrix)

save(matrix, file = "전자상거래학회지 6권_10권.RData")
