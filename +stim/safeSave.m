function safeSave(X, S, opts, prefix, outdir)

    if isempty(outdir)
        return;
    end
    if ~exist(outdir, 'dir')
        mkdir(outdir);
    end
    outdir = getFullOutputDir(outdir);
    
    askedOnce = false;
    for ii = 1:opts.ntrials
        outfile = fullfile(outdir, [prefix num2str(ii)]);
        if ~askedOnce && exist([outfile '.mat'], 'file')
            if ~okayWithOverwrite(outdir)
                return;
            end            
            askedOnce = true;
        end
        
        mov = X{ii};
        if ~isempty(S)
            ica_mixers = S{ii};
            save(outfile, 'mov', 'opts', 'ica_mixers');
        else
            save(outfile, 'mov', 'opts');
        end
    end
    disp(['Saved ' num2str(numel(X)) ' stimuli to ' outdir]);
end

function outdir = getFullOutputDir(outdir)
    if ~ispref('contrastAttentionRFs', 'stimdir')
        disp(' ');
        disp('EXAMPLE: ');
        disp('setpref(''contrastAttentionRFs'', ''stimdir'', ''/path/example'')');
        error('You must set the base directory for stimuli using the example above.');
    else
        stimBaseDir = getpref('contrastAttentionRFs', 'stimdir');
    end
    outdir = fullfile(stimBaseDir, outdir);
end

function isOk = okayWithOverwrite(outdir)
    warning(['Files in ' outdir ' already exist.']);
    reply = input('Overwrite? (y/n) ', 's');
    if ~strcmpi(reply(1), 'y')
        disp('Quitting without saving.');
        isOk = false;
    else
        isOk = true;
    end
end
