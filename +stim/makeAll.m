% 120 frames/sec, change every 10 Hz => show each pulse for 12 frames
% mean gray is 128
% for a given trial, save X as mat file where
%   numel(X) = # trials
%   X{i} = matrix for ith display
%       and will need to instruct to dwell on each display for n frames

t0 = 0.3;
t1 = 2.0;
tMean = 1.0;

ntrials = 100;
trialLengthSec = 2.0;
pulsesPerSec = 10;

npulses = 50;
nrows = [12 32];
ncols = [12 32];
pixelsPerElem = [16 6];
stimContrast = [1.0 0.2];

opts = struct(...
    'randSeed', nan, ...
    'ntrials', ntrials, ...
    'trialLengthSec', trialLengthSec, ...
    'pulsesPerSec', pulsesPerSec, ...
    'npulses', npulses, ...
    'shape', [nrows(1) ncols(1)], ...
    'pixelsPerElem', pixelsPerElem(1), ...
    'stimContrast', stimContrast(1), ... % 0 <= contrast <= 1
    'stimOffset', 127.5); % mean gray level

optsHighContrastCoarseGrid = opts;

optsHighContrastFineGrid = optsHighContrastCoarseGrid;
optsHighContrastFineGrid.pixelsPerElem = pixelsPerElem(2);
optsHighContrastFineGrid.shape = [nrows(2) ncols(2)];

optsLowContrastCoarseGrid = optsHighContrastCoarseGrid;
optsLowContrastCoarseGrid.stimContrast = stimContrast(2);

optsLowContrastFineGrid = optsHighContrastFineGrid;
optsLowContrastFineGrid.stimContrast = stimContrast(2);

optsGaussCoarseGrid = optsHighContrastCoarseGrid;
optsGaussCoarseGrid.stimDist = 'gauss';
optsGaussCoarseGrid.stimContrast = stimContrast(2);

%% save all

outdir = 'stim_mats';

seed = randi(1e5);
optsHighContrastCoarseGrid.randSeed = seed;
optsLowContrastCoarseGrid.randSeed = seed;

X1 = stim.makeTrials(optsHighContrastCoarseGrid, outdir, 'hCont_cGrid_');
X3 = stim.remakeTrialsNewContrast(X1, optsLowContrastCoarseGrid, ...
    outdir, 'lCont_cGrid_');

rng('shuffle');
seed = randi(1e5);
optsHighContrastFineGrid.randSeed = seed;
optsLowContrastFineGrid.randSeed = seed;

X2 = stim.makeTrials(optsHighContrastFineGrid, outdir, 'hCont_fGrid_');
X4 = stim.remakeTrialsNewContrast(X2, optsLowContrastFineGrid, ...
    outdir, 'lCont_fGrid_');
rng('shuffle');

X5 = stim.makeTrials(optsGaussCoarseGrid, outdir, 'gauss_cGrid_');

