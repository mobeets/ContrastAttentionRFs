function [dSecs, dSecsAll] = optLatency(Z, cellinds, ...
    nBinsStim, Yr, xs0)
if nargin < 3
    nBinsStim = 400;
end
if nargin < 4
    [Yr, xs0] = io.loadSpikeTimes(Z, nBinsStim, -0.2, 0.2, 0);
end
Ymean = squeeze(mean(Yr,2));
nBinsPulse = nBinsStim/20;
figure;
plot.psth(Z, cellinds, 0, xs0, Ymean);

i0 = find(xs0 == 0);
inds = -20:20;

vs = nan(numel(inds), numel(cellinds));
for jj = 1:numel(cellinds)
    for ii = 1:numel(inds)
        ix0 = i0 + inds(ii);
        vs(ii,jj) = sum(Ymean(cellinds(jj), ...
            ix0:nBinsPulse:(ix0+nBinsStim)));
    end
end
dSecsAll = nan(numel(cellinds),1);
for ii = 1:numel(cellinds)
    figure(2); hold on;
    plot(xs0(i0 + inds), vs(:,ii)./max(abs(vs(:,ii))));
    
    % method 1: minimize vs for current cell
    [~,idx] = min(vs(:,ii)); % check around 0
    idx = inds(idx);
    
    % method 2: only consider inds >= 0, and pick last ind before vs rises
    idxs = inds((diff(vs(:,ii)) > 0) & (inds(1:end-1)' >= 0));
    idx = idxs(1);
    
    x0 = xs0(i0 + idx);
    dSecsAll(ii) = x0;
end
dSecs = median(dSecsAll);

end
