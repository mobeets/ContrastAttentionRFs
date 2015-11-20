function P = findImagePatchesHighContrast(datadir, nd, contThresh, maxN)

% m = myfft.hann2d(nd);

infs = dir([datadir '/*.mat']);
P = cell(numel(infs),1);
for ii = 1:numel(infs)
    inf = fullfile(datadir, infs(ii).name);
    im = loadIm(inf);
    [ps, cs] = findPatchesHighCont(im, nd, contThresh, maxN);
    P{ii} = ps;
end
P = cat(1, P{:});

end

function im = loadIm(infile)

I = load(infile);
im = double(rgb2gray(I.mov{1}));

end

function [ps, cs] = findPatchesHighCont(im, nd, contThresh, maxN)

ns = 1e3;
xs = randi(size(im,1)-nd, [ns 1]);
ys = randi(size(im,2)-nd, [ns 1]);

cs = zeros(ns,1);
ps = nan(ns,nd,nd);
for ii = 1:ns
    x = xs(ii);
    y = ys(ii);
    p = im(x:x+nd-1, y:y+nd-1);    
    [c, p] = patchCont_RMS(p);
    
    % p is now normalized to 0/1
    ps(ii,:,:) = p;
    cs(ii) = c;
    if sum(cs) > maxN
        break;
    end
end

ix = cs >= contThresh;
cs = cs(ix);
ps = ps(ix,:,:);

end

function [cont, p] = patchCont_RMS(p)

% normalize to 0/1
p = p - min(p(:));
p = p/max(p(:));
cont = std(p(:));

end

