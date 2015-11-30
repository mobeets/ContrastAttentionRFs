function RF = rfMeanCounts(X, Y, stimLoc)

nd = sqrt(size(X,2));
if nargin < 3
    stimLoc = [1:nd; 1:nd];
end

Xt = X; Xt(Xt<0) = 0;
inds = Xt*(1:nd^2)';
Ym = nan(nd^2,1);
Yv = nan(nd^2,1);% max(sum(Xt)));
for ii = 1:nd^2
    ix = (inds == ii);
    y = Y(ix);
    Ym(ii) = nanmean(y);
    Yv(ii) = nanstd(y);
end
cs = Ym - nanmean(Y) - 2*Yv;
cs(cs > 0) = 1; cs(cs < 0) = 0;

figure; colormap gray;
imagesc(stimLoc(1,:), stimLoc(2,:), reshape(Ym, nd, nd));
hold on;
plot(0,0,'rs');
axis square;
set(gca, 'YDir', 'normal');
colorbar;

[xx, yy] = meshgrid(stimLoc(1,:), stimLoc(2,:));
cs0 = reshape(cs, nd, nd) > 0;
scatter(xx(cs0), yy(cs0), '.');

RF = Ym;

end
