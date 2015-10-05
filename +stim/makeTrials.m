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
X = cell(opts.ntrials,1);
for ii = 1:opts.ntrials    
    opts.npulses = round(ts(ii)*opts.pulsesPerSec);
    X{ii} = stim.makeTrial(opts);
end

if isempty(outdir)
    return;
end

% save all to .mat
for ii = 1:opts.ntrials
    outfile = fullfile(outdir, [prefix num2str(ii)]);
    mov = X{ii};
    save(outfile, 'mov', 'opts');
end

end
