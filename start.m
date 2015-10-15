%% load exp

fn = fullfile('data', 'sy20151007mapJay0002_trialinfo.mat');
D = load(fn);
D = D.TrialInfo;

%% load spikes

Y = io.loadSpikeTimes(D);
% Y2 = io.loadSpikeTimesRaw(D);

%%

figure; hold on;
x = D{32};
y = Y{32};
y2 = Y2{32};
for ii = 1:size(y,2)
%     plot((0:0.2:(x.endTime - x.startTime)), y2(:,ii));
    plot(x.stimstart + 0.2 + (0:0.1:1.9), y(:,ii));
end
plot((1:numel(x.Diodeval))/30000, 0.5*x.Diodeval/max(y(:)));

%% load stimuli

stimdir = 'stim_mats';
M.lCont_fGrid = io.loadStimulusMovies(stimdir, 'lCont_fGrid', nan, 6);
M.hCont_fGrid = io.loadStimulusMovies(stimdir, 'hCont_fGrid', nan, 6);
M.lCont_cGrid = io.loadStimulusMovies(stimdir, 'lCont_cGrid', nan, 16);
M.hCont_cGrid = io.loadStimulusMovies(stimdir, 'hCont_cGrid', nan, 16);
M.gauss_cGrid = io.loadStimulusMovies(stimdir, 'gauss_cGrid', nan, 16);
X = io.loadStimuliPerTrial(D, M);

%% trial condition indices

isGood = cellfun(@(d) any(d.codes(:,1) == 150), D);
isCond = @(D, cond) cellfun(@(d) ...
    ~isempty(strfind(d.movieprefix, cond)), D);
isHCont = isCond(D, 'hCont');
isCGrid = isCond(D, 'cGrid');

%% RF for single condition

% https://en.wikipedia.org/wiki/Spike-triggered_average
% http://www.cns.nyu.edu/pub/eero/simoncelli03c-preprint.pdf

ix = isHCont & isCGrid;
repeatVal = mode(cellfun(@(x) x.suffix, D(ix)));
isRepeat = cellfun(@(x) x.suffix, D) == repeatVal;

ixKeep = ix & isGood & ~isRepeat;
X0 = cell2mat(X(ixKeep));
X0m = X0 - repmat(mean(X0), size(X0,1), 1);
Y0 = cell2mat(Y(ixKeep));
% 
% ixf = 17;
% X0 = X0(ixf:20:size(X0,1),:);
% X0m = X0m(ixf:20:size(X0m,1),:);
% Y0 = Y0(ixf:20:size(Y0,1),:);
% sum(Y0(:))

STA = X0'*Y0;
STA2 = X0m'*Y0;
Xcov = X0'*X0;
WSTA1 = Xcov \ STA(:,29);

%%

figure;
for ii = 29%1:size(STA,2)
    clf;
    colormap gray;
    sta = reshape(STA(:,ii), 12, 12);
    imagesc(sta/sum(Y0(:,ii)));
%     caxis([0 255]);
%     stc = Xcov \ STA(:,ii);
%     imagesc(reshape(stc, 12, 12));
    pause(0.1);
end

% for each spike, find stimulus preceding that spike by say 200 msec
% X' must be nt x nc
% STA = (1/nsp)*X'*y;

%%

nlags = 1;
scs = nan(nlags,size(Y0,2));
ws = nan(nlags,size(Y0,2),144);
for jj = 1:nlags
    for kk = 29%1:size(Y0,2)
        y = Y0(jj:end,kk);
        x = X0(1:end-jj+1,:);
        x = (x - 128)/128;
%         b = mean(y);
        b = 0;
        y = y - b;
        w = (x'*x)\(x'*y);
        ws(jj,kk,:) = w;
%         w = x'*y;
        scs(jj,kk) = rsq(x*w + b, y);
        
        mdl = fitlm(x,y);
        scs(jj,kk) = mdl.Rsquared.Ordinary;
    end
end
figure; hold on;
for kk = 1:size(Y0,2)
   plot(scs(:,kk)); 
end

%% dummy comparison of mean counts

w = cellfun(@(x) x', Y, 'uni', 0);
spikeCounts = [w{:}];

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
