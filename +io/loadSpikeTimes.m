function Y = loadSpikeTimes(D)
% Y{ii} is an [nbins x nchannels] matrix of spike counts
%    on the (ii)th trial
% 
% n.b. might want to subtract latency...
% 

keepTrialCode = 150;
trialLengthSec = 2;
latencySec = 0.2;

ntrials = numel(D);
nchannels = size(D{1}.channels, 1);

nbins = D{1}.numframes/D{1}.dwell; % number of distinct stimuli
bins = linspace(0, trialLengthSec, nbins+1);

Y = cell(ntrials,1);
% Y = nan(ntrials, nchannels, nbins);
for ii = 1:ntrials
    x = D{ii};
    % if trial is not aborted
    if ~any(x.codes(:,1) == keepTrialCode) % reward received
        continue;
    end
    ycs = nan(nchannels, nbins);
    for jj = 1:nchannels        
        y = x.spikes(x.spikes(:,1) == jj,3) - latencySec;
        ix = y > x.stimstart & y <= x.stimstart + trialLengthSec;
        y = y(ix);
        yc = histc(y, bins)';
        ycs(jj,:) = yc(1:end-1); % ignore spikes matching trial end
    end
    Y{ii} = ycs';
end

end
