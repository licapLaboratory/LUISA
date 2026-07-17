library(MXM)
library(ppcor)
library(corpcor)
library(qgraph)
library(sbfc)
library(readxl)
library(mlbench)
library(bnlearn)

# Set Working Directory
setwd("C:/Users/walis/Dropbox/Doutorado/Causal Discovery/Feature Selection Big data and so on/Bases Tese")

# Read the dataset. In this case, divorce dataset avaliable at
# https://archive.ics.uci.edu/dataset/539/divorce+predictors+data+set
dataSet <- read_excel("divorce.xlsx")

#Prepare the dataset
dataSet = as.data.frame(dataSet)
for(n in 1:ncol(dataSet)){
  dataSet[,n] = as.integer(unlist(dataSet[,n]))
}


#set the target of the dataset
target = 55
nom_target = colnames(dataSet)[target]


#Fisrt stage of LUISA. Learn of PC (Parents and Children) of a target using MMPC Algorithm
PC=MMPC(dataSet[,target], dataSet[,-target], max_k = 3, 
        threshold = 0.05, test = "auto", ini = NULL, 
        wei = NULL, user_test = NULL, hash = FALSE, 
        hashObject = NULL, 
        ncores = 3, backward = TRUE)
sf = PC@selectedVarsOrder


#Second stage of LUISA. Discovery of the parents of the target’s parents (indirect ancestors), children
#of the target’s children (indirect descendants). Also using MMPC. 
for (n in 1:length(PC@selectedVarsOrder)){
  temp=MXM::MMPC(dataSet[,PC@selectedVarsOrder[n]], 
                 dataSet[,-c(PC@selectedVarsOrder[n],target)], max_k = 3, 
                 threshold = 0.05, test = "indpois", ini = NULL, 
                 wei = NULL, user_test = NULL, hash = FALSE, 
                 hashObject = NULL, 
                 ncores = 3, backward = TRUE)
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
    
    if (abs(x$estimate) > 0.2 & (x$p.value<0.05))
      {
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

# Learning DAG
dag_mmhc <- mmhc(reducedDataset)

graphviz.plot(dag_mmhc, main="MMHC")
