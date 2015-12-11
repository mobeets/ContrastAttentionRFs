function B = addBinnedField(B, xnm, ynm, nbins)
    if nargin < 4
        nbins = 10;
    end

    conds = [B.(xnm)];
    xs = linspace(min(conds)-1e-4, max(conds), nbins+1);

    grps = nan(numel(conds),1);
    for ii = 1:numel(xs)-1
        grps((xs(ii) < conds) & (conds <= xs(ii+1))) = ii;
    end

    grp = num2cell(xs(grps));
    [B.(ynm)] = deal(grp{:});

end
