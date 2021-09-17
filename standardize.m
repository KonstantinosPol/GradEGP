function X=standardize(X)
for l=1:size(X,2)
    var_l=var(X(:,l));
    if var_l>0 
        coeff=(1/sqrt(var_l));
    else
        coeff=1;
    end
    X(:,l)=coeff*(X(:,l)-mean(X(:,l)));
end
end