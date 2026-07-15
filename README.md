Supplementary Material

Title: Feature Selection based on the causality relation and extension of the parental relationship. Proposal of the LUISA algorithm
Submitted Journal: International Journal of Data Science and Analytics, Springer
Authors: Walisson Ferreira de Carvalho, Beethoven M. Andrade, Luis Enrique Zárate
Abstract: Non-causal feature selection methods may introduce errors in assessing feature relevance because they rely on a single selection criterion, which can lead to spurious correlations. The current causality methods of feature selection consider only the features that compose the Markov Blanket of one target variable (class) as relevant. That may lead to the disregard of other relevant features.
We present a new algorithm, LUISA, based on causal relationships. This algorithm expands the Markov Blanket to include indirect ancestors for a specific target variable or class. We test the algorithm on five perspectives using synthetic and real-world datasets. The experiments show that LUISA is representative and that it performs satisfactorily under uncertainty.
In addition, the learning models demonstrated promising results when using the reduced dataset compared to the complete dataset and various feature non-causal and causal selection methods.
--------------------------------------------------------------
Real-world datasets:
Breast Cancer: breast_cancer_wisconsin.zip
Heart: statlog_heart.zip
Hepatitis: hepatitis3.zip
Divorce: divorcio1.zip
Sepsi: sepsi.zip
--------------------------------------------------------------
LUISA Algorithm
LUISA uses MMPC.R available at: https://github.com/cran/MXM/blob/master/R/MMPC.R
LUISA uses MXM available at: https://github.com/cran/MXM/tree/master
LUISA is available in: LUISA_ALL.zip
(Observation: MMPC, MXM and Datasets must is in the same path)
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

