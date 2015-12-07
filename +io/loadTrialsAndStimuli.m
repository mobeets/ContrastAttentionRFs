function [Z, X, M] = loadTrialsAndStimuli(fnm, stimdir, Z, M, fieldnm)
% fnm - trial info filename (relative to 'data' dir)

if nargin < 2 || isempty(stimdir)
    [~, fnm0] = fileparts(fnm);
    dtstr = fnm0(3:10);
    stimdir = ['data/stim_mats_' dtstr];
end
if nargin < 5
    fieldnm = 'mov';
end

%% load trial info

if nargin < 3
    Z = io.loadTrials(fnm);
end

%% load movies

if nargin < 4
    suffixes = unique(cellfun(@(z) z.movieprefix(9:end-1), Z, 'uni', 0));
    for ii = 1:numel(suffixes)
        suff = suffixes{ii};
        nr = io.inferPixelRepeats(suff, fnm);
%         if strcmpi(suff(1:3), 'ica')
%             fieldnm = 'ica_mixers';
%             nr = 1;
%             warning('Loading ica_mixers.');
%         else
%             fieldnm = 'mov';
%         end
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

% discretize if no more than 3 unique vals within a condition
unx = numel(unique(X(:)));
if unx < 10
    warning(['quickly binarizing; ' num2str(unx) ' unique vals.']);
    X(X<0) = -1;
    X(X>0) = 1;
end
% super slow:
% X = permute(X, [2 1 3]);
% conds = io.stimulusCondGroup(Z);
% X = io.discretizeStimIfBinary(X, conds);
% X = permute(X, [2 1 3]);

end
