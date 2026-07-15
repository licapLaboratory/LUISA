library(MXMLUISA3)
library(MMPCLUISA3)
library(ppcor)
library(corpcor)
library(qgraph)
library(sbfc)
library(readxl)
library(mlbench)
library(bnlearn)

################################


# R Implementation of MMPC algorithm
# as described in the paper "The max-min hill-climbing Bayesian network structure learning algorithm". Machine learning, 65(1), 31-78, 2006
# by Tsamardinos, Brown and Aliferis
# R Implementation by Giorgos Athineou (2013-2014)
# VERSION: 17/3/2014
# INPUTS
# target : the class variable , provide either a vector, an 1D matrix, an 1D array (same length with the data rows), a factor
# or a formula. The data can be either continuous data in R, values within (0,1), binary [0,1], nominal or ordinal data.
# dataset : tha dataset , provide a data frame (columns = variables , rows = samples) or a matrix or an ExpressionSet.
# max_k : the maximum conditioning set which is used in the current conditional indepedence test used.
# threshold : the significance threshold ( must be in (0,1) ) for testing the null hypothesis of the generated pvalues.
# test : the conditional independence test we are going to use. the available conditional independence tests so far in this
# implementation are:
#   "testIndFisher" : Fisher conditional independence test for continous targets (or proportions) and continuous predictors only
#   "testIndSpearman" : Fisher conditional independence test for continous targets (or proportions) and continuous predictors only (Spearman correlation is calculated first)
#   "testIndReg" : Conditional independence test based on regression for continous targets (or proportions) and mixed predictors using the F test
#   "testIndRQ" : Conditional Independence Test based on quantile (median) regression for numerical class variables and mixed predictors (F test)
#   "testIndLogistic" : Conditional Independence Test based on logistic regression for binary,categorical or ordinal class variables and mixed predictors
#   "testIndPois" : Conditional Independence Test based on Poisson regression for discrete class variables and mixed predictors (log-likelihood ratio test)
#   "testIndZIP" : Conditional Independence Test based on zero inflated poisson regression for discrete class variables and mixed predictors (log-likelihood ratio test)
#   "testIndNB" : Conditional Independence Test based on negative binomial regression for discrete class variables and mixed predictors (log-likelihood ratio test)
#   "testIndBeta" : Conditional Independence Test based on beta regression for proportions and mixed predictors (log likelihood ratio test)
#   "testIndMVreg" : Conditional Independence Test based on mu;ltivariate linear regression for Euclidean data and mixed predictors (log likelihood ratio test)
#   "gSquare" : Conditional Independence test based on the G test of independence (log likelihood ratio  test)
#   "censIndCR" : Conditional independence test for survival data based on the Log likelihood ratio test with mixed predictors (Cox regression)
# user_test : the user defined conditional independence test ( provide a closure type object )
# hash : a boolean variable whuch indicates whether (TRUE) or not (FALSE) to use the hash-based implementation of the statistics of MMPC.
# hashObject : a List with the hash objects (hash package) on which we have cached the generated statistics.
#              MMPC requires this Object for the hash-based implementation of the statistics. This hashObject is produced or
# updated by each run  of MMPC (if hash == TRUE) and it can be reused in next runs of MMPC.
# there are default values for all of the parameters of the algorithm.
# OUTPUT <LIST>
# The output of the algorithm is a LIST with the following quantities (14) :
# selectedVars : the selected variables i.e. the dependent of the target variables.
# selectedVarsOrder : the increasing order of the selected variables due to their pvalues
# hashObject : the hashObject with the cached statistic results of the current run.
# pvalues : the pvalues of all of the variables.
# stats : the stats of all of the variables.
# data : the dataset used in the current run.
# target : the class variable used in the current run.
# test : the conditional independence test used in the current run.
# max_k : the max_k option used in the current run.
# threshold : the threshold option used in the current run.
# runtime : the run time of the algorithm.
# Conditional independence test arguments have to be in this exact fixed order :
# target(target variable), data(dataset), xIndex(x index), csIndex(cs index),
# univariateModels(cached statistics for the univariate indepence test), hash(hash booleab), stat_hash(hash object),
# example: test(target, data, xIndex, csIndex, univariateModels=NULL, hash=FALSE, stat_hash=NULL, pvalue_hash=NULL)
# output of each test: LIST of the generated pvalue, stat and the updated hash objects.

#MMPC <- function(target, dataset, max_k = 3, threshold = 0.05,
#                 test = NULL, ini = NULL, wei = NULL, user_test = NULL,
#                 hash = FALSE, hashObject = NULL, ncores = 1, backward = FALSE)



#---------------------------------LUISA USES MMPC -----------------


# Set Working Directory
setwd("C:/Users/zarat/Downloads")
#setwd("C:/VAIO/Licap/Artigos Congressos/Artigos Journais Submetidos/Journal IJDSA - Walisson/LUISA_R")
#Read the dataset. In this case, divorce dataset avaliable at
dataSet <- read_excel("divorcio1.xlsx") 
#testIndPois

#dataSet <- read_excel("statlog_heart.xlsx") 
#testIndPois





#Preparing the dataset
dataSet = as.data.frame(dataSet)
for(n in 1:ncol(dataSet)){
  dataSet[,n] = as.integer(unlist(dataSet[,n]))
}

#set the target of the dataset

#Divorce
target = 55 
#heart
#target = 14


nom_target = colnames(dataSet)[target]


#Fisrt stage of LUISA. Learn of PC (Parents and Children) of a target using MMPC Algorithm
PC = MMPC(dataSet[,target], dataSet[,-target], max_k = 3, threshold = 0.05,
           test = "testIndPois", ini = NULL, wei = NULL, user_test = NULL,
           hash = FALSE, hashObject = NULL, ncores = 3, backward = TRUE)


sf = PC@selectedVarsOrder

#Second stage of LUISA. Discovery of the parents of the target’s parents (indirect ancestors), children
#of the target’s children (indirect descendants). Also using MMPC.
for (n in 1:length(PC@selectedVarsOrder)){
  temp=MMPC(dataSet[,PC@selectedVarsOrder[n]], dataSet[,-c(PC@selectedVarsOrder[n],target)], max_k = 3,
                 threshold = 0.05, test = "testIndPois", ini = NULL, wei = NULL, user_test = NULL, hash = FALSE,
                 hashObject = NULL, ncores = 3, backward = TRUE)
  sf = c(sf,temp@selectedVars)
}


sf = c(sf,target)
vetlocal <- sf[!duplicated(sf)]
tempDataSet=dataSet[,c(vetlocal)]
sff=c()
ntar = which( colnames(tempDataSet)==nom_target )
y=ncol(tempDataSet)-1



#Third stage of LUISA. Removal of false positive attributes according to partial correlation,
#Equation 7 of the article.
for (n in 1:y){
  x = pcor.test(tempDataSet[,n],tempDataSet[,ntar],tempDataSet[,-c(n,ntar)],
                method = "kendall")
  if (is.na(x$estimate)){
    print(n)
  }


  if (!is.na(x$estimate) & !is.na(x$p.value) &
      !is.na(x$statistic)){

    if (abs(x$statistic)>qt(0.95,ncol(tempDataSet))
        & abs(x$estimate) > 0.2 & (x$p.value<0.05)
    ){

      print(n)
      print(x$p.value)
      print(x$estimate)
      print(x$statistic)
      sff = c(sff,n)
    }
  }
}

reducedDataset = tempDataSet[,c(sff, ntar)]
colnames(reducedDataset)[ncol(reducedDataset)] <- "Target"

reducedDataset[] <- lapply(reducedDataset, factor, ordered = TRUE)


