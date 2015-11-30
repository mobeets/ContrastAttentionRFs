%% load trial info

% fnm = 'sy20151007mapJay0002_trialinfo.mat';
% stimdir = 'stim_mats_20151007';
% fnm = 'SY20151029JayMovie0001_trialinfo.mat';
% stimdir = 'stim_mats_20151029';
% fnm = 'SY20151030JayMovie0001_trialinfo.mat';
% fnm = 'SY20151030JayMovie0002_trialinfo.mat'; % gauss
% stimdir = 'stim_mats_20151030';
% fnm = 'SY20151112JayMovie0001_trialinfo.mat'; % ica
% stimdir = 'stim_mats_20151111';
% fnm = 'SY20151118JayMovie0002_trialinfo.mat'; % sparse, fine
% stimdir = 'stim_mats_20151118';

fnm = 'SY20151119JayMovie0001_trialinfo.mat'; % sparse, coarse
stimdir = 'stim_mats_20151119';

[Z, XA, M] = io.loadTrialsAndStimuli(['data/exps/' fnm], ...
    ['data/' stimdir]);

%% load spike counts per stimulus pulse

YA = io.loadSpikeTimes(Z);

%% ignore first few pulses (stimulus onset)

pulses = 3:20;
X0 = XA(:,:,pulses);
Y0 = YA(:,:,pulses);

%% filter trials and prepare to fit

keepRepeats = true;
% curCond = 'gauss'; curGrid = 'cGrid';
% curCond = 'hCont'; curGrid = 'cGrid';
% curCond = 'ica'; curGrid = 'fGrid1';
% curCond = 'sps'; curGrid = 'cGrid';
% [Z2, X02, Y02, ix] = io.filterTrials(Z, X0, Y0, curCond, curGrid, ...
%     keepRepeats);

[ix2, Z2, X02, Y02] = io.filterTrials(Z, keepRepeats, '', '', X0, Y0);
X = X02(1:end,:)'; % now: ntrials x nd
Y = Y02(1:end,:)'; % now: ntrials x ncells

%%

% Xog = X;
% Yog = Y;
X = [X; X2];
Y = [Y; Y2];

%% truncate stim around putative rf

rfBounds = [-100 300; 100 -300];
% rfBounds = [20 70; -5 -45];
% rfBounds = [20 40; 10 -20];
% rfBounds = [10 30; -5 -20];
% rfBounds = [-5 30; 5 -30];
stimCenter = [Z{1}.centerx Z{1}.centery];
nd = sqrt(size(X,2));
pixelsPerElem = io.inferPixelRepeats('cGrid');
stimLoc = tools.stimCoords(stimCenter, nd, pixelsPerElem);
[Xc, stimLoc] = tools.shrinkStim(X, rfBounds, stimLoc);

%% fit

X1 = Xc;
STA = X1'*Y;
nd = sqrt(size(STA,1));

cellind = 49; % 49 22 6
Xcov = X1'*X1;
WSTA = Xcov \ STA(:,cellind);
obj = evaluateLinearModel(X1, Y(:,cellind), nan, 'ML');
obj = evaluateLinearModel(X1, Y(:,cellind), nan, 'ridge');
 
Xxy = tools.cartesianProductSquare([1:nd; 1:nd]);
D = asd.sqdist.space(Xxy);
% objASD = evaluateLinearModel(X1, Y(:,cellind), D, 'ASD');

% [objLasso, objLassoStats] = lasso(X1, Y(:,cellind));

%%

[objs, scs] = ft.allCells(X, Y, 'ridge');

%%

cellind = 22;
Xxy = tools.cartesianProductSquare([1:nd; 1:nd]);
D = asd.sqdist.space(Xxy);
% Xa = X; Xa(Xa<0) = 0;
Xa = X;
% objASD = evaluateLinearModel(Xa, Y(:,cellind), D, 'ASD');
% objR = evaluateLinearModel(Xa, Y(:,cellind), D, 'ridge');
objML = evaluateLinearModel(Xa, Y(:,cellind), D, 'ridge');
% objML = (Xa'*Xa + 1e-3*eye(size(Xa,2)))\(Xa'*Y(:,cellind));
% RFC = plotRF_meanCounts(X,Y(:,cellind),stimLoc);

%%

figure; colormap gray;
subplot(2,2,1);
imagesc(stimLoc(1,:), stimLoc(2,:), reshape(objASD.w, nd, nd));
hold on; plot(0,0,'rs');
set(gca, 'YDir', 'normal');
title(['ASD, rsq=' num2str(objASD.score)]);
axis square;
subplot(2,2,2);
imagesc(stimLoc(1,:), stimLoc(2,:), reshape(objR.w, nd, nd));
hold on; plot(0,0,'rs');
set(gca, 'YDir', 'normal');
title(['ASD, rsq=' num2str(objR.score)]);
axis square;
subplot(2,2,3);
imagesc(stimLoc(1,:), stimLoc(2,:), reshape(objML.w, nd, nd));
hold on; plot(0,0,'rs');
set(gca, 'YDir', 'normal');
axis square;
title(['ASD, rsq=' num2str(objML.score)]);
subplot(2,2,4);
imagesc(stimLoc(1,:), stimLoc(2,:), reshape(RFC, nd, nd));
hold on; plot(0,0,'rs');
set(gca, 'YDir', 'normal');
axis square;
title('avg spike count');

%% view STAs - all

% ncells = size(STA,2);
ncells = 50;
ncols = round(sqrt(ncells));
nrows = ceil(ncells/ncols);
figure; colormap gray;
for ii = 1:ncells
%     subplot(ncols, nrows, ii);
    w = STA(:,ii);
%     w = Xcov \ w;
    imagesc(RFX(:), RFY(:), reshape(w,nd,nd));
    set(gca, 'ydir', 'normal');
    axis square;
    xlabel(ii);
    pause(0.2);
    hold on;
end

%% view RFs - single cell

[RFX,RFY] = meshgrid(stimLoc(1,:), stimLoc(2,:));

A = load('data/ICA.mat'); A = A.G;
rfmap = A;

figure; colormap gray;

subplot(2,2,1);
w = STA(:,cellind);
imagesc(RFX(:), RFY(:), reshape(w,nd,nd));
set(gca, 'ydir', 'normal');
axis square;
xlabel('STA');

subplot(2,2,2);
w = WSTA;
imagesc(RFX(:), RFY(:), reshape(w,nd,nd));
set(gca, 'ydir', 'normal');
axis square;
xlabel('whitened STA');

subplot(2,2,3);
w = rfmap*obj.w;
imagesc(RFX(:), RFY(:), reshape(w,nd,nd));
set(gca, 'ydir', 'normal');
axis square;
xlabel('ML');

% subplot(2,2,4);
% w = rfmap*objASD.w;
% imagesc(RFX(:), RFY(:), reshape(w,nd,nd));
% set(gca, 'ydir', 'normal');
% axis square;
% xlabel('ASD');

subplot(2,2,4);
w = rfmap*objLasso(:,95);
imagesc(RFX(:), RFY(:), reshape(w,nd,nd));
set(gca, 'ydir', 'normal');
axis square;
xlabel('Lasso');
