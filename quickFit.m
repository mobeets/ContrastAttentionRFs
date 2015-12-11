%% load

fnms = io.getFilenames();
fnm = fnms{end-4}
[ZA, XA, M] = io.loadTrialsAndStimuli(fnm);
% [ZA, XA, M] = io.loadTrialsAndStimuli(fnm, '', ZA);

%% find best latency

close all;
nBinsStim = 400;
cellinds = [12 24 59];
[Yr, xs0] = io.loadSpikeTimes(ZA, nBinsStim, -0.2, 0.2, 0);
[latencySecs, dSecsAll, vs, inds, xs0] = tools.optLatency(ZA, ...
    cellinds, nBinsStim, Yr, xs0);
% figure; hist(dSecsAll);
% latencySecs = 0.08;% + 0.05;
figure;
latencySecs = 0.09;
[~, YA] = plot.psth(ZA, cellinds, latencySecs);
% [Ymean, Yr, xs0] = plot.psth(ZA, 77, latencySecs, xs0, Ymean);

%% load spikes with optimal latency

latencySecs = 0.09;
YA = io.loadSpikeTimes(ZA, nan, nan, nan, latencySecs);

%% filter by condition

pulses = 2:20;
X0 = XA(:,:,pulses);
Y0 = YA(:,:,pulses);

keepRepeats = true;
[conts, grids, conds_all] = io.detectConditions(ZA);
[~, ZB, XB, YB] = io.filterTrials(ZA, keepRepeats, conts{1}, grids{1}, ...
    X0, Y0);
% [~, ZB, XB, YB] = io.filterTrials(ZA, keepRepeats, '', '', X0, Y0);
X = XB(1:end,:)';
Y = YB(1:end,:)';

%% fit substims

nd = sqrt(size(X,2));
[Xs, ixs] = io.stim2stims(X, nd/4);
% [Xs, ixs] = io.stim2stims(X, 8, [4 4]);
objs = cell(numel(Xs),1);
scs = nan(numel(Xs), size(Y,2));
for ii = 1:numel(Xs)
    [obs, ss] = ft.allCells(Xs{ii}, Y, 'ridge', nan);
    objs{ii} = obs;
    scs(ii,:) = ss;
end

%% fit stim

[objs, scs] = ft.allCells(X, Y, 'ridge', nan);
% [~, fnm0] = fileparts(fnm);
% save(fullfile('data', 'fits', [fnm0(3:10) '.mat']), 'objs', 'scs');

%% visualize one

figure; colormap gray;
w = objs{59}.w;
nd = sqrt(numel(w));
imagesc(reshape(w, nd, nd));
        
%% visualize

figure; colormap gray;
for ii = 29%1:numel(objs)
    if scs(ii) > 0.0
        nd = sqrt(numel(objs{ii}.w));
        imagesc(reshape(objs1{ii}.w, nd, nd));
        pause(0.5);
    end
end
