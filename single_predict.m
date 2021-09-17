function [mu_p,var_p]=single_predict(phi_xt1,Sigma_t,tau,theta_t)
    
mu_p=((theta_t)')*phi_xt1;
var_p=(phi_xt1')*(Sigma_t*phi_xt1)+tau;
end