function safeSave(X, S, opts, prefix, outdir)

    if isempty(outdir)
        return;
    end
    if ~exist(outdir, 'dir')
        mkdir(outdir);
    end
    
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
