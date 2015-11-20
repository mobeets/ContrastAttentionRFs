
outdir = 'data/rfs';
for ii = 1:size(Y,2)
    plotRF_meanCounts(X,Y(:,ii), stimLoc);
    outfile = fullfile(outdir, ['sps_cGrid_cell-' num2str(ii)]);
    saveas(gcf, outfile, 'png');
    if mod(ii,10) == 0
        close all;
    end
end
