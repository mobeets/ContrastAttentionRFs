%% load exp

fn = fullfile('data', 'JayTest0001_trialinfo.mat');
D = load(fn);
D = D.trials;

%% load spikes

Y = io.loadSpikeTimes(D);

%% load stimuli

stimdir = 'stim_mats';
M.lCont_fGrid = io.loadStimulusMovies(stimdir, 'lCont_fGrid', nan, 6);
M.hCont_fGrid = io.loadStimulusMovies(stimdir, 'hCont_fGrid', nan, 6);
M.lCont_cGrid = io.loadStimulusMovies(stimdir, 'lCont_cGrid', nan, 16);
M.hCont_cGrid = io.loadStimulusMovies(stimdir, 'hCont_cGrid', nan, 16);
X = io.loadStimuliPerTrial(D, M);

%% trial condition indices

isGood = cellfun(@(d) any(d.codes(:,1) == 150), D);
isCond = @(D, cond) cellfun(@(d) ...
    ~isempty(strfind(d.movieprefix, cond)), D);
isHCont = isCond(D, 'hCont');
isCGrid = isCond(D, 'cGrid');

%% RF for single condition

% https://en.wikipedia.org/wiki/Spike-triggered_average

ix = isHCont & isCGrid;
repeatVal = mode(cellfun(@(x) x.suffix, D(ix)));
isRepeat = cellfun(@(x) x.suffix, D) == repeatVal;

X0 = cell2mat(X(ix & isGood & ~isRepeat));
Y0 = cell2mat(Y(ix & isGood & ~isRepeat));
STA = X0'*Y0;
Xcov = X0'*X0;
WSTA1 = Xcov \ STA(:,1);

%%

figure;
for ii = 1:size(STA,2)
    clf;
    colormap gray;
%     sta = reshape(STA(:,ii), 12, 12);
%     imagesc(sta/sum(Y0(:,ii)));
    sta = Xcov \ STA(:,ii);
    imagesc(reshape(sta, 12, 12));
%     caxis([0 255]);
    
    pause(0.1);
end

% for each spike, find stimulus preceding that spike by say 200 msec
% X' must be nt x nc
% STA = (1/nsp)*X'*y;

%% dummy comparison of mean counts

spikeCounts = cellfun(@numel, Y);
Y1 = mean(spikeCounts(isHCont,:));
Y2 = mean(spikeCounts(~isHCont,:));

m1 = min([Y1(:); Y2(:)]);
m2 = max([Y1(:); Y2(:)]);
bins = linspace(floor(m1), ceil(m2), 20);

c1 = hist(Y1, bins);
c2 = hist(Y2, bins);

figure;
subplot(2,1,1);
bar(bins, c1);
subplot(2,1,2);
bar(bins, c2);
