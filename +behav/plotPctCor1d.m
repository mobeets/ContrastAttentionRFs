function plotPctCor1d(B, xnm, xlbl)
    if nargin < 2
        xlbl = xnm;
    end

    conds = [B.(xnm)];
    
    xs = unique(conds);
    prcs = nan(numel(xs),1);
    errs = nan(numel(xs),1);
    for ii = 1:numel(xs)
        b = B(conds == xs(ii));
        bCor = [b.isCorrect];
        ph = mean(bCor);
        prcs(ii) = ph;
        errs(ii) = sqrt(ph*(1-ph)/numel(bCor));
    end
    hold on;
    plot(xs, prcs, 'o');
    plot(xs, prcs, '-');
    errorbar(xs, prcs, 2*errs, '.');
    xlabel(xlbl);
    ylabel('% correct');
    ylim([0.0 1.05]);
    set(gca, 'FontSize', 14);

end
