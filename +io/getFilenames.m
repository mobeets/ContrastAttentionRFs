function fnms = getFilenames(expdir)
    if nargin < 1
        expdir = fullfile('data', 'exps');
    end

%     basedir = '/Users/mobeets/Box Sync/Work/CMU/Cohen/RFAtt';
%     setpref('ContrastAttentionRFs', 'datadir', basedir);
    basedir = getpref('ContrastAttentionRFs', 'datadir');
    fnms = dir(fullfile(basedir, expdir, '*2015*_trialinfo.mat'));
    [~,ix] = sort([fnms.datenum]);
    fnms = {fnms(ix).name}';
    fnms = cellfun(@(f) fullfile(basedir, expdir, f), fnms, 'uni', 0);

end
