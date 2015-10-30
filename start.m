%% load mapping

fn = fullfile('data', 'sy20151007mapJay0001_reduceddata.mat');
E = load(fn);

fn = fullfile('data', 'sy20151007mapJay0001_trialinfo.mat');
F = load(fn);

% warning: the above will take a bit to plot
% arrayfun(@(ii) showMapData(E, {'stimcounts'}, ii), 1:96, 'uni', 0)
% cells with LL RFs: 6, 9, 12, 13, 27, 56, 58, 59, 93, 94, 95
%   other good RFs: 65, 74, 77 (centered, broad), 82, 86, 87

% mapping stim is from Xlim (0, 70), Ylim (-50, 0)

%% load exp

% nm = 'sy20151007mapJay0002_trialinfo.mat';
nm = 'SY20151029JayMovie0001_trialinfo.mat';
fn = fullfile('data', nm);
Z = load(fn);
Z = Z.TrialInfo;

%% compare exp and mapping RFs

cellind = 6;

% exp stim is at xcenter 39, ycenter -23
% exp stim is from Xlim (-57, 135), Ylim (-119, 73)

np = 16; % pixels per cell of stimulus
nd = 12; % nrows/cols of stim
xcen = unique(cellfun(@(z) z.centerx, Z));
ycen = unique(cellfun(@(z) z.centery, Z));
xl = [xcen - np*nd/2 xcen + np*nd/2];
yl = [ycen - np*nd/2 ycen + np*nd/2];
xpos = (0:np:np*nd-1) + xl(1) + np/2;
ypos = (0:np:np*nd-1) + yl(1) + np/2;
stimPos = tools.cartesianProductSquare([xpos; ypos]);

showMapData(E, {'stimcounts'}, cellind);
figure; colormap jet;
% X02 = X0;
% X02 = abs(X0 - 128);
X02 = X0 - 128; X02(X02 > 0) = 0;
obj = evaluateLinearModel(X02, Y0(:,cellind), D, 'ASD');
w = reshape(obj.w, nd, nd);
imagesc(stimPos(:,1), stimPos(:,2), w);
obj.score

%% load spikes

Y = io.loadSpikeTimes(Z);
% Y2 = io.loadSpikeTimesRaw(D);

%%

figure; hold on;
x = Z{32};
y = Y{32};
ymean = mean(cat(3, Y{:}),3);
for ii = 6%1:size(y,2)
    plot(x.stimstart + 0.0 + (0:0.1:1.9), ymean);
end
% plot((1:numel(x.Diodeval))/30000, 0.5*x.Diodeval/max(y(:)));
plot((1:numel(x.Diodeval))/30000, x.Diodeval);

%% load stimuli

suffixes = unique(cellfun(@(z) z.movieprefix, Z, 'uni', 0));
stimdir = 'stim_mats';
M.lCont_fGrid = io.loadStimulusMovies(stimdir, 'lCont_fGrid', nan, 4);
M.hCont_fGrid = io.loadStimulusMovies(stimdir, 'hCont_fGrid', nan, 4);
% M.lCont_cGrid = io.loadStimulusMovies(stimdir, 'lCont_cGrid', nan, 16);
% M.hCont_cGrid = io.loadStimulusMovies(stimdir, 'hCont_cGrid', nan, 16);
% M.gauss_cGrid = io.loadStimulusMovies(stimdir, 'gauss_cGrid', nan, 16);
X = io.loadStimuliPerTrial(Z, M);

%% trial condition indices

isGood = cellfun(@(d) any(d.codes(:,1) == 150), Z);
isCond = @(Z, cond) cellfun(@(d) ...
    ~isempty(strfind(d.movieprefix, cond)), Z);
isHCont = isCond(Z, 'hCont');
isCGrid = isCond(Z, 'cGrid');

%% RF for single condition

% https://en.wikipedia.org/wiki/Spike-triggered_average
% http://www.cns.nyu.edu/pub/eero/simoncelli03c-preprint.pdf

ix = isHCont & ~isCGrid;
repeatVal = mode(cellfun(@(x) x.suffix, Z(ix)));
isRepeat = cellfun(@(x) x.suffix, Z) == repeatVal;

% ixKeep = ix & isGood;
ixKeep = ix & isGood & ~isRepeat;
X0 = cell2mat(X(ixKeep));
X0m = X0 - mean(X0(:));
Y0 = cell2mat(Y(ixKeep)); % each trial now becomes 20 trials
Y0m = Y0 - repmat(mean(Y0), size(Y0,1), 1);

% remove first stim on each trial
ix = true(size(X0,1),1);
ix(1:20:end) = false;
X0 = X0(ix,:);
Y0 = Y0(ix,:);
X0m = X0m(ix,:);
Y0m = Y0m(ix,:);

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

Xxy = tools.cartesianProductSquare([1:22; 1:22]);
D = asd.sqdist.space(Xxy);
imagesc(D);

%% plot normalized spike rate for each stim pulse

[Yr, xs] = io.loadSpikeTimes(Z, 20, 0, 0);
Yall = cat(3, Yr{:});
Ymean = mean(Yall,3);
figure; hold on;
for ii = 1:5%size(Yall,1)
    ym = Ymean(:,ii);
%     plot(xs, ym./sum(ym));
    plot(xs, ym);
end

%%

objs = cell(size(Y0,2),1);
for ii = [18 45]%1:size(Y0,2)
    objs{ii} = evaluateLinearModel(X0m, Y0(:,ii), D, 'ML');
    obj = objs{ii};
end

%%

nd = 32;
figure;
for ii = 1:size(STA,2)
    clf;
    colormap gray;
    sta = reshape(STA(:,ii), nd, nd);
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

nlags = 20;
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
