function X = makeTrial(opts)

npulses = opts.npulses;
ncols = opts.shape(1);
nrows = opts.shape(2);

% randomly select one of three values per grid location: 
%   black, gray, white
ix = rand(npulses*ncols*nrows,1);
X = nan(size(ix));
X(ix <= 1/3) = -1;
X(1/3 < ix & ix <= 2/3) = 0;
X(ix > 2/3) = 1;

if isfield(opts, 'stimContrast') && isfield(opts, 'stimOffset') % [0, 1]
    X = opts.stimOffset*opts.stimContrast*X;
end
if isfield(opts, 'stimOffset') % mean gray = 128
    X = X + opts.stimOffset;
end
X = round(X);

% X{i} should be stimulus on ith frame
X = reshape(X, [npulses ncols nrows]);
X = num2cell(X, [2 3]);
X = cellfun(@squeeze, X, 'uni', 0);
if isfield(opts, 'pixelsPerElem') && opts.pixelsPerElem > 1
    for ii = 1:numel(X)
        X{ii} = repelem(X{ii}, opts.pixelsPerElem, opts.pixelsPerElem);
    end
end

end
