

## Preparing The Data

# 1) Import the data
library(tidyverse)


# setting the working directory
# make sure to change the path to your local directory for path_loc
path_loc <- "/Users/hossein/complain"
setwd(path_loc)


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
#df$yearsalary <- as.numeric(df$yearsalary)
#df$yearsalary <- factor(df$yearsalary)

#df <- df %>% mutate_if(is.numeric, as.factor)

# df2 <- df[ ,!(colnames(df) == "Complaint ID")]
# changing SeniorCitizen variable to factor
# df$SeniorCitizen <- as.factor(df$SeniorCitizen)

# looking for missing values
#df %>% map(~ sum(is.na(.)))

#df[df == "N/A"]  <- NA
#df <- df[which( complete.cases(df)) ,]

#df2$Product <- fct_explicit_na(df2[c(2)], na_level = "(Missing)")
#df2[c(2:3)]
# imputing with the median
#df <- df %>% 
#  mutate(year-salary = replace(year-salary,
#                                is.na(TotalCharges),
#                                median(TotalCharges, na.rm = T)))


# removing customerID; doesn't add any value to the model
#df <- df %>% select(-"Complaint ID")
#df <- drop_na(df)

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
contrasts(df$yearsalary)  # Yes = 1, No = 0

# converting probabilities to "Yes" and "No" 
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




