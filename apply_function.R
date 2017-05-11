### apply line Function study

  ## apply()
   # input data type : vector, matrix
d <- matrix(1:9, ncol = 3)
d
apply(d, 1, sum) # 데이터 : d, 1 : row-calculation, apply function
apply(d, 2, sum) # 데이터 : d, 2 : column-calculation, apply function

apply(iris[, 1:4], 2, sum) # 아래 colSums()와 같은 연산을 수행함 
colSums(iris[, 1:4]) # 자주 쓰이는 colSums(), colMeans(), rowSums(), rowMeans() 함수가 있음

  ## lapply()
   # input data type : vector, list, data.frame, expression(표현식)
   # return type : list() 

result <- lapply(1:3, function(x){ x+2})
result
class(result)
unlist(result)
class(unlist(result))

(x <- list(a=1:3, b=4:6))
lapply(x, mean) # 리스트인 객체 a의 각 내부 값을 평균 냄 (원리가 궁금하면 x 변수의 형태를 확인)
lapply(iris[, 1:4], mean) # class : list
t(lapply(iris[, 1:4], mean)) # class : matrix ( t()함수가 matrix에서 활용되므로 결과는 matrix 타입)
colMeans(iris[, 1:4]) # lapply() 적용한 결과와 동일하지만 모양의 차이가 있어서 t() 함수로 묶어주면 동일

# input data type이 data.frame 이고, 결과를 data.frame으로 만들기
 #  (1) 결과값을 unlist()로 벡터로 만들기
 #  (2) matrix()를 이용해 벡터를 행렬(matrix)로 변환
 #  (3) as.data.frame()을 이용해 행렬을 data.frame으로 변환
 #  (4) names()로 결과값(data.frame)의 변수명을 지정

d <- as.data.frame(matrix(unlist(lapply(iris[, 1:4], mean)), ncol = 4, byrow = TRUE))
names(d) <- names(iris[, 1:4])
d

# *** 벡터는 한 가지 타입만 저장할 수 있으므로, unlist()후 matrix()변환과정에서 
# 하나의 데이터 타입으로 변환되므로 주의해야함 ***

# (1) 오류를 일으키는 경우
x <- list(data.frame(name = "foo", value = 1),
          data.frame(name = "bar", value = 2))
unlist(x)

# (2) 오류방지 하는 방법
x <- list(data.frame(name = "foo", value = 1),
          data.frame(name = "bar", value = 2))
do.call(rbind, x)

 # do.call() 이용하기
data.frame(do.call(cbind, lapply(iris[,1:4], mean)))

  ## sapply()
   # input data type : vector, list, data.frame, expression(표현식)
   # return type : vector(return value length : 1), matrix(return value length > 1), data.frame
lapply(iris[, 1:4], mean) # class : list
sapply(iris[, 1:4], mean) # class : numeric
as.data.frame(t(sapply(iris[, 1:4], mean))) # sapply() 결과를 data.frame으로 바꾸는 방법

sapply(iris[, 1:4], class) # 가끔 각 칼럼의 데이터 타입을 구하는데도 활용 가능

y <- sapply(iris[, 1:4], function(x){ x > 3})
class(y)
head(y)

# 주의할 사항은 벡터 또는 행렬은 한가지 데이터 타입만 가질 수 있으므로 데이터 타입이 섞여있으면 안됨
# 데이터에 여러 데이터 타입이 섞여있다면 리스트를 반환하는 lapply()나 plyr 패키지 활용 !


  ### tapply()
   # input data type : vector
   # return type : 
   # 그룹별로 함수를 적용하는 apply()

tapply(1:10, rep(1, 10), sum)
# 데이터가 1:10 까지 있고, rep(1, 10)은 1이 10번 반복됨 : 각 데이터에 1의 소속번호를 부여함
# 소속번호가 1인 데이터들의 sum을 구함
tapply(1:10, rep(c(1,2), 5), sum)
# 1:10 까지 차례로 1,2,1,2,1,2,1,2,1,2 소속 번호를 부여하여 각 부여번호(그룹) 별 함수(sum)을 구함
tapply(1:10, 1:10 %% 2 == 1, sum)
# 1:10 %% 2 == 1 의 반환값인 T/F로 구분하여 그룹별(홀수/짝수) 함수 결과를 출력( %% : 나머지 구하는 식 )
tapply(iris$Petal.Length, iris$Species, mean)





















