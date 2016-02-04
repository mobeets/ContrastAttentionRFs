function vs = pairwiseNorms(ys, fcn)
% applies fcn to every pair of vectors in ys

    n = size(ys,1);
    vs = nan(n,n);
    for ii = 1:n-1
        vs(ii,ii+1:n) = arrayfun(@(jj) fcn(ys(ii,:), ys(jj,:)), ii+1:n);
    end
    
end
