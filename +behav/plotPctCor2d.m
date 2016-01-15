function [prcs, ns] = plotPctCor2d(B, xnm, ynm, xlbl, ylbl)
    if nargin < 2
        xnm = 'targx';
    end
    if nargin < 3
        ynm = 'targy';
    end
    if nargin < 4
        xlbl = xnm;
    end
    if nargin < 5
        ylbl = ynm;
    end

    condX = [B.(xnm)];
    condY = [B.(ynm)];
    
    xs = unique(condX);
    ys = unique(condY);
    prcs = nan(numel(xs), numel(ys));
    ns = nan(numel(xs), numel(ys));
    for ii = 1:numel(xs)
        for jj = 1:numel(ys)
            b = B(condX == xs(ii) & condY == ys(jj));
            bCor = [b.isCorrect];
            ph = mean(bCor);
            prcs(ii,jj) = ph;
            ns(ii,jj) = numel(bCor);
        end
    end
    hold on;
    imagesc(xs, ys, prcs');
    axis image; axis normal;
%     colormap hot;
    set(gca, 'FontSize', 14);
    caxis([-0.05 1.05]);
    colorbar;
    xlabel(xlbl);
    ylabel(ylbl);
end
