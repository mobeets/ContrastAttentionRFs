%% check PSTH

[Yr, xs0] = io.loadSpikeTimes(Z, 200, -1, 1);
Ymean = squeeze(mean(Yr,2));
%%
figure; hold on;
for ii = 1%size(Yall,1)
    ym = Ymean(ii,:);
%     plot(xs, ym./sum(ym));
    plot(xs0, ym);
end

%% response per stimulus

ix0 = find(xs0==0.2):find(xs0==2);
xs1 = xs0(ix0);

nb = 10;
xsa = 1:nb:(numel(xs1)-1);
xsb = nb+1:nb:(numel(xs1)+1);

Yr0 = Yr(:,:,ix0);

yys = nan(numel(xsa), size(Yr,1), size(Yr,2), nb);
for ii = 1:numel(xsa)
    yy = Yr0(1:end,:,xsa(ii):xsb(ii)-1);
    yys(ii,:,:,:) = yy(1:end,:,:);
end
yys = permute(yys, [2 4 1 3]);
yys = yys(1:end,1:end,:);

%%

% 26, 69
% 22, 6

prcs = prctile(squeeze(sum(yys,2))', [20 80]);
[(1:96); prcs(2,:) - prcs(1,:)]

cellind = 22;
yy0 = squeeze(yys(cellind,:,:));
sps = sum(yy0);

ss = prctile(sps, [20 80]);

yA = yy0(:,sps <= ss(1));
yB = yy0(:,sps >= ss(2));

close all;
plot(mean(yA,2));
hold on;
plot(mean(yB,2));

