%% load

fnms = io.getFilenames();
fnm = fnms{3}
[ZA, XA, M] = io.loadTrialsAndStimuli(fnm);

%% find best latency

latencySecs = 0.1;% + 0.05;
[Ymean, Yr, xs0] = plot.psth(ZA, [77 95], latencySecs);
% [Ymean, Yr, xs0] = plot.psth(ZA, 77, latencySecs, xs0, Ymean);

%% load spikes and filter by condition

YA = io.loadSpikeTimes(ZA, nan, nan, nan, latencySecs);

pulses = 2:20;
X0 = XA(:,:,pulses);
Y0 = YA(:,:,pulses);

keepRepeats = true;
[conds, grids] = io.detectConditions(ZA);
% [~, ZB, XB, YB] = io.filterTrials(ZA, keepRepeats, conds{1}, grids{1}, ...
%     X0, Y0);
[~, ZB, XB, YB] = io.filterTrials(ZA, keepRepeats, '', '', X0, Y0);
X = XB(1:end,:)';
Y = YB(1:end,:)';

%% fit substims

nd = sqrt(size(X,2));
[Xs, ixs] = io.stim2stims(X, nd/2);
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

%% visualize

figure; colormap gray;
for ii = 29%1:numel(objs)
    if scs(ii) > 0.0
        nd = sqrt(numel(objs{ii}.w));
        imagesc(reshape(objs1{ii}.w, nd, nd));
        pause(0.5);
    end
end
