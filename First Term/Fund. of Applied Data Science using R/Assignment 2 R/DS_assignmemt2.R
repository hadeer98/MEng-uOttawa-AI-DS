churn_data <-read.csv("F:/Debi/uottawa/Fund. Data Science/Assignments/Assignment 2/Churn Dataset.csv", header =TRUE, sep =",")
dim(churn_data)

my_cols <- c("#00AFBB", "#E7B800")  
pairs(churn_data %>% select(6,19,20), pch = 19,  cex = 0.5,
      col = my_cols[factor(churn_data$Churn)] )
##########
install.packages('ggcorrplot')
library(reshape2)
library(ggplot2)
library(ggcorrplot)
library(sos)
findFn("select")
##########
measurePrecisionRecall <- function(actual_labels, predict){
  conMatrix = table(actual_labels, predict)
  precision <- conMatrix['0','0'] / ifelse(sum(conMatrix[,'0'])== 0, 1, sum(conMatrix[,'0']))
  recall <- conMatrix['0','0'] / ifelse(sum(conMatrix['0',])== 0, 1, sum(conMatrix['0',]))
  fmeasure <- 2 * precision * recall / ifelse(precision + recall == 0, 1, precision + recall)
  
  cat('precision:  ')
  cat(precision * 100)
  cat('%')
  cat('\n')
  
  cat('recall:     ')
  cat(recall * 100)
  cat('%')
  cat('\n')
  
  cat('f-measure:  ')
  cat(fmeasure * 100)
  cat('%')
  cat('\n')
}
#############
cormat <- round(cor(churn_data %>% select(6,19,20)),2)
head(cormat)
melted_cormat <- melt(cormat)
head(melted_cormat)


ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()

# Melt the correlation matrix
library(reshape2)
melted_cormat <- melt(cormat, na.rm = TRUE)
# Heatmap
library(ggplot2)
ggplot(data = melted_cormat, aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Churn Correlation") +
  theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1))+
  coord_fixed()
#dataframe
churn_data_dff=data.frame(churn_data)
#clean data
summary(churn_data)
churn_data_dff <- subset(churn_data_dff, !is.na(churn_data_dff$TotalCharges))
anyNA(churn_data_dff)
summary(churn_data_dff)
#Duplicated values
#'customerID'is the identifier for the churn. customerID should have all unique values
churn_data_dff <- subset(churn_data_dff, !duplicated(churn_data_dff$ customerID))
summary(churn_data_dff)

# to know unique values
for (x in colnames(churn_data_dff)) {
  if (sapply(churn_data_dff,class)[x] == "character"){
    print(unique(churn_data_dff[x]))
  }
}
install.packages("caTools")
library(ggcorrplot)

# Attributes that have 2 unique values
churn_data_dff$gender <- ifelse(as.character(churn_data_dff$gender) == "Female", 1, 0)
churn_data_dff$Partner <- ifelse(as.character(churn_data_dff$Partner) == "Yes", 1, 0)
churn_data_dff$Dependents <- ifelse(as.character(churn_data_dff$Dependents) == "Yes", 1, 0)
churn_data_dff$PhoneService <- ifelse(as.character(churn_data_dff$PhoneService) == "Yes", 1, 0)
churn_data_dff$PaperlessBilling <- ifelse(as.character(churn_data_dff$PaperlessBilling) == "Yes", 1, 0)
churn_data_dff$Churn <- ifelse(as.character(churn_data_dff$Churn) == "Yes", 1, 0)

