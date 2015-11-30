function [ix, Z, X, Y] = filterTrials(Z, keepRepeats, contNm, gridNm, X, Y)

if nargin < 3
    contNm = '';
end
if nargin < 4
    gridNm = '';
end
if isempty(contNm) && isempty(gridNm)
    if numel(unique(cellfun(@(z) z.movieprefix, Z, 'uni', 0))) > 1
        warning('Including trials from multiple conditions.');
        unique(cellfun(@(z) z.movieprefix, Z, 'uni', 0))
    end
    ix = true(numel(Z),1);
else
    isCond = @(Z, cond) cellfun(@(d) ...
    ~isempty(strfind(d.movieprefix, cond)), Z);
    isCont = isCond(Z, contNm);
    isGrid = isCond(Z, gridNm);
    ix = isCont & isGrid;
end

repeatVal = mode(cellfun(@(x) x.suffix, Z));
isRepeat = cellfun(@(x) x.suffix, Z) == repeatVal;
if ~keepRepeats
    ix = ix & ~isRepeat;
end

Z = Z(ix);
if nargin >= 5
    X = X(:,ix,:);
end
if nargin >= 6
    Y = Y(:,ix,:);
end

end
