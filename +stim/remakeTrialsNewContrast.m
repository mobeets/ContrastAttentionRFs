function Y = remakeTrialsNewContrast(X, opts, outdir, prefix)

if nargin < 3
    outdir = '';
end
if nargin < 4
    prefix = 'tmp_';
end

Y = X;
for ii = 1:numel(Y)
    for jj = 1:numel(Y{ii})
        y = Y{ii}{jj};
        % update values here!
        y = round((y - median(unique(y(:))))/(max(y(:)) - median(y(:))));
        if isfield(opts, 'stimContrast') && ...
                isfield(opts, 'stimOffset') % [0, 1]
            y = opts.stimOffset*opts.stimContrast*y;
        end
        if isfield(opts, 'stimOffset') % mean gray = 128
            y = y + opts.stimOffset;
        end
        y = round(y);
        Y{ii}{jj} = y;
    end
end

if isempty(outdir)
    return;
end

% save all to .mat
for ii = 1:opts.ntrials
    outfile = fullfile(outdir, [prefix num2str(ii)]);
    mov = Y{ii};
    save(outfile, 'mov', 'opts');
end

end
