function [A_ego] = egonet(X,t)
% Input: adjacency X
%        node t
% Output: Egonet adjacency of node t

N = size(X,1);
A_ego = zeros(N,N);
A_ego(t,:) = X(t,:);
A_ego(:,t) = X(:,t);
ind = []; 
for i=1:N
    if X(t,i)>0
        ind = [ind i];   %find neighbors of node t
    end
end

for e = ind
    for z = ind
        if X(e,z)>0
            A_ego(e,z) = X(e,z);
        end
    end
end

