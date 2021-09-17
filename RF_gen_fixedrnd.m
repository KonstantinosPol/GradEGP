function V=RF_gen_fixedrnd(type,len,D,ker_params,V_in)
%V: #RndFeatures * #len (where len=x_dim)
if strcmp(type,'RBF')
    V=randn(D,len);
    V=(1/sqrt(ker_params.ker_var))*V;
elseif strcmp(type,'RBF_fix_multi')  || strcmp(type,'RBF_fixed') || strcmp(type,'RBF_fix_multi_rnd')
    V=(1/sqrt(ker_params.ker_var))*V_in;
end


end