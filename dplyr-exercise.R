# install packages
  # install.packages("dplyr")
  # install.packages('hflights')

# Load Library
library(dplyr)
library(hflights)

dim(hflights)
hflights_df <- tbl_df(hflights)  

 # filter 함수
# 조건에 따라(Month가 1 또는 2) 데이터 행 추출 (subset()함수와 비슷)
filter(hflights_df, Month == 1 | Month == 2)
filter(hflights_df, Month == 1 , DayofMonth == 1)

 # arrange 함수
# 지정한 열 기준으로 작은값 부터 큰 값 순으로 데이터 정렬 (역순을 원할 땐, desc() 함께 사용)
arrange(hflights_df, ArrDelay, Month, Year) # ArrDelay, Month, Year 순으로 정렬)
arrange(hflights_df, desc(Month)) # Month의 큰 값부터 작은 값으로 정렬

 # select 함수
# 열을 추출할 때 사용, 복수 열을 추출할 때에는 콤마(,)로 구분하고, 인접한 열은 (:) 연산자로 이용하여 추출
select(hflights_df, Year, Month, DayofMonth)
select(hflights_df, -(Year:DayOfWeek)) # Year부터 DayOfWeek를 제외한 나머지 열 추출

 # mutate 함수
# 열을 추가할 때 사용(transform() 함수와 비슷)
mutate(hflights_df, gain = ArrDelay - DepDelay, gain_per_hour = gain/(AirTime/60))
 # mutate 함수에서 생성한 열인 gain을 바로 다음 gain_per_hour에서 바로 사용할 수 있음
 # transform 함수에서는 위와 같은 동시활동(계산)을 사용할 수 없음)

 # summarise 함수
# mean(), sd(), var(), median() 등의 함수를 지정하여 기초 통계량을 구할 수 있음, 결과값은 data.frame형식으로 출력
summarise(hflights_df, delay = mean(DepDelay, na.rm = TRUE))
summarise(hflights_df, plane = n_distinct(TailNum)) # n_distinct 함수는 열(변수)의 유니크 값의 수를 산출
hflights_df %>% group_by(FlightNum, Dest) %>% summarise(n = n()) # n()은 관측값의 갯수를 구해줌(group_by와 함꼐 쓰일 떄 유용함)
summarise(hflights_df, first = first(DepTime)) # first() 함수는 해당 열(변수)의 첫번째 값을 산출
summarise(hflights_df, last = last(DepTime)) # last() 함수는 해당 열(변수)의 마지막 행 값을 산출
summarise(hflights_df, data = nth(DepTime, 10)) # nth(x, n) 함수는 원하는 행의 해당 열(변수 : x)의 값을 산출


# group_by 함수
# 지정한 열의 수준(Level)별로 그룹화된 결과를 얻을 수 있음

#아래 코드는 비행편수 20편 이상, 평군 비행거리 2,000마일 이상인 항공사별 평균 연착시간을 계산하여 그림으로 표현
planes <- group_by(hflights_df, TailNum) 
delay <- summarise(planes, count = n(), dist = mean(Distance, na.rm = TeRUE), delay = mean(ArrDelay, na.rm = TRUE))
delay <- filter(delay, count > 20, dist < 2000)
library(ggplot2)
ggplot(delay, aes(dist, delay))+geom_point(aes(size = count), alpha = 1/2)+geom_smooth()+scale_size_area()
#group_by의 많은 예제는 
vignette("introduction", package = 'dplyr') # package 간단히 공부할때는 도움이 많이 될 듯 !! (vignette : 삽화) 

 # chain 함수 : 코드를 줄일 수 있는 획기적인 방법 또한 코드도 직관적으로 이해할 수 있음
# (1)
# hflight 데이터를 a1) Year, Month, DayofMonth의 수준별로 그룹화, a2) Year부터 DayofMonth, ArrDelay, DepDelay열을 선택,
# a3) 평균 연착시간과 평균 출발 지연시간을 구하고, a4) 평균 연착시간과 평균 출발지연시간이 30분 이상인 데이터를 추출한
# 결과
a1 <- group_by(hflights_df, Year, Month, DayofMonth)
a2 <- select(a1, Year:DayofMonth, ArrDelay, DepDelay)
a3 <- summarise(a2, arr = mean(ArrDelay, na.rm = TRUE), dep = mean(DepDelay, na.rm = TRUE))
a4 <- filter(a3, arr > 30 | dep > 30)

# (2)
#위 예제를 " %>% " 를 이용하면 코드가 아래와 같이 단순해짐
hflights_df %>% group_by(Year, Month, DayofMonth) %>% summarise(arr = mean(ArrDelay, na.rm = TRUE), dep = mean(DepDelay, na.rm = TRUE)) %>% filter(arr > 30 | dep > 30)

# (3)
# 위 예제 3번째 표현식 : 데이터 input 자리에 함수를 이용해 데이터를 자동 입력
filter(
  summarise(
    select(
      group_by(hflights_df, Year, Month, DayofMonth),
      Year:DayofMonth, ArrDelay, DepDelay
      ),
    arr = mean(ArrDelay, na.rm = TRUE), dep = mean(DepDelay, na.rm = TRUE)
  ), arr > 30 | dep > 30
)




 # distinct 함수
#데이터의 유니크한 변수들을 찾아줌 (unique() 함수와 유사함)
distinct(hflights_df, Year, DepDelay)

 # sample_n / sample_frac 함수
sample_n(hflights_df, 10) # 10개의 행을 랜덤해서 추출
sample_frac(hflights_df, 0.01) # 전체 행에서 0.01 (1%) 비율로 데이터(행)를 추출

 # 예제 (* 주의 *)
# 이 예제의 각 결과들을 보면 처음에 3개의 변수(Year, Month, DayofMonth)를 기준으로 group설정 후, summarise 함수는 
# 하나의 수준씩 그룹에서 제외시켜 결과를 산출 
# per_month는 DayofMonth의 변수가 제외되어 결과가 산출
# per_year는 Month 변수가 벗겨져(peel off) 결과를 산출
daily <- group_by(hflights_df, Year, Month, DayofMonth)
per_day <- summarise(daily, flights = n())
per_month <- summarise(per_day, flights = sum(flights))
per_year <- summarise(per_month, flights = sum(flights))





