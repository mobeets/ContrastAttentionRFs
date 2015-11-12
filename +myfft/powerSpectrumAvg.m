%% average power spectrum across all images

nd = sqrt(numel(X(1,:)));
impfs = nan(size(X,1), nd, nd);
for ii = 1:size(X,1)
    im = X(ii,:);
    im = reshape(im,nd,nd);
    imf = fftshift(fft2(im));
    impf = abs(imf).^2;
    impfs(ii,:,:) = impf;
end

impm = squeeze(mean(impfs));
figure; colormap gray; imagesc(impm);

%% Compute radially average power spectrum

[xx, yy] = meshgrid(-nd/2:nd/2-1, -nd/2:nd/2-1);
[theta rho] = cart2pol(xx, yy);
rho = round(rho);
rhou = unique(rho);
for ii = 1:numel(rhou)
    ix = find(rhou(ii) == rho);
    v(ii) = nanmean(impm(ix));
end
figure; plot(v);
