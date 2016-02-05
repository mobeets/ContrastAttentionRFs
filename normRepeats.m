%% load

fnms = io.getFilenames()
fnm = fnms{end}
[ZA, XA, M] = io.loadTrialsAndStimuli(fnm);
latencySecs = 0.03;
YA = io.loadSpikeTimes(ZA, nan, nan, nan, latencySecs);

pulses = 2:20;
X0 = XA(:,:,pulses);
Y0 = YA(:,:,pulses);

keepRepeats = true;
[conts, grids, conds_all] = io.detectConditions(ZA);
[~, ZB, XB, YB] = io.filterTrials(ZA, keepRepeats, conts{1}, grids{1}, ...
    X0, Y0);
X = XB(1:end,:)';
Y = YB(1:end,:)';

%%

nrm = @(y1, y2) norm(y1-y2);
[C,IA,IC] = unique(X, 'rows');
cs = sort(unique(IC));

%% stim locs

nd = 16;
locs = nan(size(X,1), 2);
for ii = 1:size(X,1)
    [ix,iy] = find(reshape(X(ii,:), nd, nd) > 0);
    locs(ii,:) = [ix iy];
end

%% gather noise and signal norms

distf = @(ix, iy) norm(locs(ix,:) - locs(iy,:));
nsamps = 20;
nses = cell(nd,nd);
sigs = cell(nd,nd);
dists = cell(nd,nd);
pos = cell(nd,nd);
pos0 = cell(nd,nd);

for ix = 1:nd
    for iy = 1:nd
        ix1 = (locs(:,1) == ix & locs(:,2) == iy);
        ix2 = (locs(:,1) ~= ix & locs(:,2) ~= iy);
        vsNse = signse.pairwiseNorms(Y(ix1,:), nrm);
        ix0 = ~isnan(vsNse);
        nses{ix,iy} = vsNse(ix0);
        pos0{ix,iy} = sub2ind([nd nd], ix, iy)*ones(size(vsNse(ix0)));
        
        [vsSig, ais, bis] = signse.pairwiseGroups(Y(ix1,:), Y(ix2,:), ...
            nrm, nsamps);
        inds1 = 1:size(Y,1); inds1 = inds1(ix1);
        inds2 = 1:size(Y,1); inds2 = inds2(ix2);
        
        ix0 = ~isnan(vsSig);
        sigs{ix,iy} = vsSig(ix0);
        ais = ais(ix0);
        bis = bis(ix0);
        
        ds = arrayfun(@(ii) distf(inds1(ais(ii)), inds2(bis(ii))), ...
            1:numel(ais));
        if isempty(ds)
            ds = [];
        end
        dists{ix,iy} = ds;
        pos{ix,iy} = sub2ind([nd nd], ix, iy)*ones(size(ds));        
    end
end

xs = cell2mat(nses(:));
ys = cell2mat(sigs(:));
ds = [dists{:}]';
ps = [pos{:}]';
ps0 = cell2mat(pos0(:));

%% plot norm as a function of distance

ds0 = [ds; zeros(size(xs))];
ys0 = [ys; xs];
ps0 = [ps; ps0];
% ps0 = [ps; zeros(size(xs))];

% show only data including stimuli upper left
[xx,yy] = meshgrid(1:6, 1:6);
inds1 = sub2ind([nd nd], xx(:), yy(:));
ix = ismember(ps0, inds1);
ds0 = ds0(ix);
ys0 = ys0(ix);
ps0 = ps0(ix);

[ds0, ix] = sort(ds0);
ys0 = ys0(ix);

figure; box off; set(gcf, 'color', 'w');
hold on; set(gca, 'FontSize', 14);
plot(ds0, ys0, '.');
plot(ds0, smooth(ds0, ys0), '-', 'LineWidth', 3); % basically mean per ds

xlabel('stimulus distance');
ylabel('distance of population responses');

%% noise distribution

vsNse = cell(numel(cs),1);
vsNseInds = cell(numel(cs),1);
for ii = 1:numel(cs)
    ix = (IC == cs(ii));
    Ys = Y(ix,:);
    vsNse{ii} = signse.pairwiseNorms(Ys, nrm);
end
vsNse = cellfun(@(c) c(~isnan(c)), vsNse, 'uni', 0);

%% signal distribution

nsamps = 20;
vsSig = cell(numel(cs), 1);
for ii = 1:numel(cs)
    ix1 = (IC == cs(ii));
    ix2 = (IC ~= cs(ii));
    vsSig{ii} = signse.pairwiseGroups(Y(ix1,:), Y(ix2,:), nrm, nsamps);
end
vsSig = cellfun(@(c) c(~isnan(c)), vsSig, 'uni', 0);

%% compare hists

ys1 = cell2mat(vsSig);
ys2 = cell2mat(vsNse);

figure;
set(gcf, 'color', 'w');
mx = max(max(ys1), max(ys2));
bins = linspace(0, mx);

subplot(2,1,1);
hold on;
set(gca, 'FontSize', 14);
box off;
hist(ys1, bins);
xlabel('norm of signal difference');

subplot(2,1,2);
hold on;
set(gca, 'FontSize', 14);
box off;
hist(ys2, bins);
xlabel('norm of noise difference');

%% plot mean per condition

figure;
set(gcf, 'color', 'w');
hold on;
set(gca, 'FontSize', 14);
box off;
prcs = [40 50 60];

for ii = 1:numel(vsSig)
    v1c = vsNse{ii}; v2c = vsSig{ii};
    v1 = prctile(v1c, prcs);
    v2 = prctile(v2c, prcs);
    plot([v1(1) v1(3)], [v2(2) v2(2)], 'k-');
    plot([v1(2) v1(2)], [v2(1) v2(3)], 'k-');
    
%     plot([v1(2) v1(2)], [min(v2c) max(v2c)], 'k-');
end
xlabel('median of norm of noise difference, per condition');
ylabel('range of norm of signal difference, per condition');
xl = xlim; yl = ylim; mn = min(xl(1), yl(1)); mx = max(xl(2), yl(2));
xlim([mn mx]); ylim(xlim);
plot(xlim, ylim, 'k--');
axis square;

%%

nd = 16;
cls = nan(numel(cs),2);
for ii = 1:numel(cs)
    inds1 = find(IC == cs(ii));
    x = reshape(X(inds1(1),:), nd, nd);
    [vx, vy] = find(x == 1); % index of cell with 1
    cls(ii,:) = [vx vy];
end
meds = cellfun(@(c) median(c), vsNse);
med = nan(nd, nd);
for ii = 1:size(cls,1)
    v = cls(ii,:);
    med(v(1), v(2)) = meds(ii);
end

figure;
set(gcf, 'color', 'w');
hold on;
set(gca, 'FontSize', 14);
box off;
colormap(gray);
imagesc(med);
% caxis([0 max(med(:))]);
title('median norm of sig difference, per location');
axis off;
ax = gca;
ax.YDir = 'reverse';
colorbar;
