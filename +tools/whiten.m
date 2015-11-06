function X = whiten(X, epsilon)

if nargin < 2
    epsilon = 0;
end

X = bsxfun(@minus, X, mean(X));
A = X'*X;
[V,D] = eig(A);
X = X*V*diag(1./(diag(D) + epsilon).^(1/2))*V';

end
