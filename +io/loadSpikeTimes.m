function [Y, bins, tix] = loadSpikeTimes(Z, nbinsStim, ...
    preStimSecs, postStimSecs)
% Y{ii} is an [nbins x nchannels] matrix of spike counts
%    on the (ii)th trial
% 
% nbins0 - number of bins during stimulus presentation
% 

if nargin < 2
    nbinsStim = Z{1}.numframes/Z{1}.dwell; % number of distinct stimuli
    % nbinsStim = trialLengthSec/0.01;
end
if nargin < 3
    preStimSecs = 0;
end
if nargin < 4
    postStimSecs = 0;
end

if isfield(Z{1}, 'Diodeval')
    startTimes = cellfun(@(z) find(z.Diodeval > 500, 1)/30000, ...
        Z, 'uni', 0);
else
    startTimes = cellfun(@(z) z.stimstart, Z, 'uni', 0);
end

keepTrialCode = 150;
trialLengthSec = 2;
% latencySec = 0.08;
latencySec = 0.038;

ntrials = numel(Z);
nchannels = size(Z{1}.channels, 1);

minTime = preStimSecs;
maxTime = trialLengthSec + postStimSecs;
bins = linspace(0, trialLengthSec, nbinsStim+1); % stim bins
bins2 = linspace(minTime, 0, -minTime/(bins(2)-bins(1)) + 1);
bins3 = linspace(trialLengthSec, maxTime, ...
    (maxTime-trialLengthSec)/(bins(2)-bins(1)) + 1);
bins = [bins2(1:end-1) bins bins3(2:end)];

nbins = numel(bins);

Y = cell(ntrials,1);
tix = true(ntrials,1);
% Y = nan(ntrials, nchannels, nbins);
for ii = 1:ntrials
    z = Z{ii};
    
    % if trial is not aborted
    if ~any(z.codes(:,1) == keepTrialCode) % reward not received
        tix(ii) = false;
        continue;
    end
    ycs = nan(nchannels, nbins);
    for jj = 1:nchannels
        y = z.spikes(z.spikes(:,1) == jj,3) - latencySec - startTimes{ii};
        ix = y >= minTime & y <= maxTime;
        y = y(ix);
        yc = histc(y, bins)';
        ycs(jj,:) = yc; % ignore spikes matching trial end
    end
    Y{ii} = ycs';
end

Y = cat(3, Y{:});
Y = permute(Y, [2 3 1]); % ncells x ntrials x npulses

if size(Y,3) > nbinsStim && preStimSecs == 0 && postStimSecs == 0
    bins = bins(1:nbinsStim);
    Y = Y(:,:,1:nbinsStim);
end

end
