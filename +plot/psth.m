function [Ymean, Yr, xs0] = psth(Z, cellinds, latencySec, xs0, Ymean)
if nargin < 3
    latencySec = nan;
end
if nargin < 4
    [Yr, xs0] = io.loadSpikeTimes(Z, 200, -1, 1, latencySec);
    Ymean = squeeze(mean(Yr,2));
end

for ii = cellinds
    ym = Ymean(ii,:);
%     ym = ym./mean(ym(1:10));
    plot(xs0, ym);
    yl = ylim;

    hold on;
    for jj = 0:0.1:2
        plot([jj jj], [0 5], 'Color', [0.8 0.8 0.8]);
    end
    ylim(yl);
end

end
