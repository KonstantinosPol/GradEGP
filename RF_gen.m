function V=RF_gen(type,len,D,ker_params)
%V: #RndFeatures * #len (where len=x_dim)
if strcmp(type,'RBF')
    V=randn(D,len);
    V=(1/sqrt(ker_params.ker_var))*V;
else
    V=nan(D,len);
end


end