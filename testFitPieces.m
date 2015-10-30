%% line up stim with real coords

np = 128;
nd = np/4;

centerx = 40;
centery = -35;
rect = [centerx-np/2 centerx+np/2; centery-np/2 centery+np/2];

m = M.lCont_fGrid{1}{1};
xx0 = linspace(rect(1,1), rect(1,2), nd);
yy0 = linspace(rect(2,1), rect(2,2), nd);
[xx, yy] = meshgrid(xx0, yy0);
figure; colormap gray;
imagesc(xx(:), yy(:), m);
set(gca, 'ydir', 'normal')

%%

% rfBounds = [-5 30; 5 -30];
% rfBounds = [25 65; -5 -45];
rfBounds = [-30 30; -20 20];
[~,ixya] = min((round(yy0) - rfBounds(2,1)).^2);
[~,ixyb] = min((round(yy0) - rfBounds(2,2)).^2);
[~,ixxa] = min((round(xx0) - rfBounds(1,1)).^2);
[~,ixxb] = min((round(xx0) - rfBounds(1,2)).^2);
vya = yy0(ixya); vyb = yy0(ixyb);
vxa = xx0(ixxa); vxb = xx0(ixxb);
if ixya > ixyb
    ixyc = ixya; ixya = ixyb; ixyb = ixyc;
    vyc = vya; vya = vyb; vyb = vyc;
end
if ixxa > ixxb
    ixxc = ixxa; ixxa = ixxb; ixxb = ixxc;
    vxc = vxa; vxa = vxb; vxb = vxc;
end
figure; colormap gray;
xx00 = linspace(vxa, vxb, ixxb-ixxa+1);
yy00 = linspace(vya, vyb, ixyb-ixya+1);
[xxx,yyy] = meshgrid(xx00, yy00);
m0 = m(ixya:ixyb, ixxa:ixxb);
imagesc(xxx(:), yyy(:), m0)
set(gca, 'ydir', 'normal')

%%

nd1 = (ixxb-ixxa+1);
nd2 = (ixyb-ixya+1);
X02 = nan(size(X0,1), nd1*nd2);
for ii = 1:size(X0,1)
    x = reshape(X0(ii,:), nd, nd);
    xx = x(ixya:ixyb, ixxa:ixxb);
    X02(ii,:) = xx(:);
end

%%

Xxy = tools.cartesianProduct({1:nd2, 1:nd1});
D = asd.sqdist.space(Xxy);

objs = cell(size(Y0,2),1);
for ii = 6%1:size(Y0,2)
    objs{ii} = evaluateLinearModel(X02, Y0(:,ii), D, 'ASD');
    obj = objs{ii};
    if obj.score > 0
        disp(ii);
    end
end

figure; colormap gray;
imagesc(xxx(:), yyy(:), reshape(objs{6}.w, nd2, nd1))

%% display spike histograms

% cells = 1:24;
% cells = cells + 24*3;
cells = [6 46 56 59]
ncells = numel(cells);
% ncells = size(Y0,2);
ncols = round(sqrt(ncells));
nrows = ceil(ncells/ncols);
figure;
for ii = 1:ncells
    subplot(nrows, ncols, ii);
    hist(Y0(:,cells(ii)));
    xlabel(cells(ii));
end

