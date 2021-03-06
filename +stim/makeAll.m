% 120 frames/sec, change every 10 Hz => show each pulse for 12 frames
% mean gray is 128
% for a given trial, save X as mat file where
%   numel(X) = # trials
%   X{i} = matrix for ith display
%       and will need to instruct to dwell on each display for n frames

% t0 = 0.3;
% t1 = 2.0;
% tMean = 1.0;

ntrials = 100;
trialLengthSec = 2.0;
pulsesPerSec = 10;

npulses = trialLengthSec*pulsesPerSec;
% nrows = [12 32];
% ncols = [12 32];
% pixelsPerElem = [16 6];
nrows = [16 32];
ncols = [16 32];
pixelsPerElem = [8 4];
stimContrast = [1.0 0.2 0.3];

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

% optsHighContrastFineGrid = optsHighContrastCoarseGrid;
% optsHighContrastFineGrid.pixelsPerElem = pixelsPerElem(2);
% optsHighContrastFineGrid.shape = [nrows(2) ncols(2)];

optsLowContrastCoarseGrid = optsHighContrastCoarseGrid;
optsLowContrastCoarseGrid.stimContrast = stimContrast(2);
% 
% optsLowContrastFineGrid = optsHighContrastFineGrid;
% optsLowContrastFineGrid.stimContrast = stimContrast(2);
% 
% optsGaussFineGrid = optsHighContrastFineGrid;
% optsGaussFineGrid.stimDist = 'gauss';
% optsGaussFineGrid.stimContrast = stimContrast(3);
% 
% A = load('data/ICA.mat'); A = A.G;
% optsIcaFineGrid = optsHighContrastFineGrid;
% optsIcaFineGrid.stimDist = 'ica';
% optsIcaFineGrid.shape = [nrows(1) ncols(1)];
% optsIcaFineGrid.A = A;
% 
% optsSparseFineGrid = optsHighContrastFineGrid;
% optsSparseFineGrid.ntrials = 100;
% optsSparseFineGrid.stimDist = 'sparse';
% optsSparseFineGrid.stimContrast = stimContrast(1);
% 
% optsSparseCoarseGrid = optsHighContrastCoarseGrid;
% optsSparseCoarseGrid.ntrials = 400;
% optsSparseCoarseGrid.stimDist = 'sparse';
% optsSparseCoarseGrid.stimContrast = stimContrast(1);
% 
% optsNaturalScenes = optsHighContrastFineGrid;
% optsNaturalScenes.ntrials = 500;
% optsNaturalScenes.stimDist = 'natural';
% optsNaturalScenes.shape = [200 200];
% optsNaturalScenes.npulses = 8;
% optsNaturalScenes.window = 'hann';
% optsNaturalScenes.datadir = 'data/scenes';
% optsNaturalScenes.minContrast = 0.25; % RMS
% optsNaturalScenes.maxNPerImage = 10; % max patches per image

%% save all

stimdir = getpref('contrastAttentionRFs', 'stimdir');
outdir = fullfile(stimdir, ['stim_mats_' datestr(now, 'yyyymmdd')]);

seed = randi(1e5);
optsHighContrastCoarseGrid.randSeed = seed;
optsLowContrastCoarseGrid.randSeed = seed;
% 
X1 = stim.makeTrials(optsHighContrastCoarseGrid, outdir, 'hCont_cGrid_');
X3 = stim.remakeTrialsNewContrast(X1, optsLowContrastCoarseGrid, ...
    outdir, 'lCont_cGrid_');
% 
% rng('shuffle');
% seed = randi(1e5);
% optsHighContrastFineGrid.randSeed = seed;
% optsLowContrastFineGrid.randSeed = seed;
% 
% X2 = stim.makeTrials(optsHighContrastFineGrid, outdir, 'hCont_fGrid_');
% X4 = stim.remakeTrialsNewContrast(X2, optsLowContrastFineGrid, ...
%     outdir, 'lCont_fGrid_');
% rng('shuffle');

% X5 = stim.makeTrials(optsGaussFineGrid, outdir, 'gauss_fGrid_');

% X6 = stim.makeTrials(optsIcaFineGrid, outdir, 'ica_fGrid1_');

% X7 = stim.makeTrials(optsSparseFineGrid, outdir, 'sps_fGrid_');
% X9 = stim.makeTrials(optsSparseCoarseGrid, outdir, 'sps_cGrid_');

% X8 = stim.makeTrials(optsNaturalScenes, outdir, 'natScenes_');

%% view examples

figure;
ntrials = 1;
for ii = 1:ntrials
    stim.showTrial(X1{ii}, 0.3)
end
