function [Z, X, M] = loadTrialsAndStimuli(fnm, stimdir, Z, M, fieldnm)
% fnm - trial info filename (relative to 'data' dir)

if nargin < 5
    fieldnm = 'mov';
end
keepTrialCode = 150;
nrmap = {'lCont_cGrid', 'hCont_cGrid', ...
    'lCont_fGrid', 'hCont_fGrid', 'gauss_cGrid', 'ica_fGrid1', ...
    'sps_fGrid', 'sps_cGrid'};
nrval = [8 8 4 4 4 4 4 8];

%% load trial info

if nargin < 3
    fn = fullfile('data', fnm);
    Z = load(fn);
    Z = Z.TrialInfo;

    ixGood = cellfun(@(z) any(z.codes(:,1) == keepTrialCode), Z);
    Z = Z(ixGood);
end

%% load movies

if nargin < 4
    suffixes = unique(cellfun(@(z) z.movieprefix(9:end-1), Z, 'uni', 0));
    for ii = 1:numel(suffixes)
        suff = suffixes{ii};
        nr = nrval(strcmp(suff, nrmap));
        if false %strcmpi(suff(1:3), 'ica')
            fieldnm = 'ica_mixers';
        else
            fieldnm = 'mov';
        end
        M.(suff) = io.loadStimulusMovies(stimdir, suff, nan, nr, fieldnm);
    end
end

%% match movie frames with trials

X = io.loadStimuliPerTrial(Z, M);
X = cat(3, X{:});
X = permute(X, [2 3 1]); % nd x ntrials x npulses

if strcmp(fieldnm, 'ica_mixers')
    if numel(suffixes) > 1
        % if other suffixes exist, we won't go below
        warning('Sorry, not checking for out of bounds pixels.');
    end
    return;
end

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
