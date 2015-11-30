%% load

fnms = io.getFilenames();
fnm = fnms{end-3}
[ZA, XA, M] = io.loadTrialsAndStimuli(fnm);

%% find best latency

latencySecs = 0.088;% + 0.05;
[Ymean, Yr, xs0] = plot.psth(ZA, [77 95], latencySecs);
% [Ymean, Yr, xs0] = plot.psth(ZA, 77, latencySecs, xs0, Ymean);

%% load spikes and filter by condition

YA = io.loadSpikeTimes(ZA, nan, nan, nan, latencySecs);

pulses = 3:20;
X0 = XA(:,:,pulses);
Y0 = YA(:,:,pulses);

keepRepeats = true;
[conds, grids] = io.detectConditions(ZA);
% [ZB, XB, YB, ~] = io.filterTrials(ZA, X0, Y0, conds{1}, grids{1}, ...
%     keepRepeats);
[~, ZB, XB, YB] = io.filterTrials(ZA, keepRepeats, '', '', X0, Y0);
X = XB(1:end,:)';
Y = YB(1:end,:)';

%% fit

[objs, scs] = ft.allCells(X, Y, 'ridge');
% [~, fnm0] = fileparts(fnm);
% save(fullfile('data', 'fits', [fnm0(3:10) '.mat']), 'objs', 'scs');

%% visualize

figure; colormap gray;
for ii = 1:numel(objs)
    if scs(ii) > 0.0
        nd = sqrt(numel(A*objs{ii}.w));
        imagesc(reshape(A*objs{ii}.w, nd, nd));
        pause(0.5);
    end
end
