function [X, S] = makeTrial_ICA(opts)
% A = load('data/ICA.mat');
% A = A.G;

A = opts.A;
nc = size(A,2);

ntrials = opts.ntrials;
npulses = opts.npulses;

ncols = opts.shape(1);
nrows = opts.shape(2);
if ncols ~= nrows
    error('Stimulus shape must be square');
end
if ncols ~= sqrt(size(A,1))
    error('Stimulus shape must be the same size as ICA mixing matrix');
end

S = normrnd(0, 1, ntrials*npulses, nc);
X = S*A';

X = X*(127/max(abs(X(:))));
X = round(X);
if min(round(X(:))) < -128 || max(round(X(:))) > 128
    error('X out of bounds');
end

X0 = reshape(X, [ntrials*npulses, ncols, nrows]);
S0 = reshape(S, [ntrials*npulses, ncols, nrows]);

X = cell(ntrials,1);
S = cell(ntrials,1);
for ii = 1:ntrials
    X{ii} = cell(npulses,1);
    S{ii} = cell(npulses,1);
    for jj = 1:npulses
        s = squeeze(S0((ii-1)*npulses+jj,:,:));
        x = squeeze(X0((ii-1)*npulses+jj,:,:));
        if isfield(opts, 'pixelsPerElem') && opts.pixelsPerElem > 1
            x = repelem(x, opts.pixelsPerElem, opts.pixelsPerElem);
        end
        X{ii}{jj} = x;
        S{ii}{jj} = s;
    end
end

end
