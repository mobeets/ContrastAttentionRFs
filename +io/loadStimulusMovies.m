function M = loadStimulusMovies(indir, prefix, suffix, skipPixels, fieldNm)
% skipPixels = skip every few pixels if duplicates
if nargin < 5
    fieldNm = 'mov';
end
if nargin < 4
    skipPixels = 1;
end
if nargin < 3
    suffix = nan; % load all
end

indir0 = fullfile(indir, [prefix '*']);
ws = dir(indir0);
if ~isnan(suffix)
    ix = strcmp({ws.name}, [prefix num2str(suffix) '.mat']);
    m = load(fullfile(indir, ws(ix).name));
    M = m.(fieldNm);
    return;
end

M = cell(numel(ws),1);
for ii = 1:numel(ws)
    m = load(fullfile(indir, ws(ii).name));
    p = m;
    if skipPixels > 1
        mm = m.(fieldNm);
        for jj = 1:numel(mm)
            m.(fieldNm){jj} = mm{jj}(1:skipPixels:end, 1:skipPixels:end);
        end
    end
    M{ii} = m.(fieldNm);
end

end
