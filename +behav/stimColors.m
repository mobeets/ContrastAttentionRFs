
sz = 200;
gr = [128 128 128];
scale = 35;
nclrs = 3;

minC = 135;
maxC = 165;
clrInd = 1; % [R G B]

baseClr = [128 128 128];
clrs = repmat(baseClr, nclrs, 1);
clrs(:,clrInd) = linspace(minC, maxC, nclrs)';

close all;
figure; hold on;
for ii = 1:nclrs
    scatter(ii,1,sz,clrs(ii,:)/256,'filled');
end
axis off;
set(gca, 'color', gr/256);
set(gcf, 'color', gr/256);
