%% example PSTHs

[Yr, xs0] = io.loadSpikeTimes(Z, 200, -1, 1);
Ymean = squeeze(mean(Yr,2));

%%

% 48, 53, 77
figure; hold on;
for ii = 77%size(Ymean,1)
    ym = Ymean(ii,:);
%     plot(xs0, ym./max(ym));
    plot(xs0, ym./mean(ym(1:10)));
    yl = ylim;
    
    hold on;
    for jj = 0:0.1:2
        plot([jj jj], [0 5], 'Color', [0.8 0.8 0.8]);
    end
    ylim(yl);
end

%% example spike counts

[Y2, xs0] = io.loadSpikeTimes(Z);
% Y2 = Y2(:,:,4:end);
% X0a = X0(1:end,1:end,2:end);
X2 = X0a(1:end,:);
X2 = XA;

%%

cellind = 77;
Y2a = Y2(cellind,:);
figure;
hist(Y2a,20);

%%

cellind = 77;
nd = sqrt(size(X,2));

Xt = X; Xt(Xt<0) = 0;
inds = Xt*(1:nd^2)';
Ym = nan(nd^2,1);
Yv = nan(nd^2,1);% max(sum(Xt)));
for ii = 1:nd^2
    ix = (inds == ii);
    y = Y(ix,cellind);
    Ym(ii) = nanmean(y);
    Yv(ii) = nanstd(y);
end
cs = Ym - nanmean(Y(:,cellind)) - 2*Yv;
cs(cs > 0) = 1; cs(cs < 0) = 0;

figure; colormap gray;
imagesc(stimLoc(1,:), stimLoc(2,:), reshape(Ym, nd, nd));
hold on;
plot(0,0,'rs');
axis square; set(gca, 'YDir', 'normal');
colorbar;

[xx, yy] = meshgrid(stimLoc(1,:), stimLoc(2,:));
cs0 = reshape(cs, nd, nd) > 0;
scatter(xx(cs0), yy(cs0), '.');

%% stimulus plots

nd = sqrt(size(X0,1));

% total number of times something appeared at a given pixel
figure; colormap gray;
subplot(2,2,1);
Xsum = sum(abs(X0(1:end,:)),2);
imagesc(stimLoc(1,:), stimLoc(2,:), reshape(Xsum, nd, nd));
hold on;
plot(0,0,'rs');
axis square; set(gca, 'YDir', 'normal');
title('stimulus frequency, per pixel');

% pixels where nothing was ever shown
subplot(2,2,2);
imagesc(stimLoc(1,:), stimLoc(2,:), reshape(Xsum==0, nd, nd));
hold on;
plot(0,0,'rs');
axis square; set(gca, 'YDir', 'normal');
title('pixels without stimuli');

RF = nan(nd^2,1);
RFvar = nan(nd^2,20);
RF2 = nan(nd^2,1);
for ii = 1:nd^2
    nix = sum(X2(ii,:) ~= 0);
    RF(ii) = prctile(Y2a(X2(ii,:) ~= 0), [70]);
%     RF(ii) = median(Y2a(X2(ii,:) ~= 0));
    RFvar(ii,1:nix) = Y2a(X2(ii,:) ~= 0);
    RF2(ii) = prctile(Y2a(X2(ii,:) > 0), [80]);
    RF2a(ii) = prctile(Y2a(X2(ii,:) > 0), [20]);
    RF2(ii) = RF2(ii) - RF2a(ii);
%     RF2(ii) = median(Y2a(X2(ii,:) > 0));
end
cs = nanmean(RF,2) - mean(Y2a) - 2*nanstd(RFvar,[],2);
cs(cs <= 0) = 0;
cs(cs > 0) = 1;
cs2 = nanmean(RF,2) - mean(Y2a) + 2*nanstd(RFvar,[],2);
cs2(cs2 >= 0) = 0;
cs2(cs2 < 0) = -1;
cs = cs + cs2;

% mean spike count per pixel, when something shown
subplot(2,2,3);
B = fspecial('gaussian');
RF = reshape(RF2, nd, nd);
RF = filter2(B, RF, 'same');
imagesc(stimLoc(1,:), stimLoc(2,:), RF);
hold on;
plot(0,0,'rs');
axis square; set(gca, 'YDir', 'normal');
title('mean spike count per pixel (white)');
colorbar;

% mean spike count per pixel, when white dot shown
subplot(2,2,4);
imagesc(stimLoc(1,:), stimLoc(2,:), reshape(cs, nd, nd));
hold on;
plot(0,0,'rs');
axis square; set(gca, 'YDir', 'normal');
title('significant deviation from mean rate, +/- 2se');

