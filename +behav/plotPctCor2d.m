function plotPctCor2d(B, xnm, ynm)
    if nargin < 2
        xnm = 'targx';
    end
    if nargin < 3
        ynm = 'targy';
    end

    condX = [B.(xnm)];
    condY = [B.(ynm)];
    
    xs = unique(condX);
    ys = unique(condY);
    prcs = nan(numel(xs), numel(ys));
    for ii = 1:numel(xs)
        for jj = 1:numel(ys)
            b = B(condX == xs(ii) & condY == ys(jj));
            bCor = [b.isCorrect];
            ph = mean(bCor);
            prcs(ii,jj) = ph;
        end
    end
    hold on;
    imagesc(xs, ys, prcs);
    axis image; axis normal;
%     colormap hot;
    set(gca, 'FontSize', 14);
    caxis([0.5 1.0]);
    colorbar;
    xlabel(xnm);
    ylabel(ynm);
end