# Attributes that have 3 and 4 unique values
churn_data_dff$MultipleLines <- as.numeric(factor(churn_data_dff$MultipleLines, levels= c("No phone service", "No", "Yes")))
churn_data_dff$InternetService <- as.numeric(factor(churn_data_dff$InternetService, levels= c("DSL", "Fiber optic", "No")))
churn_data_dff$OnlineSecurity <- as.numeric(factor(churn_data_dff$OnlineSecurity, levels= c("No internet service", "No", "Yes")))
churn_data_dff$OnlineBackup <- as.numeric(factor(churn_data_dff$OnlineBackup, levels= c("No internet service", "No", "Yes")))
churn_data_dff$DeviceProtection <- as.numeric(factor(churn_data_dff$DeviceProtection, levels= c("No internet service", "No", "Yes")))
churn_data_dff$TechSupport <- as.numeric(factor(churn_data_dff$TechSupport, levels= c("No internet service", "No", "Yes")))
churn_data_dff$StreamingTV <- as.numeric(factor(churn_data_dff$StreamingTV, levels= c("No internet service", "No", "Yes")))
churn_data_dff$StreamingMovies <- as.numeric(factor(churn_data_dff$StreamingMovies, levels= c("No internet service", "No", "Yes")))
churn_data_dff$Contract <- as.numeric(factor(churn_data_dff$Contract))
churn_data_dff$PaymentMethod <- as.numeric(factor(churn_data_dff$PaymentMethod))

summary(churn_data_dff)
#drop identifier column
churn_data_dff<-churn_data_dff[ , !(names(churn_data_dff) %in% "customerID")]
summary(churn_data_dff)
library(corrplot)
corrplot(cor(churn_data_dff),        # Correlation matrix
         method = "circle",                # Correlation plot method (method = number, circle, pie, or color)
         type = "full",                   # Correlation plot style (also "upper" and "lower")
         diag = TRUE,                     # If TRUE (default), adds the diagonal
         tl.col = "black",                # Labels color
         bg = "white",                    # Background color
         title = "",                      # Main title
         col = NULL,                      # Color palette
         tl.cex =0.7,
         cl.ratio =0.2)

#calculate correlation
library(ggcorrplot)
corr <- round(cor(churn_data_dff),3)
p.mat <- cor_pmat(churn_data_dff)
# Barring the no significant coefficient
ggcorrplot(corr, hc.order = TRUE,
           type = "lower", p.mat = p.mat)

#3a)split train-test samples
summary(churn_data_dff)
library(caTools)

help(sample.split)
set.seed(42)
sample_data = sample.split(churn_data_dff$Churn, SplitRatio = 0.8)
train_data <- subset(churn_data_dff, sample_data == TRUE)
test_data <- subset(churn_data_dff, sample_data == FALSE)

X_train<-train_data[,-20]
y_train<-train_data[,20]
X_test<-test_data[,-20]
y_test<-test_data[,20]

#3b) build a descession tree
install.packages("tibble")
install.packages("rpart")
library(caTools)
library(party)
library(dplyr)
library(magrittr)
library(rpart)

install.packages("cvms")

install.packages("rpart.plot")
library(cvms)
library(tibble)   # tibble()
library(rpart.plot)
install.packages('caret')
library(caret)
library(ggimage)
library(rsvg)
tree <- rpart(Churn ~., data = train_data,method  = 'class')
rpart.plot(tree)
predict_unseen <-predict(tree, test_data, type = 'class')
d_binomial <- tibble("target" = test_data$Churn,
                     "prediction" = predict_unseen)
basic_table <- table(d_binomial)
basic_table
cfm <- as_tibble(basic_table)
cfm
plot_confusion_matrix(cfm, 
                      target_col = "target", 
                      prediction_col = "prediction",
                      counts_col = "n")
summary(tree)
confusionMatrix(data=predict_unseen, reference = as.factor(test_data$Churn))
#ROC
library(pROC)
roc(test_data$Churn,as.numeric(predict_unseen))
#Plot Roc Graph
plot(roc(test_data$Churn,as.numeric(predict_unseen)), col = 1, lty = 2, main = "ROC")
measurePrecisionRecall(test_data$Churn,predict_unseen)

