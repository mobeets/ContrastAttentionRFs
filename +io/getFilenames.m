function fnms = getFilenames(expdir)
if nargin < 1
    expdir = fullfile('data', 'exps');
end
fnms = dir(fullfile(expdir, '*2015*_trialinfo.mat'));
[~,ix] = sort([fnms.datenum]);
fnms = {fnms(ix).name}';
fnms = cellfun(@(f) fullfile(expdir, f), fnms, 'uni', 0);

end
