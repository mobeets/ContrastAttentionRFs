

[conts, grids, conds_all] = io.detectConditions(ZA);
isHCont = cellfun(@(c) ~isempty(strfind(c, 'hCont')), conds_all);

close all;
[Yr, xs0] = io.loadSpikeTimes(ZA, 400, -0.2, 0.2, 0);

%%

close all;
cellinds = [1]; % 65
Yrh = squeeze(mean(Yr(:,isHCont,:),2));
plot.psth(ZA, cellinds, 0, xs0, Yrh);

Yrl = squeeze(mean(Yr(:,~isHCont,:),2));
plot.psth(ZA, cellinds, 0, xs0, Yrl);

%%

cellind = 1;
Yrc = squeeze(Yr(cellind,:,:));
suffs = cellfun(@(z) z.suffix, ZA);
% [~,ix] = sort(suffs);
% Yrc2 = Yrc(ix,:);
% Yr1 = Yrc2(isHCont,:);
% Yr2 = Yrc2(~isHCont,:);

sfs = sort(unique(suffs));
Yr1 = nan(numel(sfs),size(Yrc,2));
ns1 = nan(numel(sfs),1);
Yr2 = nan(numel(sfs),size(Yrc,2));
ns2 = nan(numel(sfs),1);
for ii = 1:numel(sfs)
    sf = sfs(ii);
    ix1 = isHCont & (suffs == sf);
    ix2 = ~isHCont & (suffs == sf);
    Yr1(sf,:) = sum(Yrc(ix1,:));
    Yr2(sf,:) = sum(Yrc(ix2,:));
    ns1(sf) = sum(ix1);
    ns2(sf) = sum(ix2);
end

div1 = repmat(ns1, [1 size(Yrc,2)]);
div2 = repmat(ns2, [1 size(Yrc,2)]);
Yr1 = Yr1./div1;
Yr2 = Yr2./div2;

close all;

figure;
plot(xs0, Yr1(17,:)-Yr2(17,:));

figure;
plot(xs0, Yr1(17,:));
hold on;
plot(xs0, Yr2(17,:));

figure;
plot(xs0, mean(Yr1-Yr2));

figure;
plot(xs0, mean(Yr1));
hold on;
plot(xs0, mean(Yr2) + min(mean(Yr1)));

