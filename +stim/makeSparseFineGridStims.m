
ntrials = 100;
trialLengthSec = 2.0;
pulsesPerSec = 10;
nrows = 32;
ncols = 32;
pixelsPerElem = 4;
stimContrast = 1.0;
npulses = trialLengthSec*pulsesPerSec;
stimDist = 'sparse';
prefix = 'sps_fGrid_';

optsSparseFineGrid = struct(...
    'randSeed', nan, ...
    'ntrials', ntrials, ...
    'trialLengthSec', trialLengthSec, ...
    'pulsesPerSec', pulsesPerSec, ...
    'npulses', npulses, ...
    'shape', [nrows ncols], ...
    'pixelsPerElem', pixelsPerElem, ...
    'stimContrast', stimContrast, ... % 0 <= contrast <= 1
    'stimOffset', 127.5, ... % mean gray level
    'stimDist', stimDist);

stimdir = getpref('contrastAttentionRFs', 'stimdir');
outdir = fullfile(stimdir, ['stim_mats_' datestr(now, 'yyyymmdd')]);
X = stim.makeTrials(optsSparseFineGrid, outdir, prefix);

%%

if exist('doShow', 'var') && doShow
    figure;
    ntrials = 1;
    for ii = 1:ntrials
        stim.showTrial(X{ii}, 0.3)
    end
end

% to load:
% [X, optsSparseFineGrid] = io.loadStimulusMovies(outdir, prefix);
