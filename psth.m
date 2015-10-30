isRep = isRepeat & isHCont & isCGrid & isGood;

yix = ~cellfun(@(x) isempty(x), Y);
Y2 = Y(yix & isRep);
% isRep = isRep(yix);


figure; hold on;

ims = nan(96,20);
nss = nan(96,20);
for ii = 1:96
    Yi = cell2mat(cellfun(@(x) x(:,ii), Y2, 'uni', 0)');
%     figure; hold on;
%     for jj = 1:size(Yi,2)
%         plot(Yi(:,jj));
%     end
    ims(ii,:) = mean(Yi,2);
    nss(ii,:) = var(Yi,[],2);
%     plot(ims(ii,:));
%     plot(nss(ii,:));
    
    scatter(ims(ii,:), nss(ii,:), '.');
    
    scatter(median(ims(ii,:)), median(nss(ii,:)), 'o', 'filled');
end
% 
% figure; colormap gray;
% imagesc(ims);
% 
% figure; colormap gray;
% imagesc(nss);