#4)
#build decision tree using gini index
gini_tree <- rpart(Churn ~., data = train_data,method  = 'class',parms = list(split = "gini"))
rpart.plot(gini_tree,main = "Gini Index")
predict_gini_tree <-predict(gini_tree, test_data, type = 'class')
d_binomial_gini_tree <- tibble("target" = test_data$Churn,
                     "prediction" = predict_gini_tree)
basic_table_gini_tree <- table(d_binomial_gini_tree)
basic_table_gini_tree
cfm_basic_table_gini_tree <- as_tibble(basic_table_gini_tree)
cfm_basic_table_gini_tree
plot_confusion_matrix(cfm_basic_table_gini_tree, 
                      target_col = "target", 
                      prediction_col = "prediction",
                      counts_col = "n")
summary(gini_tree)
confusionMatrix(data=predict_gini_tree, reference = as.factor(test_data$Churn))
measurePrecisionRecall(test_data$Churn,predict_gini_tree)
# build decision tree using information entropy
information_tree <- rpart(Churn ~., data = train_data,method  = 'class',parms = list(split = "information"))
rpart.plot(information_tree,main = "Information Entropy")
predict_information_tree <-predict(information_tree, test_data, type = 'class')
d_binomial_information_tree <- tibble("target" = test_data$Churn,
                               "prediction" = predict_information_tree)
basic_table_information_tree <- table(d_binomial_information_tree)
basic_table_information_tree
cfm_basic_table_information_tree <- as_tibble(basic_table_information_tree)
cfm_basic_table_information_tree
plot_confusion_matrix(cfm_basic_table_information_tree, 
                      target_col = "target", 
                      prediction_col = "prediction",
                      counts_col = "n")
summary(information_tree)
confusionMatrix(data=predict_information_tree, reference = as.factor(test_data$Churn))
measurePrecisionRecall(test_data$Churn,predict_gini_tree)
#4b) pruning
printcp(tree)
plotcp(tree)
#Postpruning
# Prune the tree model based on the optimal cp value
tree_model_pruned <- prune(tree, cp = 0.027 )
rpart.plot(tree_model_pruned,main = "Pruning")
# Compute the accuracy of the pruned tree
predict_pruning <- predict(tree_model_pruned, test_data, type = "class")
d_binomial_pp <- tibble("target" = test_data$Churn,
                                      "prediction" = predict_pruning)
basic_table_pp <- table(d_binomial_pp)
basic_table_pp
cfm_basic_table_pp <- as_tibble(basic_table_pp)
cfm_basic_table_pp
plot_confusion_matrix(cfm_basic_table_pp, 
                      target_col = "target", 
                      prediction_col = "prediction",
                      counts_col = "n")
summary(predict_pruning)
confusionMatrix(data=predict_pruning, reference = as.factor(test_data$Churn))
measurePrecisionRecall(test_data$Churn,predict_pruning)
#5)XGboost

library(xgboost)
xgboost_train = xgb.DMatrix(data=data.matrix(X_train), label=y_train)
xgboost_test = xgb.DMatrix(data=data.matrix(X_test), label=y_test)
#define watchlist
watchlist = list(train=xgboost_train, test=xgboost_test)


xgb = xgb.train(data = xgboost_train, max.depth = 3, watchlist=watchlist, nrounds = 70)
#From the output we can see that the minimum testing
#RMSE is achieved at 16 rounds. 
#Beyond this point, the test RMSE actually begins to increase, 
#which is a sign that we’re overfitting the training data.
#define final model
final = xgboost(data = xgboost_train, max.depth = 3, nrounds = 16, verbose = 0)
final
pred_test = predict(final, xgboost_test)

pred_test

prediction_xgb <- as.numeric(pred_test > 0.5)
prediction_xgb

d_binomial_xg <- tibble("target" = test_data$Churn,
                        "prediction" = prediction_xgb)
basic_table_xg <- table(d_binomial_xg)
basic_table_xg
cfm_basic_table_xg <- as_tibble(basic_table_xg)
cfm_basic_table_xg
plot_confusion_matrix(cfm_basic_table_xg, 
                      target_col = "target", 
                      prediction_col = "prediction",
                      counts_col = "n")
