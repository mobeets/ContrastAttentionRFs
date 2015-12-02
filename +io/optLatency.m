function [dSecs, dSecsAll, Ymean, xs0] = optLatency(ZA, cellinds, dSecs)

[Ymean, ~, xs0] = plot.psth(ZA, cellinds, dSecs);
i0 = find(xs0 == 0);
inds = -9:9;

vs = nan(numel(inds), numel(cellinds));
for jj = 1:numel(cellinds)
    for ii = 1:numel(inds)
        ix0 = i0 + inds(ii);
        vs(ii,jj) = sum(Ymean(cellinds(jj), ix0:10:(ix0+200)));
    end
end
figure; hold on;
dSecsAll = nan(numel(cellinds),1);
for ii = 1:numel(cellinds)
    plot(xs0(i0 + inds), vs(:,ii)./max(abs(vs(:,ii))));
    [~,idx] = min(vs(:,ii)); % check around 0
    x0 = xs0(i0 + inds(idx));
    dSecsAll(ii) = dSecs + x0;
end
dSecs = mean(dSecsAll);

end
