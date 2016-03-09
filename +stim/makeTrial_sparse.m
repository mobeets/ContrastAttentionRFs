function X = makeTrial_sparse(opts)

    ntrials = opts.ntrials;
    npulses = opts.npulses;
    barType = 1;

    [ix, iy] = getPulseLocations(opts);

    X = cell(ntrials,1);
    for ii = 1:ntrials
        X{ii} = cell(npulses,1);
        for jj = 1:npulses
            X{ii}{jj} = makePulse_sparse(ix(ii,jj), iy(ii,jj), ...
                barType, opts);
        end
    end

end

function [ix, iy] = getPulseLocations(opts)
    % show random permutations of all available locations
    % subtract one to keep indices off edges
    % S0 = randi((ncols-1)*(nrows-1), [ntrials npulses]);
    
    ncols = opts.shape(1);
    nrows = opts.shape(2);
    ntrials = opts.ntrials;
    npulses = opts.npulses;
    
    np = (ncols-1)*(nrows-1);
    ndraws = ceil(ntrials*npulses/np);
    [~, S0] = sort(rand(ndraws, np),2);
    S0 = S0'; % need transpose so that first np trials include all locs
    S0 = reshape(S0(1:ntrials*npulses), [ntrials npulses]);
    [ix, iy] = ind2sub([ncols-1 nrows-1], S0);
end

function x = makePulse_sparse(ix, iy, barType, opts)

    x = zeros(opts.shape(1), opts.shape(2));
    switch barType
        case 1
            x(ix,iy) = 1;
            x(ix+1,iy) = -1;
        case 2
            x(ix,iy) = -1;
            x(ix+1,iy) = 1;
        case 3
            x(ix,iy) = 1;
            x(ix,iy+1) = -1;            
        case 4
            x(ix,iy) = -1;
            x(ix,iy+1) = 1;
    end

    if isfield(opts, 'pixelsPerElem') && opts.pixelsPerElem > 1
        x = repelem(x, opts.pixelsPerElem, opts.pixelsPerElem);
    end
    if opts.stimOffset > 0
        x = x*opts.stimOffset*opts.stimContrast;
    end
    x = round(x + opts.stimOffset);

end

