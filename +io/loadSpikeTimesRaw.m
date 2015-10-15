function Y = loadSpikeTimesRaw(D)
% Y{ii} is an [nbins x nchannels] matrix of spike counts
%    on the (ii)th trial
% 
% n.b. might want to subtract latency...
% 

keepTrialCode = 150;
latencySec = 0.0;
binSz = 0.2; % 200msec bin size

ntrials = numel(D);
nchannels = size(D{1}.channels, 1);

Y = cell(ntrials,1);
% Y = nan(ntrials, nchannels, nbins);
for ii = 1:ntrials
    x = D{ii};
    bins = 0:binSz:(x.endTime - x.startTime);
    nbins = numel(bins);
    
    % if trial is not aborted
    if ~any(x.codes(:,1) == keepTrialCode) % reward received
        continue;
    end
    ycs = nan(nchannels, nbins);
    for jj = 1:nchannels        
        y = x.spikes(x.spikes(:,1) == jj,3) - latencySec;
        yc = histc(y, bins)';
        ycs(jj,:) = yc(1:end); % ignore spikes matching trial end
    end
    Y{ii} = ycs';
end

end
