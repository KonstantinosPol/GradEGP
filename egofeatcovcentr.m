function [Xegofeat] = egofeatcovcentr(X)
% eigenvector centrality - egonet based
N = size(X,1);
Xegofeat = [];
for j = 1:N
    
    A_ego = egonet(X,j);
    K = A_ego'*A_ego;
    [V,E] = eig(K);
    maximum = max(max(E));
    [ez1,ez2]=find(E==maximum);
    temp = V(:,ez1(1));
    Xegofeat = [Xegofeat; temp'];
    
end
%degree of each node
D = [];
for e = 1:N
    counter = 0;
    for z = 1:N
        if X(e,z) > 0
            counter = counter + X(e,z);
        end
    end
    D = [D; counter];
end

Xegofeat = [Xegofeat D];


