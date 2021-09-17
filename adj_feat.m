function [X2] = adj_feat(X,F)

N = size(X,1);
nf = size(F,2);
X2 = zeros(N,size(X,2)+size(F,2));
for n = 1:N
    X2(n,:) = [X(n,:) F(n,:)];
end