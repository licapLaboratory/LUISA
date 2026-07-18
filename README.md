Supplementary Material

Title: Feature Selection based on the causality relation and extension of the parental relationship. Proposal of the LUISA algorithm

Submitted Journal: International Journal of Data Science and Analytics, Springer

Authors: Walisson Ferreira de Carvalho, Beethoven M. Andrade, Luis Enrique Zárate

Abstract: Non-causal feature selection methods may introduce errors in assessing feature relevance because they rely on a single selection criterion, which can lead to spurious correlations. The current causality methods of feature selection consider only the features that compose the Markov Blanket of one target variable (class) as relevant. That may lead to the disregard of other relevant features. We present a new algorithm, LUISA, based on causal relationships. This algorithm expands the Markov Blanket to include indirect ancestors for a specific target variable or class. We test the algorithm on five perspectives using synthetic and real-world datasets. The experiments show that LUISA is representative and that it performs satisfactorily under uncertainty.
In addition, the learning models demonstrated promising results when using the reduced dataset compared to the complete dataset and various feature non-causal and causal selection methods.

--------------------------------------------------------------
Real-world datasets:

Breast Cancer: breast_cancer_wisconsin.zip

Heart: statlog_heart.zip

Hepatitis: hepatitis3.zip

Divorce: divorcio1.zip

Sepsi: sepsi.zip

Important: The datasets were obtained from the UCI repository: https://archive.ics.uci.edu/ml/data sets/Divorce+Predictors+data+set

Some datasets require preprocessing—for example, by removing columns that identify the instance ID and imputing values ​​for missing data (such as mean imputation or removing records containing missing data).Some datasets require preprocessing—for example, by removing columns that identify the instance ID and imputing values ​​for missing data (such as mean imputation or removing records containing missing data).

--------------------------------------------------------------
LUISA Algorithm
    
    Authors: Walisson Ferreira de Carvalho, Beethoven M. Andrade, Luis Enrique Zárate
    Contact: walissoncarvalho@pucminas.br; zarate@pucminas.br; 

Option 1:

    LUISA is available in: LUISA_V1.R
    
    LUISA uses a package available in: https://cran.r-project.org/src/contrib/Archive/MXM/

    or via Download: MXM_1.5.5.tar.gz
    
    This package must be installed in RStudio

Option 2:    

    LUISA can use MMPC.R available at: https://github.com/cran/MXM/blob/master/R/MMPC.R

    R Implementation of MMPC algorithm as described in the paper "The max-min hill-climbing Bayesian network structure learning algorithm". Machine learning, 65(1), 31-78, 2006 by Tsamardinos, Brown and Aliferis R Implementation by Giorgos Athineou (2013-2014) VERSION: 17/3/2014

    LUISA can uses MXM available at: https://github.com/cran/MXM/tree/master

    Package: MXM. Title: Feature Selection (Including Multiple Solutions) and Bayesian Networks. Version: 1.5.5. URL: http://mensxmachina.org. Date: 2022-08-24
    Author: Konstantina Biza, Ioannis Tsamardinos, Vincenzo Lagani, Giorgos Athineou, Michail Tsagris, Giorgos Borboudakis, Anna Roumpelaki 

    FOR OPTION 2: LUISA is available in: LUISA_ALL.zip

(Observation: MMPC, MXM, and Datasets must be in the same path)

--------------------------------------------------------------
Parameters for Real-world datasets:

Breast Cancer: Conditional Independence Test = testIndPois

Heart: Conditional Independence Test = testIndPois

Hepatitis: Conditional Independence Test = testIndLogistic

Divorce: Conditional Independence Test = testIndLogistic

OBS: It is possible to use the "auto" option. In this case, MMPC searches for the better test option.

For all datasets: The partial correlation coefficient is 0.2 (set in LUISA); the level of significance is 5% (set in LUISA)


--------------------------------------------------------------
Learning models with complete dataset and application of the non-causal filters
KNIME Analytics Platform

Workflow: Causalidade_Luisa.knwf

--------------------------------------------------------------
Application of the MMPC algorithm to the datasets

Breast Cancer: mmpc_cancermama

Heart: mmpc_heart

Hepatitis: mmpc_hepatite

Divorce: mmpc_divorcio

Sepsi: mmpc_sepsi

Experiments_MMPC.zip

--------------------------------------------------------------
Results of global experiments

Global_experiments.zip



