function [conds, grids] = detectConditions(Z)

nms = unique(cellfun(@(z) z.movieprefix, Z, 'uni', 0));
elems = cellfun(@(s) strsplit(s, {'/', '_'}), nms, 'uni', 0);
conds = cellfun(@(d) d{2}, elems, 'uni', 0);
grids = cellfun(@(d) d{3}, elems, 'uni', 0);

end
