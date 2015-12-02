function X = discretizeStimIfBinary(X, conds)
% n.b. X is assumed to be mean 0
if nargin < 2
    conds = ones(size(X,1), 1);
end
uncnds = unique(conds);
for ii = 1:numel(uncnds)
    ix = conds == uncnds(ii);
    x = X(ix,:);
    if numel(unique(x(:))) > 3
        return;
    end
end
warning('binary-izing');
X(X<0) = -1;
X(X>0) = 1;

end
