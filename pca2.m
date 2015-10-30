function s = pca2(data)

[M,N] = size(data);
% subtract off the mean for each dimension
mn = mean(data,2);
data = data - repmat(mn,1,N);
% construct the matrix Y
Y = data' / sqrt(N-1);
% SVD does it all
[u,s,v] = svd(Y);
% calculate the variances
s = diag(s);
S = s .* s;
% project the original data
s = v' * data;

end
