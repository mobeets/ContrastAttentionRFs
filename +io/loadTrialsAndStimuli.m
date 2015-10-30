function [Z, X, M] = loadTrialsAndStimuli(fnm)
% fnm - trial info filename (relative to 'data' dir)

keepTrialCode = 150;
stimdir = 'stim_mats';
nrmap = {'lCont_cGrid', 'hCont_cGrid', ...
    'lCont_fGrid', 'hCont_fGrid', 'gauss_cGrid'};
nrval = [8 8 4 4 8];

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

end
