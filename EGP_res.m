function [egp_vec, time_tot_egp] = EGP_res(dataset, MC_runs)
    egp_mat=[];
    egpego_mat=[];
    egpf_mat=[];
    time_tot_egp = 0;
    time_tot_egpf = 0;
    time_tot_egpego = 0;
    if dataset == "network delay"
        load NetDelayfeat.mat
        for i=1:MC_runs
           params_delay
           [se,nmse,time_egp,y_comb,w_vec,w_log,var_comb,loglike,time_log,test_rep]=main_EGP_run(X,y,params);
           time_tot_egp = time_tot_egp + time_egp;
           egp_mat = [egp_mat nmse'];
           params_delay_ego
           tic
           Xegofeat = egofeatcovcentr(X);
           time_ego = toc;
           [se2,nmse2,time_egp2,y_comb2,w_vec2,w_log2,var_comb2,loglike2,time_log2,test_rep2]=main_EGP_run(Xegofeat,y,params);
           time_egp_ego = time_ego+time_egp2;
           time_tot_egpego = time_tot_egpego + time_egp_ego;
           egpego_mat = [egpego_mat nmse2'];
           params_delay_feat 
           Xf = adj_feat(X,F);
           [sef,nmsef,time_egpf,y_combf,w_vecf,w_logf,var_combf,loglikef,time_logf,test_repf]=main_EGP_run(Xf,y,params);
           egpf_mat = [egpf_mat nmsef'];
           time_tot_egpf = time_tot_egpf + time_egpf;
        end
            len = length(y_comb);
            egp_vec = zeros(len,1);
            egpego_vec = zeros(len,1);
            egpf_vec = zeros(len,1);
            time_tot_egp = time_tot_egp/MC_runs;
            time_tot_egpf = time_tot_egpf/MC_runs;
            time_tot_egpego = time_tot_egpego/MC_runs;
            for j=1:1:len
             egp_vec(j,1) = mean(egp_mat(j,:));
             egpego_vec(j,1) = mean(egpego_mat(j,:));
             egpf_vec(j,1) = mean(egpf_mat(j,:));
            end
       figure 
       plot(egp_vec,'b','LineWidth',2.0)
       xlabel('Size of the Network (N)');
       ylabel('nMSE');
       hold on  
       pl_ego = plot(egpego_vec,'LineWidth',2.0)
       pl_ego.Color = [0.8500 0.3250 0.0980]
       hold on
       plf = plot(egpf_vec,'LineWidth',2.0)
       plf.Color = [0.9290 0.6940 0.1250]
       title('Network delay dataset')
       legend('GradEGP','GradEGP-ego','GradEGP-feat')
       hold off
       
         figure
         ind = 4:70;
         plot(ind,y_combf(ind),'b','LineWidth',2.0)
         xlabel('Number of measurements (N)');
         ylabel('y');
         hold on 
         plot(ind,y(ind),'k','LineWidth',1.5)
         legend('True')
         hold on
         plot(ind,y_combf(ind)+var_combf(ind),'r','LineWidth',2.0)
         hold on
         plot(ind,y_combf(ind)-var_combf(ind),'r','LineWidth',2.0)
         title('Network delay dataset')
         legend('Prediction','True','\sigma credible intervals')
         hold off
    end
   
     if dataset == "temperature"
        load Tempfeatdata.mat
        for i=1:MC_runs
           params_temp
           [se,nmse,time_egp,y_comb,w_vec,w_log,var_comb,loglike,time_log,test_rep]=main_EGP_run(X,y,params);
           time_tot_egp = time_tot_egp + time_egp;
           egp_mat = [egp_mat nmse'];
           Xf = adj_feat(X,F);
           [sef,nmsef,time_egpf,y_combf,w_vecf,w_logf,var_combf,loglikef,time_logf,test_repf]=main_EGP_run(Xf,y,params);
           egpf_mat = [egpf_mat nmsef'];
           time_tot_egpf = time_tot_egpf + time_egpf;
        end
            len = length(y_comb);
            egp_vec = zeros(len,1);
            egpf_vec = zeros(len,1);
            time_tot_egp = time_tot_egp/MC_runs;
            time_tot_egpf = time_tot_egpf/MC_runs;
            for j=1:1:len
             egp_vec(j,1) = mean(egp_mat(j,:));
             egpf_vec(j,1) = mean(egpf_mat(j,:));
            end
       figure 
       ind = 10:109;
       plot(ind,egp_vec(ind),'b','LineWidth',2.0)
       xlabel('Size of the Network (N)');
       ylabel('nMSE');
       hold on  
       plf = plot(ind,egpf_vec(ind),'LineWidth',2.0)
       plf.Color = [0.9290 0.6940 0.1250]
       title('Temperature dataset')
       legend('GradEGP','GradEGP-feat')
       hold off
       
         figure
         ind = 4:109;
         plot(ind,y_combf(ind),'b','LineWidth',2.0)
         xlabel('Number of measurements (N)');
         ylabel('y');
         hold on 
         plot(ind,y(ind),'k','LineWidth',1.5)
         legend('True')
         hold on
         plot(ind,y_combf(ind)+var_combf(ind),'r','LineWidth',2.0)
         hold on
         plot(ind,y_combf(ind)-var_combf(ind),'r','LineWidth',2.0)
         title('Temperature dataset')
         legend('Prediction','True','\sigma credible intervals')
         hold off
    end
    
     if dataset == "email eu"
        load emailEuData.mat
        for i=1:MC_runs
           params_emaileu
           [se,nmse,time_egp,y_comb,w_vec,w_log,var_comb,loglike,time_log,test_rep]=main_EGP_run(X,y,params);
           time_tot_egp = time_tot_egp + time_egp;
           egp_mat = [egp_mat nmse'];
         
        end
            len = length(y_comb);
            egp_vec = zeros(len,1);
            time_tot_egp = time_tot_egp/MC_runs;
            for j=1:1:len
             egp_vec(j,1) = mean(egp_mat(j,:));
            end
       figure 
       plot(egp_vec,'b','LineWidth',2.0)
       xlabel('Size of the Network (N)');
       ylabel('nMSE');
       title('Email Eu dataset')
       legend('GradEGP')
       hold off
       
         figure
         ind = 10:1005;
         plot(ind,y_comb(ind),'b','LineWidth',2.0)
         xlabel('Number of measurements (N)');
         ylabel('y');
         hold on 
         plot(ind,y(ind),'k','LineWidth',1.5)
         legend('True')
         hold on
         plot(ind,y_comb(ind)+var_comb(ind),'r','LineWidth',2.0)
         hold on
         plot(ind,y_comb(ind)-var_comb(ind),'r','LineWidth',2.0)
         title('Email Eu dataset')
         legend('Prediction','True','\sigma credible intervals')
         hold off
    end
    
end