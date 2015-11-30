%% example PSTHs

[Ymean, Yr, xs0] = plot.psth(Z, 22, 0.038); % 48, 53, 77

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

for ii = 20%size(Y,2)
    plot.rfMeanCounts(X, Y(:,ii), stimLoc);
    pause(0.5);
    if mod(ii,10) == 0
        close all;
    end
end

