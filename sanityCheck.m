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

figure; colormap gray;
for ii = 1:size(X,1)
    imagesc(reshape(X(ii,:),16,16));
    pause(0.1);
end

%%

%%

for ii = 1:10%size(Y,2)
    plotRF_meanCounts(X,Y(:,ii), stimLoc);
    pause(0.5);
    if mod(ii,10) == 0
        close all;
    end
end

