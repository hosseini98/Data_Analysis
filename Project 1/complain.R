

## Preparing The Data

# 1) Import the data
library(tidyverse)

# reading in the data
df <- read_csv("adult.csv")
#colnames(df) = df[1, ] # the first row will be the header
#df = df[-1, ]          # removing the first row.
library(data.table)
setnames(df, c('age','workclass', 'fnlwgt','education', 'educationnum', 'maritalstatus','occupation', 'relationship', 'race','sex', 'capitalgain', 'capitalloss' ,  'hoursperweek', 'nativecountry', 'yearsalary'))
#df <- ifelse('year-salary'==">50K", 1, 0)
# 2) Take a quick look

# dimensions of the data
dim_desc(df)




# names of the data
names(df)


# taking a look at the data
glimpse(df)


# 3) Clean the data

# changing character variables to factors
df <- df %>% mutate_if(is.character, as.factor)

# removing Complaint ID; doesn't add any value to the model
df <- df %>% select(-"Complaint ID")

# 4) Split the data
#install.packages("caret")
library(caret)

# selecting random seed to reproduce results
set.seed(5)
#df16 <- df[c(16)]
# sampling 75% of the rows
inTrain <- createDataPartition(y = df$yearsalary, p=0.75, list=FALSE)

# train/test split; 75%/25%
train <- df[inTrain,]
test <- df[-inTrain,]



## Fitting The Model
fit <- glm(yearsalary~., data=train, family=binomial)



## Making Predictions
yearsalary.probs <- predict(fit, test, type="response")
head(yearsalary.probs)

# Looking at the response encoding
contrasts(df$yearsalary)  # >50K = 1, <=50K = 0

# converting probabilities to ">50K" and "<=50K" 
glm.pred = rep("<=50K", length(yearsalary.probs))
glm.pred[yearsalary.probs > 0.5] = ">50K"
glm.pred <- as.factor(glm.pred)



## Evaluating The Model
# creating a confusion matrix
confusionMatrix(glm.pred, test$yearsalary, positive = ">50K")


library(ROCR)
# need to create prediction object from ROCR
pr <- prediction(yearsalary.probs, test$yearsalary)

# plotting ROC curve
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

# AUC value
auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc




