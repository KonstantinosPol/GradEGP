# GRaph-ADaptive Ensemble Gaussian Processes (GradEGP)

### Description

1. The main file for one Monte-Carlo (MC) run is main_EGP_run.m
2. For a given dataset and number of MC runs, one can run  EGP_res.m to obtain GradEGP results for MC runs
3. The "network delay", "temperature" and "email eu" datasets can be found at  NetDelayFeat.mat, Tempfeatdata.mat and emailEuData.mat respectively.
4. The chosen hyperparameters in the param files for each dataset can be obtained via grid search or Python sklearn.gaussian_process.GaussianProcessRegressor package, using a subset of the data (e.g 20%)  

### How to run

A. For the Network Delay dataset the results for 50 MC runs can be obtained running [egp_vec, time_tot_egp] =EGP_res("network delay", 50)

B. For the Temperature dataset the results for 50 MC runs can be obtained running [egp_vec, time_tot_egp] =EGP_res("temperature", 50)

C. For the Email Eu dataset the results for 50 MC runs can be obtained running [egp_vec, time_tot_egp] =EGP_res("email eu", 50)




### Papers

Please don't forget to cite the papers:

1. K. D. Polyzos, Q. Lu, and G. B. Giannakis, "Ensemble Gaussian processes for online learning over graphs with adaptivity and scalability," IEEE Transactions on Signal Processing. 
2. K. D. Polyzos, Q. Lu, and G. B. Giannakis, "Graph-Adaptive Incremental Learning Using an Ensemble of Gaussian Process Experts," Proc. of Intl. Conf. on Acoustics, Speech, and Signal Processing, Toronto, Canada, June 6-11, 2021.
3. Q. Lu, G. V. Karanikolas, Y. Shen, and G. B. Giannakis, "Ensemble Gaussian Processes with Spectral Features for Online Interactive Learning with Scalability," Proc. of 23rd Intl. Conf. on Artificial Intelligence and Statistics, Palermo, Italy, June 3-5, 2020.
