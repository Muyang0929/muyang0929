###################################
# Library relatives function
library(Rcpp)
library(ggplot2)

#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

alpha<-as.numeric(args[1])
beta<-as.numeric(args[2])
cof<-as.numeric(args[3])


###################
#set the working direction and source pre-set functions
#setwd("~/OneDrive - University of Leeds/third year/Running functions")

#C++ function for energy matrix
#Rcpp::sourceCpp(file="energy_cpp_cauchy_non_homogenous.cpp")
#Rcpp::sourceCpp(file="energy_cpp_gaussian_non_homogenous.cpp")
#Rcpp::sourceCpp(file="energy_cpp_laplace_non_homogenous.cpp")
#source functions
#source("~/OneDrive - University of Leeds/third year/Running functions/mcmc_hyper_function.R")
#source("~/OneDrive - University of Leeds/third year/Running functions/getKB_function.R")
#source("~/OneDrive - University of Leeds/third year/Running functions/image_pattern_function.R")

#.................................................

#setwd("~/OneDrive - University of Leeds/third year/Running functions")
#################################
#Define the input parameters
# y: Observed image/dataset with noise
# X: True image
# iteration: The number of iteration in sampling
# nburn: The number of abandoned iterations before the convergence
# nthin: Pick up the every interval of iterations to avoid correlation 
# n1: The number of row in Y
# n2: The number of column in Y
# m1: The number of row in X
# m2: The number of column in X
# sc: The size ratio compared between X and Y. 
# The dimension of x doesn't need to be as same as the y, but in this case, they are equal (sc=1).
# K: Transformation matrix with transformation probability 
# noise: The type of noise 
# energy_cpp:which prior distribution for X will be used
#........................................................

sc=1
#Data load
example=2
if (example==1) {load("REAL_DATA/smoothing_hot.RData")} else if (example==2) {load("REAL_DATA/cylinders_eta_2.3_sd=1_noiseNpoisson_irep=3_data.RData")} else {load("REAL_DATA/252_mdp_mouse1_static_1h_4pi_data.RData")}
source("R_functions/getKB_function.R")
input_list=list("Y"=Y,"nburn"=100,"iteration"=1000,"nthin"=10,"n1"=nrow(Y),"n2"=ncol(Y),"m1"=nrow(Y)*sc,"m2"=ncol(Y)*sc)
input_list[["K"]]=getKB(input_list)
input_list[["cof"]]=cof
input_list[["energy_type"]]="laplace" 
source("R_functions/mcmc_hyper_function.R")
result<-mcmc_hyper(input_list)
save(result,file=paste0("results_",example,alpha,beta,cof,input_list[["energy_type"]],".RData"))

