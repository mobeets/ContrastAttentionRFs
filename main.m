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
    'randSeed', randi(1e3), ...
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

%% save all

outdir = 'stim_mats';
X1 = makeTrials(optsHighContrastCoarseGrid, outdir, 'hCont_cGrid_');
X2 = makeTrials(optsHighContrastFineGrid, outdir, 'hCont_fGrid_');
X3 = makeTrials(optsLowContrastCoarseGrid, outdir, 'lCont_cGrid_');
X4 = makeTrials(optsLowContrastFineGrid, outdir, 'lCont_fGrid_');

