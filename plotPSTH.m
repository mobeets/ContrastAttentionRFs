%% check PSTH

[Yr, xs0] = io.loadSpikeTimes(Z, 200, -1, 1);
Ymean = squeeze(mean(Yr,2));
figure; hold on;
for ii = 1:5%size(Yall,1)
    ym = Ymean(ii,:);
%     plot(xs, ym./sum(ym));
    plot(xs0, ym);
end
