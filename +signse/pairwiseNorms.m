function [vs, inds] = pairwiseNorms(ys, fcn)
% applies fcn to every pair of vectors in ys

    n = size(ys,1);
    vs = nan(n,n);
    inds = nan(n,n,2);
    
    for ii = 1:n-1
        inds(ii,:,1) = ii;
        inds(ii,ii+1:n,2) = ii+1:n;
        vs(ii,ii+1:n) = arrayfun(@(jj) fcn(ys(ii,:), ys(jj,:)), ii+1:n);
    end
    
end
