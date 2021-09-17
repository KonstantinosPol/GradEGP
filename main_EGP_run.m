function [se,nmse,time_egp,y_comb,w_vec,w_log,var_comb,loglike,time_log,test_rep]=main_EGP_run(X,y,params)

%% X: adjacency matrix
%% y: nodal values

tic 
T=size(X,1);

time_log=nan(fix(T/10)+1,1);
time_log(1)=0;


nu=params.nu;    %sigma_theta^2 in the paper
w_log={};

D=params.D;
RF_type=params.RF_type;
online_flg=params.online_flg;
tau=params.tau;  %sigma_epsilon^2 in the paper
ker_params=params.ker_params;
w_log_flg=params.w_log_flg;
fixed_small_var=params.fixed_small_var;
var_thr=params.var_thr;
prob_bias=params.prob_bias;
kern_shutdown_flg=params.kern_shutdown_flg;
kern_shutdown_thr=params.kern_shutdown_thr;
sigma_bias=params.sigma_bias;


S=params.S;  % M in the paper

if S~=numel(params.ker_params)
    throw_exception('S must be equal to num. of kernel parameters')
end
w_vec_init=(1/S)*ones(1,S);
w_vec=w_vec_init;

V=cell(1,S);
theta_t=cell(S,1);
Sigma=cell(S,1);

x_t=(X(1,:))';
len_x=length(x_t);
V_in_cell={};
if strcmp(RF_type,'RBF_fixed')
    load('V_in_stored.mat','V_in')
    V_in=V_in(1:D,1:len_x);
    for s=1:S
        V_in_cell{s}=V_in;
    end

else
  for s=1:S
      V_in_cell{s}=[];
  end
end
V_in=randn(D,len_x);

for s=1:S
    
    theta_t{s}=zeros(2*D,1); %Initialization of theta_t for all experts   
    Sigma{s}=nu*eye(2*D);    %Intialization of Sigma for all experts         
    
    V{s}=RF_gen('RBF',len_x,D,ker_params{s});   
    if ~online_flg
        phi_xt_s=RF_phi(x_t,V{s},D);
        Phi{s}=phi_xt_s;
    end
    

end


y_comb=nan(T,1);
var_comb=nan(T,1);
loglike=nan(T,1);
se=nan(T,1);
y_t_vec=nan(T,1);
y_t_vec(1)=y(1);


l_vec=nan(1,S);
mu_vec=nan(S,1);
var_vec=nan(S,1);

for t=1:T
    
    x_t=(X(t,:))';
    y_t=y(t);

    for s=1:S
        if kern_shutdown_flg
            %%%%% kernel shutdown %%%%
            if w_vec(s)<= kern_shutdown_thr
                mu_vec(s,1)=0;
                var_vec(s,1)=0;
                l_vec(s)=0;
                w_vec(s)=0;
                continue
            end
        end
        phi_xt_s=RF_phi(x_t,V{s},D);
       
        if online_flg
            
            Sigma{s}=Sigma{s}+sigma_bias*eye(size(Sigma{s}));
            %% Prediction step
            [mu_p,var_p]=single_predict(phi_xt_s,Sigma{s},tau,theta_t{s});
            %% Correction step 
            [theta_t{s},Sigma{s}]=single_correct(theta_t{s},Sigma{s},var_p,phi_xt_s,y_t,mu_p,D,sigma_bias);
  
        else
 
            R = chol((nu(s))*((Phi{s}*(Phi{s})')) + tau(s)*eye(2*D));                            % calculate some often-used constants

            PhiRi=(Phi{s}')/R;
            RtiPhit = PhiRi';

            Rtiphity=RtiPhit*(y_t_vec(1:t-1));
            
            alfa=(nu(s))*(R\Rtiphity);

            mu_p=alfa'*phi_xt_s;
            var_p= tau(s)*(1+nu(s)*sum((phi_xt_s'/R).^2,2));
            
            y_t_vec(t)=y_t;
            Phi{s}=[Phi{s}  phi_xt_s];
        end
        
        
        if isnan(mu_p)
            disp(mu_p)
            throw_exception('mu_p is NaN')
            
        end
        
        
        mu_vec(s,1)=mu_p;
        var_vec(s,1)=var_p;
        l_vec(s)=myGL(y_t,mu_p,var_p);

                    
        if (l_vec(s) < 0) || isnan(l_vec(s))
            fprintf('l: %f m: %f var: %f\n',l_vec(s),mu_p,var_p)
            throw_exception('l_vec leq 0 or NaN')
      
        end
        
        
    end
    
    y_comb(t)=w_vec*mu_vec;
    w_vec_old=w_vec;
    del_vec=((y_comb(t)-mu_vec).^2)';
    var_comb(t)=sum(w_vec.*(var_vec'+del_vec)); 
    loglike(t)=log(sum(w_vec.*l_vec));
    se(t)=(y_t-y_comb(t))^2;
    
    if w_log_flg
        w_log{t}=w_vec;
    end
    %% Update weights
    w_vec=update_weights(w_vec,l_vec,prob_bias);

end
test_rep=struct([]);
if params.test_flag
    Xtmp=params.testX;
    y_comb_test=nan(size(Xtmp,1),1);
    var_comb_test=nan(size(Xtmp,1),1);
    for t_test=1:size(Xtmp,1)
        x_t=(Xtmp(t_test,:))';
        for s=1:S
            phi_xt_s=RF_phi(x_t,V{s},D);
            [mu_p,var_p]=single_predict(phi_xt_s,Sigma{s},tau(s),theta_t{s});            
            mu_vec(s,1)=mu_p;
            var_vec(s,1)=var_p;
        end
        y_comb_test(t_test)=w_vec*mu_vec;
        del_vec_test=((y_comb_test(t_test)-mu_vec).^2)';
        var_comb_test(t_test)=sum(w_vec.*(var_vec'+del_vec_test));
    end
    
    test_rep(1).y_comb_test=y_comb_test;
    test_rep(1).var_comb_test=var_comb_test;
time_log = 1;
end

time_egp =  toc;
nmse=[];

for i=1:T
   nmse= [nmse sum(se(1:i))/(i*var(y))]; 
end





