function [conts, grids, conds_all] = detectConditions(Z)

conds_all = cellfun(@(z) z.movieprefix, Z, 'uni', 0);
nms = unique(conds_all);
elems = cellfun(@(s) strsplit(s, {'/', '_'}), nms, 'uni', 0);
conts = cellfun(@(d) d{2}, elems, 'uni', 0);
grids = cellfun(@(d) d{3}, elems, 'uni', 0);

end
