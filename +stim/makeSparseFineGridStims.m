%% set preferences

% stimulus info
ntrials = 100;
trialLengthSec = 2.0;
pulsesPerSec = 10;
nrows = 32;
ncols = 32;
pixelsPerElem = 4;
stimContrast = 1.0;
npulses = trialLengthSec*pulsesPerSec;
stimDist = 'sparse';

% output info
prefix = 'sps_fGrid_';
stimDirName = ['stim_mats_' datestr(now, 'yyyymmdd')];

%% create and write stimuli

optsSparseFineGrid = struct(...
    'randSeed', nan, ...
    'ntrials', ntrials, ...
    'npulses', trialLengthSec*pulsesPerSec, ...
    'shape', [nrows ncols], ...
    'pixelsPerElem', pixelsPerElem, ...
    'stimContrast', stimContrast, ... % 0 <= contrast <= 1
    'stimOffset', 127.5, ... % mean gray level
    'stimDist', stimDist);

X = stim.makeTrials(optsSparseFineGrid, stimDirName, prefix);

%% view example trial

if exist('doShow', 'var') && doShow
    figure;
    ntrials = 1;
    for ii = 1:ntrials
        stim.showTrial(X{ii}, 0.3)
    end
end

%% load stimuli

% [X, optsSparseFineGrid] = io.loadStimulusMovies(outdir, prefix);
