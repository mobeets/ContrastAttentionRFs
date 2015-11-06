%% create stimuli

A = load('data/ICA.mat'); A = A.G;
A2 = stim.loadGaborFilterBank('data');
% A = tools.whiten(A, 1e-5);
nd = sqrt(size(A,1));
nc = size(A,2);
ntrials = 10000;

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

for ii = 1:10
    imagesc(reshape(X(ii,:), nd, nd)+128);
    caxis([0 255]);
    pause(0.2);
end

%% simulate spike count response

B = A;
nc = size(B,2);
ws = normrnd(0,1,nc,1)/70;
% ws(4) = 0.2;
w = B*ws;
e = normrnd(0,10,ntrials,1);
% Y = round(S*ws + e);
Y = round(X*w + e);
% Y = round(S*(A'*A)*ws + e);
Y = Y - min(Y) + 3;
hist(Y)

%% regress on S

obj = evaluateLinearModel(S, Y, nan, 'ML');
whh = A*obj.w;

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
