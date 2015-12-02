function [grps, grpnames] = stimulusCondGroup(Z, fieldNm)
if nargin < 2
    fieldNm = 'movieprefix';
end

conds = cellfun(@(z) z.(fieldNm), Z, 'uni', 0);
grpnames = unique(conds);
grps = sum(cell2mat(arrayfun(@(ii) ii*strcmp(grpnames{ii}, conds), ...
    1:numel(grpnames), 'uni', 0)),2);

end
