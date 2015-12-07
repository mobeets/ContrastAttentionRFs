function [Xs, ixs] = stim2stims(X, nd)
% returns the 2d stimulus X into sub-stimuli
%   where columns of X correspond to locations along 2d grid
%   n.b. sub-stimuli will overlap somewhat
% 

nd0 = sqrt(size(X,2));
if mod(nd0, nd) ~= 0
    error('stim2stims: cannot divide grid evenly.');
end

% get grid corners
inds = reshape(1:size(X,2), nd0, nd0);
xinds = 1:nd:nd0;
xinds = [xinds nd0/2 - nd/2 + 1]; % add center
[xx,yy] = meshgrid(xinds);
starts = [xx(:) yy(:)];

% get grid indices and submatrices
Xs = cell(size(starts,1),1);
ixs = cell(size(starts,1),1);
for ii = 1:numel(Xs)
    xi = starts(ii,1);
    yi = starts(ii,2);
    ix = inds(xi:xi+nd-1, yi:yi+nd-1);
    Xs{ii} = X(:,ix(:));
    ixs{ii} = ix(:);
end

end
