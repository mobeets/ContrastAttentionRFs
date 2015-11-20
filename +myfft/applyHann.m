
nd = 200;
w = hann(nd);
m = repmat(w, [1 nd]);
m = m.*m';
figure; imagesc(m);

img = double(rgb2gray(I.mov{1}));
img = img - 128;

contr = 0;
while contr < 0.25
    x = randi(size(img,1)-nd);
    y = randi(size(img,2)-nd);
    im = img(x:x+nd-1, y:y+nd-1);
    im = im - min(im(:));
    im = im/max(im(:));
    contr = std(im(:));
end


% close all;
% myfft.plotFFT2(im, [], [], 4, 0.025);
% figure; myfft.plotFFT2(m.*im, [], [], 4, 0.025);
% % myfft.plotFFT2(img, [], [], 4, 0.025);

% im = im - mean(im(:));
close all;
figure; colormap gray;
subplot(2,2,1);
imagesc(im);
% caxis([-128 128]);
caxis([0 1]);
subplot(2,2,2);
imagesc(m);
caxis([-1 1]);
subplot(2,2,3);
imagesc(m.*(im-0.5) + 0.5);
% caxis([-128 128]);
caxis([0 1]);

%%

ns = 1e4;
xs = randi(size(img,1)-nd, [ns 1]);
ys = randi(size(img,2)-nd, [ns 1]);

vs = nan(ns,1);
for ii = 1:ns
    x = xs(ii);
    y = ys(ii);
    im = img(x:x+nd-1, y:y+nd-1);
    
    % normalize to 0/1
    im = im - min(im(:));
    im = im/max(im(:));
    vs(ii) = std(im(:));
    
%     im = im - min(im(:));
%     assert(min(im(:)) == 0);
%     vs(ii) = (max(im(:)) - min(im(:)))/(min(im(:)) + max(im(:)));
end

close all;
hist(vs);


