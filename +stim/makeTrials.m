function X = makeTrials(opts, outdir, prefix, expTiming)

if nargin < 2
    outdir = '';
end
if nargin < 3
    prefix = 'tmp_';
end
if nargin < 4
    expTiming = false;
end

rng('shuffle');
if isfield(opts, 'randSeed')
    if ~isnan(opts.randSeed)
        rng(opts.randSeed);
    end
end

if expTiming
    ts = stim.drawTruncExpStimLength(opts.t0, opts.t1, opts.tMean, ...
        opts.ntrials);
else
    ts = opts.trialLengthSec*ones(opts.ntrials, 1);
end

% create trials
if isfield(opts, 'stimDist') && strcmpi(opts.stimDist, 'ica')
    [X, S] = stim.makeTrial_ICA(opts);
elseif isfield(opts, 'stimDist') && strcmpi(opts.stimDist, 'sparse')
    X = stim.makeTrial_sparse(opts);
else
    X = cell(opts.ntrials,1);
    for ii = 1:opts.ntrials    
        opts.npulses = round(ts(ii)*opts.pulsesPerSec);
        X{ii} = stim.makeTrial(opts);
    end
end

if isempty(outdir)
    return;
end
if ~exist(outdir, 'dir')
    warning(['outdir "' outdir '" does not exist']);
    return;
end

% save all to .mat
for ii = 1:opts.ntrials
    outfile = fullfile(outdir, [prefix num2str(ii)]);
    mov = X{ii};
    if exist('S', 'var')
        ica_mixers = S{ii};
        save(outfile, 'mov', 'opts', 'ica_mixers');
    else
        save(outfile, 'mov', 'opts');
    end
end

end
