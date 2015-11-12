%% random weights in fourier space

% need nd to be odd or else you get weird orientation bias due to aliasing
nd = 101;
wDeg = 5;
N = 100;

% S = randn([N, nd, nd]);
S = normrnd(0,1,[N nd nd]);
I = nan(N,nd,nd);
for ii = 1:N
    I(ii,:,:) = myfft.invPow(nd, wDeg, squeeze(S(ii,:,:)));
end
% I = I*(127/max(abs(I(:))));
% I = round(I);
% I = I + 128;

%%

[img,nse] = myfft.invPow(nd, wDeg);
close all;
figure; colormap gray;
imagesc(nse)
myfft.plotFFT2(img);

%%

img = squeeze(I(randi(N),:,:));
myfft.plotFFT2(img);

%% show stimuli

figure; colormap gray;
for ii = 1:N
    img = squeeze(I(ii,:,:));
    imagesc(img);
    pause(0.2);
    caxis([0 255]);
end

%% show stimuli avg power spectrum

amps = zeros(nd,nd);
for ii = 1:N
    img = squeeze(I(ii,:,:));
    F = myfft.myfft2(img);
    amps = amps + F.amp;
end
figure; colormap gray; imagesc(amps)

%%

snr = 3;
max_rsq = snr/(snr+1);
ssq = var(X*w)/snr;
e = normrnd(0,sqrt(ssq),ntrials,1);
Y = round(X*w + e);
Y = Y - min(Y) + 3;
hist(Y)

%% regress on S

obj = evaluateLinearModel(S, Y, nan, 'ML');
whh = A*obj.w;
disp(['r-sq = ' num2str(obj.score) ...
    ' (max possible is ' num2str(max_rsq) ')']);

figure; colormap gray;
subplot(1,2,1); hold on;
imagesc(reshape(w, nd, nd));
axis off; axis square;
title('true RF');

subplot(1,2,2); hold on;
imagesc(reshape(whh, nd, nd));
axis off; axis square;
title('est. RF');
