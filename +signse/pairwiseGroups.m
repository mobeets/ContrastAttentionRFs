function [vs, ais, bis] = pairwiseGroups(A, B, fcn, nsamps)
    if nargin < 4
        nsamps = nan;
    end    
    if ~isnan(nsamps)
        samps = randi(size(B,1), size(A,1), nsamps);
    else
        samps = repmat(1:size(B,1), size(A,1), 1);
        nsamps = size(B,1);
    end
    
    vs = nan(size(A,1), size(B,1));
    ais = nan(size(vs));
    bis = nan(size(vs));
    for ii = 1:size(A,1)
        vs(ii,1:nsamps) = arrayfun(@(jj) fcn(A(ii,:), B(jj,:)), samps(ii,:));
        ais(ii,:) = ii;
        bis(ii,1:nsamps) = samps(ii,:);
    end

end
