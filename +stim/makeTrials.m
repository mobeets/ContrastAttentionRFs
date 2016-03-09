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
    elseif isfield(opts, 'stimDist') && strcmpi(opts.stimDist, 'natural')
        X = stim.makeTrial_natural(opts);
    else
        X = cell(opts.ntrials,1);
        for ii = 1:opts.ntrials    
            opts.npulses = round(ts(ii)*opts.pulsesPerSec);
            X{ii} = stim.makeTrial(opts);
        end
    end
    if ~exist('S', 'var')
        S = {};
    end

    % save all to .mat
    stim.safeSave(X, S, opts, prefix, outdir);

end
