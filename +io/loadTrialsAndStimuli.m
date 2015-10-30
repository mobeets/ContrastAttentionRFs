function [Z, X, M] = loadTrialsAndStimuli(fnm, stimdir)
% fnm - trial info filename (relative to 'data' dir)

keepTrialCode = 150;
nrmap = {'lCont_cGrid', 'hCont_cGrid', ...
    'lCont_fGrid', 'hCont_fGrid', 'gauss_cGrid'};
nrval = [8 8 4 4 4];

%% load trial info

fn = fullfile('data', fnm);
Z = load(fn);
Z = Z.TrialInfo;

ixGood = cellfun(@(z) any(z.codes(:,1) == keepTrialCode), Z);
Z = Z(ixGood);

%% load movies

suffixes = unique(cellfun(@(z) z.movieprefix(9:end-1), Z, 'uni', 0));
for ii = 1:numel(suffixes)
    suff = suffixes{ii};
    nr = nrval(strcmp(suff, nrmap));
    M.(suff) = io.loadStimulusMovies(stimdir, suff, nan, nr);
end

%% match movie frames with trials

X = io.loadStimuliPerTrial(Z, M);
X = cat(3, X{:});
X = permute(X, [2 3 1]); % nd x ntrials x npulses

% remove trials where pixel values out-of-bounds
X(X<0) = nan;
X(X>255) = nan;
if any(isnan(X(:)))
    x = permute(X, [2 1 3]);
    x = x(1:end,:);
    ixBad = any(isnan(x),2);
    X = X(:,~ixBad,:);
    Z = Z(~ixBad);
end

X = X - 128; % center around mean-gray

uns = unique(X(:));
if numel(uns) == 3
    disp('binary-izing');
    nvals = sort(uns);
    assert(nvals(2)==0);
    X(X == nvals(1)) = -1;
    X(X == nvals(2)) = 0;
    X(X == nvals(3)) = 1;
end

end
