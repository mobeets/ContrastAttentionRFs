%% load trial info

% fnm = 'sy20151007mapJay0002_trialinfo.mat';
% fnm = 'SY20151029JayMovie0001_trialinfo.mat';
fnm = 'SY20151030JayMovie0002_trialinfo.mat'; % gauss
[Z, X0, M] = io.loadTrialsAndStimuli(fnm);

%% load spike counts per stimulus pulse

Y0 = io.loadSpikeTimes(Z);

%% ignore first few pulses (stimulus onset)

pulses = 3:20;
X0 = X0(:,:,pulses);
Y0 = Y0(:,:,pulses);

%% filter trials and prepare to fit

[Z2, X02, Y02, ix] = io.filterTrials(Z, X0, Y0, 'hCont', 'fGrid', false);
X = X02(1:end,:)'; % now: ntrials x nd
Y = Y02(1:end,:)'; % now: ntrials x ncells

%% truncate stim around putative rf

rfBounds = [-5 30; 5 -30];
stimCenter = [Z{1}.centerx Z{1}.centery];
nd = sqrt(size(X,2));
npixels = 128;
stimLoc = tools.stimCoords(stimCenter, nd, npixels);
[Xc, newStimLoc] = tools.shrinkStim(X, rfBounds, stimLoc);

%% fit

