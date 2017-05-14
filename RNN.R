 # install.package
# install.packages("rnn")

 # Library
library(rnn)
rm(list=ls())

set.seed(10)
f <- 5
w <- 2*pi*f
# Create sequences
t <- seq(0.005, 2, by = 0.005)
x <- sin(t*w)
y <- cos(t*w)
# Samples of 20 times series
X <- matrix(x, nrow = 40)
Y <- matrix(y, nrow = 40)
# Plot noisy waves
plot(as.vector(X), col = "blue", type = "l", ylab = "X,Y", main = "Noisy waves")
lines(as.vector(Y), col = "red")
legend("topright", c("X", "Y"), col = c("blue", "red"), lty = c(1,1), lwd = c(1,1))

# Standardize in the interval 0 - 1
X <- (X-min(X)) / (max(X)-min(X))
Y <- (Y-min(Y)) / (max(Y)-min(Y))
 # scale()는　(x-mean(x))/sd(x) 를　의미함
# Transpose
X <- t(X)
Y <- t(Y)
# Training-testing sets
train <- 1:8
test <- 9:10

# Train model. Keep out the last two sequences.
model <- trainr(Y = Y[train,],
                X = X[train,],
                learningrate = 0.05,
                hidden_dim = 16,
                numepochs = 500)

# Predicted values
Yp <- predictr(model, X)

# Plot Predicted vs acutal. Training set + testing set
plot(as.vector(t(Y)), col = 'red', type = 'l', main = 'Actual vs Predicted', ylab = "Y.Yp")
lines(as.vector(t(Yp)), type = 'l', col = 'blue')
# Plot predicted vs actual. Testing set only.
plot(as.vector(t(Y[test,])), col = 'red', type = 'l', main = "Actual vs Predicted : testing set", ylab = "Y, Yp")
lines(as.vector(t(Yp[test,])), type = 'l', col = 'blue')


####################### vignette('rnn') ###################################
library(rnn)
set.seed(1)
help('trainr')

# Create sample iuputs
X1 <- sample(0:127, 5000, replace = TRUE) # replace = TRUE : 복원추출가능 , class : integer
X2 <- sample(0:127, 5000, replace = TRUE) # class : integer

# Create sample output
Y <- X1 + X2

# Convert to binary
X1 <- int2bin(X1)
X2 <- int2bin(X2)
Y <- int2bin(Y)

# Create 3d array : dim 1 : samples; dim 2 : time ; dim 3 : variables.
X <- array(c(X1, X2), dim = c(dim(X1), 2))
Y <- array(Y, dim = c(dim(Y),1))

# Train model
model <- trainr(Y = Y[,dim(Y)[2]:1,,drop = F],
                X = X[,dim(X)[2]:1,,drop = F],
                learningrate = 0.1,
                hidden_dim = 10,
                batch_size = 100,
                numepochs = 10)

plot(colMeans(model$error), type = 'l', xlab = 'epoch', ylab = 'errors')

# Create test inputs
A1 <- int2bin(sample(0:127, 7000, replace = TRUE))
A2 <- int2bin(sample(0:127, 7000, replace = TRUE))

# Create 3d array dim 1 : samples; dim 2 : time ; dim 3 : variables
A <- array(c(A1, A2), dim = c(dim(A1), 2))

# Predict
B <- predictr(model,
              A[,dim(A)[2]:1,,drop = F])

# Convert back to integers
A1 <- bin2int(A1)
A2 <- bin2int(A2)
B <- bin2int(B)

# Plot the difference
hist(B-(A1+A2))

                  ############# application neural network data to RNN ##################



x1 <- t(scale(x_AAPL[3]))
x2 <- t(scale(x_AAPL[4]))
x3 <- t(scale(x_AAPL[5]))
x4 <- t(scale(x_AAPL[6]))


x <- array(c(x1,x2,x3,x4), dim = c(dim(x1), 4))
y <- array(t(scale(x_AAPL[2])), dim = dim(x1))

x_train <- 1:180
x_test <- 181:204

x_model <- trainr(Y = y[,x_train, drop = F],
                  X = x[,x_train,, drop = F],
                  learningrate = 0.1,
                  hidden_dim = 10,
                  batch_size = 1,
                  numepochs = 500)

x_predict <- predictr(x_model, x[,x_test,, drop = F])


plot(as.vector(t(y[,x_test])), col = 'red', type = 'l', main = 'Actual vs Predicted')
lines(as.vector(x_predict), type = 'l', col = 'blue' )

plot(as.vector(x_model$error), type = 'l', col = 'red')
























