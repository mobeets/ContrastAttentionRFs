function X = loadStimuliPerTrial(Z, M)
% X{ii} is an [nbins x nstim] matrix of the stimulus values on the
%    (ii)th trial

ntrials = numel(Z);
X = cell(ntrials,1);
for ii = 1:ntrials
    z = Z{ii}; % trial info
    [~,cond] = fileparts(z.movieprefix);
    stim = M.(cond(1:end-1));
    m = stim{z.suffix}; % current movie
    x = permute(cat(3, m{:}), [3 1 2]);
    X{ii} = x(1:end,:);
%     X{ii} = cell2mat(cellfun(@(x) x(:), m, 'uni', 0)')';
end

end
