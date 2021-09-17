function [ theta,Sigma_new]=single_correct(theta,Sigma,sig_hat_sq,phi_xt1,y_t1,y_hat_t1,D,sigma_bias)
sig_h_inv=(1/sig_hat_sq);
Sphi=Sigma*phi_xt1;
G=sig_h_inv*(Sphi);
theta=theta+G*(y_t1-y_hat_t1);
Sigma_new=Sigma-sig_hat_sq*(G*G');

end