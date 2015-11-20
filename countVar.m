
nd = size(X,2);
Xi = X; Xi(Xi > 0) = 0; Xi = abs(Xi);
inds = Xi*(1:nd)';

maxreps = max(sum(Xi));
Ya = nan(nd, maxreps, size(Y,2));
Yar = nan(nd, size(Y,2));
for ii = 1:nd
    ix = (inds == ii);
    Ya(ii,1:sum(ix),:) = sort(Y(ix,:),1,'descend');
    if sum(ix) > 0
        Yar(ii,:) = var(Y(ix,:));
    end
end


close all;
figure; colormap gray; imagesc(Ya(:,:,77));
% Ya(isnan(Ya)) = -100;
colorbar;
figure; colormap gray; imagesc(reshape(Yar(:,77),sqrt(nd),sqrt(nd)));
colorbar;
caxis([0 max(Yar(:))]);
axis square; set(gca, 'YDir', 'normal');

figure;
hist(Yar(:,77));

figure;
scatter(nanmean(Ya(:,:,77),2), Yar(:,77));

figure;
hist(Yar(:,77)./nanmean(Ya(:,:,77),2));

figure;
scatter(nanmean(Ya(:,:,77),2), Yar(:,77)./nanmean(Ya(:,:,77),2));