%%

% take fft of rows of stimuli
% in last experiment, compare spike counts of gauss vs hCont

%% create stimuli

% A = load('data/ICA_32v2.mat'); A = A.A;
A = load('data/ICA.mat'); A = A.G;
nd = sqrt(size(A,1));

% this dumb way of resizing ends up with duplicated pixel blocks -- duh
% but what if things were kinda staggered, like every other one?
% A2 = nan((2*nd)^2, size(A,2));
% for ii = 1:size(A,1)
%     a0 = reshape(A(:,ii), nd, nd);
%     a = imresize(a0, [2*nd+2 2*nd+2], 'bicubic');
%     a1 = a(2:end-1,2:end-1);
%     A2(:,ii) = a1(:);
% end
% A = A2;

%%

A2 = stim.loadGaborFilterBank('data');
A0 = A;
% A = tools.whiten(A, 1e-5);
nd = sqrt(size(A,1));
nc = size(A,2);
ntrials = 1000;

% S ~ normal(0, sigma)
% sigma = 50;
% sigma = 32;
% sigma = 1;

S = normrnd(0,1,ntrials,nc);
% Si = full(sprand(ntrials,nc,0.1));
% Si(Si > 0) = 1;
% S = Si.*S;

% S ~ laplace(0, sigma)
% sigma = 20;
% u = rand(ntrials,nc) - 0.5;
% S = sigma*sign(u).*log(1 - 2*abs(u));

X = S*A';
% X = X./repmat(std(X,0,2), 1, size(X,2));
(127/max(abs(X(:))))
X = X*(127/max(abs(X(:))));
range(X(:))
assert(min(round(X(:))) > -128);
assert(max(round(X(:))) < 128);
X = round(X);
close all;

%%

figure; colormap gray;
set(gcf, 'units', 'pixels', 'pos', [0 0 400 400])

for ii = 1:100
    imagesc(reshape(X(ii,:), nd, nd)+128);
    caxis([0 255]);
    axis square;
    pause(0.2);
end

%% simulate spike count response

B = A;
nc = size(B,2);

% pick random weights
ws = normrnd(0,1,nc,1)/1000;
ws(2) = 0.2; ws(21) = 0.2;
w = B*ws;

% set noise variance (and thus maximum r-sq) given SNR
%   => snr = var(X*w)/var(e), so var(e) = var(X*w)/snr
%   max r-sq = var(X*w)/var(Y) = var(X*w)/(var(X*w) + var(Y)) = snr/(snr+1)
snr = 3;
max_rsq = snr/(snr+1);
ssq = var(X*w)/snr;
e = normrnd(0,sqrt(ssq),ntrials,1);

% spike count response
% Y = round(S*ws + e);
Y = round(X*w + e);
% Y = round(S*(A'*A)*ws + e);
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

% subplot(1,3,3); hold on;
% plot(w);
% plot(whh);