confusionMatrix(data=as.factor(prediction_xgb), reference = as.factor(test_data$Churn))
roc(test_data$Churn,as.numeric(prediction_xgb))
#Plot Roc Graph
plot(roc(test_data$Churn,as.numeric(prediction_xgb)), col = 1, lty = 2, main = "ROC")
measurePrecisionRecall(test_data$Churn,prediction_xgb)
#deep neural network using Keras with 3 dense layers
install.packages("devtools")
devtools::install_github("rstudio/keras")
devtools::install_github("rstudio/reticulate")
install.packages("keras")
install.packages("tensorflow")
library(tensorflow)
library(keras)
reticulate::use_python("C:/Users/saiko/AppData/Local/r-miniconda/envs/r-reticulate/python.exe")
install_tensorflow()
install_tensorflow(gpu=TRUE)
deep_train = as.matrix(train_data)
deep_test = as.matrix(test_data)
dimnames(deep_train) = NULL
model <- keras_model_sequential()

model %>%
  layer_dense(units = 19, activation = 'relu', input_shape = 19) %>% 
  layer_dropout(rate = 0.1) %>% 
  layer_dense(units = 10, activation = 'relu') %>%
  layer_dropout(rate = 0.1) %>%
  layer_dense(units = 1, activation = 'sigmoid')
#----------
model %>%
  layer_dense(units = 19, activation = 'tanh', input_shape = 19) %>% 
  layer_dropout(rate = 0.1) %>% 
  layer_dense(units = 10, activation = 'tanh') %>%
  layer_dropout(rate = 0.1) %>%
  layer_dense(units = 1, activation = 'sigmoid')
model %>% compile(
  loss      = 'mean_squared_error',
  optimizer = 'adam',
  metrics = c('accuracy')
)
history = fit(model,data.matrix(train_data[,1:19]), train_data$Churn, epochs = 50, 
              batch_size = 128)
plot(history)
pred_data = predict(model, data.matrix(test_data[,1:19]))
pred_data[pred_data>=.5] = 1
pred_data[pred_data<.5] = 0
confusionMatrix(data=as.factor(pred_data), reference = as.factor(test_data$Churn))
d_binomial_dnn <- tibble("target" = test_data$Churn,
                     "prediction" = pred_data)
basic_table_dnn <- table(d_binomial_dnn)
basic_table_dnn
cfm_dnn <- as_tibble(basic_table_dnn)
cfm_dnn
plot_confusion_matrix(cfm_dnn, 
                      target_col = "target", 
                      prediction_col = "prediction",
                      counts_col = "n")
roc(test_data$Churn,as.numeric(pred_data))
#Plot Roc Graph
plot(roc(test_data$Churn,as.numeric(pred_data)), col = 1, lty = 2, main = "ROC")
measurePrecisionRecall(test_data$Churn,pred_data)


#part 2
install.packages("arules")
library(arules)
#library(arulesViz)
transactions <- read.transactions("F:/Debi/uottawa/Fund. Data Science/Assignments/Assignment 2/transactions.csv"
                                  ,format = "basket", sep = ",")
itemFrequencyPlot(transactions, topN = 10)


transactionRules_1 <- apriori(transactions, parameter = list(support =0.002, confidence =0.20, maxlen= 3))
transactionRules_1 <- sort(transactionRules_1, by = "lift",decreasing = TRUE )
inspect(transactionRules_1)
max_1 = transactionRules_1[1]
inspect(max_1)


transactionRules_2 <- apriori(transactions, parameter = list(support =0.002, confidence =0.20, maxlen= 2))
transactionRules_2 <- sort(transactionRules_2, by = "lift",decreasing = TRUE )
inspect(transactionRules_2)
max_2 = transactionRules_2[1]
inspect(max_2)















