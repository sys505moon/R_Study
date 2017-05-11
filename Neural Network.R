## 인공신경망 예제

getwd()
setwd("/home/moon/R/study")

data("iris")
iris.scaled <- cbind(scale(iris[-5]), iris[5])

set.seed(1000)
index <- c(sample(1:50, 35), sample(51:100, 35), sample(101:150, 35))
iris_train <- iris.scaled[index,]
iris_test <- iris.scaled[-index,]

# install.packages("nnet")
library(nnet)

model.nnet <- nnet(Species~., data = iris_train, size = 2, decay = 5e-04)
summary(model.nnet)

pre <- predict(model.nnet, iris_test, type = 'class')
pre
actual <- test$Species
table(pre, actual)

### wine 데이터 이용 예제
wine <- read.csv("wine.csv")
head(wine)
str(wine)

 # type을 예측하는 신경망 분석
wine.scale <- cbind(wine[1], scale(wine[-1]))

size <- nrow(wine.scale)
set.seed(100)
index <- c(sample(1:size, size*0.7))
wine_train <- wine.scale[index,]
wine_test <- wine.scale[-index,]

model.nnet.wine <- nnet(Type~., data = wine_train, size = 2, decay = 5e-04, maxit = 200)
wine_predict <- predict(model.nnet.wine, wine_test, type = "class")
wine_actual <- wine_test$Type
  
table(wine_predict, wine_actual)

### concrete 데이터 이용 예제 (분류가 아닌 연속형 Y 의 예측값 분석) *** 중요 ***
concrete <- read.csv("concrete.csv", stringsAsFactors = F)[-1]

 # 데이터 정규화
normalize <- function(x){
  return((x-min(x))/(max(x)-min(x)))
}
concrete <- as.data.frame(lapply(concrete, normalize))

max_index <- length(concrete$strength)
slice_index <- round(max_index*0.75)
concrete_train <- concrete[1:slice_index,]
concrete_test <- concrete[slice_index:max_index,]

model.nnet.concrete <- nnet(strength ~., data = concrete_train, size = 3, decay = 5e-04)
nnet.concrete.predict <- predict(model.nnet.concrete, concrete_test, type = 'raw')
compare_concrete <- cbind(nnet.concrete.predict, concrete_test$strength)
colnames(compare_concrete) <- c("predict", "actual")
compare_concrete <- transform(compare_concrete, diff = predict-actual)
d
### 'neuralnet' package를 이용한 신경망 분석석

 # strength 를 예측하는 신경망 분석
# install.packages("neuralnet")
library(neuralnet)

concrete <- read.csv("concrete.csv", stringsAsFacbtors = F)[-1]
head(concrete)
str(concrete)

 # 데이터 정규화
normalize <- function(x){
  return((x-min(x))/(max(x)-min(x)))
}

concrete <- as.data.frame(lapply(concrete, normalize))
head(concrete)

 # 훈련/톄스트 데이터 분할 (데이터를 순서대로 자름 ; 랜덤으로 추출이 아닌)
max_index <- length(concrete$strength)
slice_index <- round(max_index*0.75)
concrete_train <- concrete[1:slice_index,]
concrete_test <- concrete[slice_index:max_index,]

concrete_model <- neuralnet(strength ~ cement+flag+ash+water+superplastic+coarseagg+findagg+age, data = concrete_train,
                            hidden = c(3,3))
plot(concrete_model)

concrete_model


### x_AAPL 데이터 신경망 분석

x_AAPL_nnet <- x_AAPL
size <- nrow(x_AAPL_nnet)
index <- c(sample(1:size, size*0.7))
x_AAPL_train <- x_AAPL_nnet[index,]
x_AAPL_test <- x_AAPL_nnet[-index,]

model.x_AAPL.nnet <- nnet(end_price ~ high_price+low_price+dividend_tendency, data = x_AAPL_train, size = 5, decay = 5e-4)
x_AAPL_predict <- predict(model.x_AAPL.nnet, x_AAPL_test, type = "raw")
transform(x_AAPL_predict, actual = x_AAPL_nnet[-index,]$end_price)


### 신경망 예제 (히든노드 수를 반복문으로 탐색) (URL : www.datamarket.kr/xe/board_BoGi29/6641)
# install.packages("ElemStatLearn")
library(ElemStatLearn)
library(nnet)

data(spam)
View(head(spam))
dim(spam)
str(spam)
summary(spam)

spam_s <- spam[spam$spam == "spam",]
email_s <- spam[spam$spam == "email",]
set.seed(1234)
ind1 <- sample(3, nrow(spam_s), replace = TRUE, prob = c(0.5, 0.3, 0.2))
set.seed(4321)
ind2 <- sample(3, nrow(email_s), replace = TRUE, prob = c(0.5, 0.3, 0.2))
spam.train <- rbind(spam_s[ind1 == 1,], email_s[ind2 == 1,])
spam.test <- rbind(spam_s[ind1 == 2,], email_s[ind2 == 2,])
spam.valid <- rbind(spam_s[ind1 == 3,], email_s[ind2 == 3,])

spam.train$spam <- class.ind(spam.train$spam) # variable "spam" convert type
spam.test$spam <- class.ind(spam.test$spam)
spam.valid$spam <- class.ind(spam.valid$spam)

myformula <- spam ~ .

  # decide the number of nodes by using test error

test.err <- function(h.size, maxit0){
  spammodel1 <- nnet(myformula, data = spam.train, size = h.size, decay = 5e-4, trace = F, maxit = maxit0)
  y <- spam.test$spam
  p <- predict(spammodel1, spam.test)
  err <- mean(y != p)
  c(h.size, err)
}


  # comparing test error rates for neural networks with 1-10 hidden units

out <- t(sapply(1:10, FUN = test.err, maxit0 = 200)) # sapply()와 관련해서 상당히 재미있고 공부할만한 코드 입니다.
plot(out, type = "b", xlab = "The number of Hidden units", ylab = "Test error")

  # fitting the model using nnet

model12 <- nnet(myformula, size = 3, decay = 5e-04, range = 0.1, maxit = 200, data = spam.train)
summary(model12)

spam.pred.valid <- predict(model12, new = spam.valid)

  # confusion matrix using validation data

# install.packages("SDMTools")
library(SDMTools)

obs <- spam.valid$spam[,2] > 0.5
pred <- spam.pred.valid[,2] > 0.5
cfm <- table(data.frame(pred, obs))

sensitivity <- cfm[1,1]/(cfm[1,1]+cfm[2,1])
specificity <- cfm[2,2]/(cfm[1,2]+cfm[2,2])
accuracy <- (cfm[1,1]+cfm[2,2])/(cfm[1,1]+cfm[1,2]+cfm[2,1]+cfm[2,2])

cfm
sensitivity
specificity
accuracy

plot(spam.pred.valid[.2] ~ spam.valid$spam[,2])

  # Compare with test & validation

spam.pred.test <- predict(model12, new = spam.test)
obs <- spam.test$spam[,2] > 0.5
pred <- spam.pred.test[,2] > 0.5
cfmtest <- table(data.frame(pred, obs))

sensitivity <- cfmtest[1,1]/(cfmtest[1,1]+cfmtest[2.1])
specificity <- cfmtest[2,2]/(cfmtest[1,2]+cfmtest[2,2])
accuracy <- (cfmtest[1,1]+cfmtest[2,2])/(cfmtest[1,1]+cfmtest[1,2]+cfmtest[2,1]+cfmtest[2,2])

cfmtest
sensitivity
specificity
accuracy


