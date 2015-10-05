function X = loadStimuliPerTrial(D, M)
% X{ii} is an [nbins x nstim] matrix of the stimulus values on the
%    (ii)th trial

ntrials = numel(D);
X = cell(ntrials,1);
for ii = 1:ntrials
    d = D{ii}; % trial info
    [~,cond] = fileparts(d.movieprefix);
    stim = M.(cond(1:end-1));
    m = stim{d.suffix}; % current movie
    X{ii} = cell2mat(cellfun(@(x) x(:), m, 'uni', 0)')';
end

end
