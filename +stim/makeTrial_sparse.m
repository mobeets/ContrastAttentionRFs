function X = makeTrial_sparse(opts)

ntrials = opts.ntrials;
npulses = opts.npulses;

% if ~isfield(opts, 'pixelsPerElem') || opts.pixelsPerElem ~= 2
%     error('Sparse stimuli must have pixelsPerElem == 2');
% end
% ndups = opts.pixelsPerElem;
ncols = opts.shape(1);
nrows = opts.shape(2);

if isfield(opts, 'stimOffset')
    stimOffset = opts.stimOffset;
else
    stimOffset = 0;
end
if isfield(opts, 'stimContrast')
    stimContrast = opts.stimContrast;
else
    stimContrast = 1;
end

% subtract one to keep indices off edges
S0 = randi((ncols-1)*(nrows-1), [ntrials npulses]);
% S = randi(ncols*nrows, [ntrials npulses]);
T = randi(2, [ntrials npulses]);

% [ixx, ixy] = ind2sub([ncols nrows], S);
[ixx, ixy] = ind2sub([ncols-1 nrows-1], S0);

nextras = round(ntrials*0.2);
Sextra = randi(ncols*nrows, [nextras 1]);
[ixx2, ixy2] = ind2sub([ncols nrows], Sextra);
d = 1;

X = cell(ntrials,1);
S = cell(ntrials,1);
for ii = 1:ntrials
    X{ii} = cell(npulses,1);
    for jj = 1:npulses
        
%         x = zeros(ncols*ndups, nrows*ndups);
%         ix0 = (ixx(ii,jj)-1)*ndups + 1;
%         iy0 = (ixy(ii,jj)-1)*ndups + 1;
%         x(ix0:ix0+1,iy0) = 1;
%         x(ix0:ix0+1,iy0+1) = -1;
        
        ix0 = ixx(ii,jj);
        iy0 = ixy(ii,jj);
        % ignore inds on edge (this is awful, sorry)
        while ix0 == ncols || iy0 == nrows
            assert(false);
            ix0 = ixx2(d);
            iy0 = ixy2(d);
            ixx(ii,jj) = ix0;
            ixy(ii,jj) = iy0;
            d = d+1;
        end
        
        x = zeros(ncols, nrows);
        switch T(ii,jj)
            case 4
                x(ix0,iy0) = 1;
                x(ix0+1,iy0) = -1;
            case 3
                x(ix0,iy0) = 1;
                x(ix0,iy0+1) = -1;
            case 2
                x(ix0,iy0) = -1;
                x(ix0+1,iy0) = 1;
            case 1
                x(ix0,iy0) = -1;
                x(ix0,iy0+1) = 1;
        end
        
        if isfield(opts, 'pixelsPerElem') && opts.pixelsPerElem > 1
            x = repelem(x, opts.pixelsPerElem, opts.pixelsPerElem);
        end
        if stimOffset > 0
            x = x*stimOffset*stimContrast;
        end
        x = round(x + stimOffset);
        X{ii}{jj} = x;
    end
end

end
