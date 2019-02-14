
# A simple implementation of logistic regression

The UCI Machine Learning Repository is an excellent source of interesting data sets for machine learning porpuses. Here, I will look at Census Income Dataset. Extraction of this dataset was done by Barry Becker from the 1994 Census database. The goal is to predict whether a person makes over $50k per year or not. I will use logistic regression to classify the output based on whether it is <$50K or >=$50K. This is a linear classification problem thus the logistic regression sounds a good choice for this job. To evaluate the model, I will use machine learning evaluation metrics (ROC, AUC).

The workflow will be as follows:

Preparation of the Data.
Implementing a logistic regression model (fitting)
predicting the probabilities and evaluating the model.
Let’s start by importing the libraries we will use in this work: tidyverse, Caret, ROCR (To get this packages, you might need to download it from this link and put it in the folder containing the R libraries.).
