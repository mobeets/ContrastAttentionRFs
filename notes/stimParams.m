
ppd = 27.9;

% spatial grid
nDegsPerSide = 4;
nPixelsPerSide = ppd*nDegsPerSide;
nCellsPerDeg = 3;
nCells = nDegsPerSide*nCellsPerDeg;

% feature grid
nOris = 4;
nSFreqs = 4;
nConds = nOris*nSFreqs;

% stimulus grid = spatial x feature
nStims = nConds*(nCells^2);

% trial info
nStimsPerSec = 30; % Hz
nSecsPerTrial = 2; % secs
nStimsPerTrial = nStimsPerSec*nSecsPerTrial;

% experiment info
nRepsPerCond = 5;
nTrials = nRepsPerCond*nStims/nStimsPerTrial;
nSecs = nTrials*(nSecsPerTrial+1.0);
disp(['You need ' num2str(nTrials) ' trials ' ...
    '(~' num2str(nSecs/60) ' minutes).']);
