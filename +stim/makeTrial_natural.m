function X = makeTrial_natural(opts)

nd = opts.shape(1); % size of one side of image
assert(opts.shape(1) == opts.shape(2));
npulses = opts.npulses;
ntrials = opts.ntrials;

wind = opts.window; % 'hann' window, e.g.
datadir = opts.datadir; % contains images as *.mat
contThresh = opts.minContrast; % RMS contrast minimum
maxN = opts.maxNPerImage; % max patches per image

if isfield(opts, 'stimOffset')
    stimOffset = opts.stimOffset;
else
    stimOffset = 0;
end

X = myfft.findImagePatchesHighContrast(datadir, nd, contThresh, maxN);
X = X - 0.5; % scale X from [0,1] to [-0.5, 0.5]
save('tmp.mat', 'X');

% process to scale
if strcmpi(wind, 'hann')
    m = myfft.hann2d(nd);
    for ii = 1:size(X,1)
        p = squeeze(X(ii,:,:));
        p = m.*p;
        X(ii,:,:) = p;
    end
end

X = X*(127/max(abs(X(:))));
X = X + stimOffset;
X = double(round(X));
if min(round(X(:))) < 0 || max(round(X(:))) > 255
    error('X out of bounds');
end

% make duplicates of images if not enough
if size(X,1) < ntrials*npulses
    nreps = ceil(ntrials*npulses/size(X,1));
    X = repmat(X, [nreps 1 1]);
end

% randomly arrange, and organize by trial
ps = randperm(size(X,1));
ps = ps(1:ntrials*npulses);
X0 = X(ps,:,:);

X = cell(ntrials,1);
for ii = 1:ntrials
    X{ii} = cell(npulses,1);
    for jj = 1:npulses
        m = X0((ii-1)*npulses + jj,:,:);
        m = squeeze(m);
        X{ii}{jj} = m;
    end
end

end

function showTrial(P)

figure; colormap gray;
for ii = 1:50%numel(P)
    ind = randi(size(P,1),1);
    im = squeeze(P(ind,:,:));
    imagesc(m.*(im-0.5) + 0.5);
    % caxis([-128 128]);
    caxis([0 1]);
    axis square;
    pause(0.5);
end

end
