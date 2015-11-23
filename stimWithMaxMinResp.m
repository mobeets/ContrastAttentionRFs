%% find cell with maximum spike count modulation from median

% Y = YGauss;
prcs = [20 50 80];
Yprc = prctile(Y, prcs, 1);


Yprc = Yprc';
figure;
plot(sortrows(Yprc, 2));
[(1:96)' Yprc(:,3)-Yprc(:,1)]
figure; hist(Yprc(:,3)-Yprc(:,1));
% tmp = diff(Yprc')';
% modl = tmp(:,2)./Yprc(:,2);
% [~,ix] = max(modl(~isinf(modl)))
% cellind = ix;

%%

scs1 = nan(size(Y0,2),2);
scs2 = nan(size(Y0,2),2);

nd1 = 32;
nd2 = nd1;
X1 = X;
X1(X1 < 0) = 0;
X1 = abs(X1);
% X1 = abs(X1);

% cellind = 29;
% cellind = 60;
% 23 49 59 77
for cellind = [77]%1:size(Y0,2)
    
%     obj = evaluateLinearModel(X1, Y(:,cellind), D, 'ML');
    objML = obj;
    objR = obj;
    scs1(cellind,1) = objML.score_dev;
    scs1(cellind,2) = objML.score;
    
    rs = Yprc(cellind,:);
    
    ix0 = Y(:,cellind) <= rs(1);
    ix1 = Y(:,cellind) >= rs(3);
    
    st0 = X1(ix0,:);
    st1 = X1(ix1,:);

%     st0 = X1(ix0,:) - 127.5;
%     st1 = X1(ix1,:) - 127.5;
    
    S = [st0; st1];
    R = [Y(ix0,cellind); Y(ix1,cellind)];
%     obj = evaluateLinearModel(S, R, D, 'ASD');
%     objML = evaluateLinearModel(S, R, D, 'ML');
%     objR = evaluateLinearModel(S, R, D, 'ML');
%     objR = evaluateLinearModel(S, R, D, 'ridge');
%     [cellind obj.score]
    w = obj.w;
    
    scs2(cellind,1) = objML.score_dev;
    scs2(cellind,2) = objML.score;
    
    [cellind scs1(cellind,2) scs2(cellind,2) (scs2(cellind,2) > scs1(cellind,2))]
%     continue;
    
%     figure; colormap gray;
%     subplot(1,3,1);
%     imagesc(reshape(obj.w, nd1, nd2));
%     axis off; axis square;
%     subplot(1,3,2);
%     imagesc(reshape(objR.w, nd1, nd2));
%     axis off; axis square;
%     subplot(1,3,3);
%     imagesc(reshape(objML.w, nd1, nd2));
%     axis off; axis square;
    
%     st0 = st0.^2;
%     st1 = st1.^2;

    wd = 200;
%     close all;
    figure; colormap gray;
    % figure; colormap gray;
    subplot(2,2,1); %colormap gray;
    imagesc(reshape(mean(st0),nd1,nd2));
    set(gca, 'YDir', 'normal');
    xlabel('stim on lowest spike rate');
     axis square;
    % set(gcf, 'position', [100, 100, wd, wd])
    % figure; colormap gray;
    subplot(2,2,2); %colormap gray;
    imagesc(reshape(mean(st1),nd1,nd2));
    set(gca, 'YDir', 'normal');
    xlabel('stim on highest spike rate');
     axis square;
    % set(gcf, 'position', [100+wd*1.2, 100, wd, wd])
    % figure; colormap gray;
    subplot(2,2,3); %colormap gray;
    imagesc(reshape(mean(st1)-mean(st0),nd1,nd2));
    set(gca, 'YDir', 'normal');
    xlabel('diff(stim)');
     axis square;
    % set(gcf, 'position', [100+wd*1.2*2, 100, wd, wd])
    % figure;
    subplot(2,2,4);    
    B = fspecial('gaussian');
    RF = reshape(mean(st1)-mean(st0), nd1, nd2);
    RF = filter2(B, RF, 'same');
    imagesc(RF);
    set(gca, 'YDir', 'normal');
     axis square;
     xlabel(cellind)
    % set(gcf, 'position', [100+wd*1.2*3, 100, wd, wd])
%     saveas(gcf, fullfile('data/cells_nosq', num2str(cellind)), 'png');
end

%%

close all;

% Find baseline spike count for each cell and subtract that off
% So look 50-100msec before stimstart
% Also, check PSTH. For 21, for example, is it ramping prior to stimstart?

% cellind = 4;
% cellind = 9;
cellind = 4;
% 21 23 49

X1 = Xc;
Y1 = Y(:,cellind);
ms1 = nan(size(X1,2),1);
ms2 = nan(size(X1,2),1);
ms3 = nan(size(X1,2),1);
for ii = 1:size(X1,2)
    ix = abs(X1(:,ii)) > 0;
    ms1(ii) = nanmean(Y1(ix));
    ix = X1(:,ii) > 0;
    ms2(ii) = nanmean(Y1(ix));
    ix = X1(:,ii) < 0;
    ms3(ii) = nanmean(Y1(ix));
end
figure; colormap gray;
subplot(2,2,1);
imagesc(reshape(ms1, 32, 32));
axis off; axis square;
subplot(2,2,2);
imagesc(reshape(ms2, 32, 32));
axis off; axis square;
subplot(2,2,3);
imagesc(reshape(ms3, 32, 32));
axis off; axis square;

