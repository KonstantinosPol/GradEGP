ker_vec=[0.0001 0.001 0.01 0.1 1 10 100 1000 10000 10^5 10^6];

ker_params=ker_params_from_vec(ker_vec);
params.t_train_fin=1000;


params.tau= 28.47;
params.nu= 650;

params.D=50;

params.sigma_bias=0;
params.prob_bias=0;


params.kern_shutdown_flg=0;
params.kern_shutdown_thr=10^(-16);%eps;

params.ynorm=1;
params.Xnorm=1;

params.combo_fn=@dummy_fn;

params.p0_in=.95;

params.opt_on=0;
params.opt=struct([]);
params.opt(1).opt_vars='both';
params.opt(1).logtau=0.5*log(params.tau);
params.opt(1).lognu=0.5*log(params.nu);

params.w_log_flg=1;
params.fn_ptr=@main_EGP;
params.online_flg=1;
params.fixed_small_var=1e-10;
params.var_thr=1e-10;
params.RF_type='RBF_fix_multi_rnd'

params.ker_params=ker_params;
params.S=numel(params.ker_params);


params.test_flag=0;
params.testX=[];