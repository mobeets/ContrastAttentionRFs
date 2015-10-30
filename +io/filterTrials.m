function [Z, X, Y, ix] = filterTrials(Z, X, Y, contNm, gridNm, keepRepeats)

isCond = @(Z, cond) cellfun(@(d) ...
    ~isempty(strfind(d.movieprefix, cond)), Z);
isCont = isCond(Z, contNm);
isGrid = isCond(Z, gridNm);
repeatVal = mode(cellfun(@(x) x.suffix, Z));
isRepeat = cellfun(@(x) x.suffix, Z) == repeatVal;

ix = isCont & isGrid;
if ~keepRepeats
    ix = ix & ~isRepeat;
end

Z = Z(ix);
X = X(:,ix,:);
Y = Y(:,ix,:);

end
