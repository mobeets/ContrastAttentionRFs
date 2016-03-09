function [M, opts] = loadStimulusMovies(indir, prefix, suffix, skipPixels, fieldNm)    
    if nargin < 3
        suffix = nan; % load all
    end
    if nargin < 4
        skipPixels = 1; % skip every few pixels if duplicates
    end
    if nargin < 5
        fieldNm = 'mov';
    end

    indir0 = fullfile(indir, [prefix '*']);
    ws = dir(indir0);
    if ~isnan(suffix)
        ix = strcmp({ws.name}, [prefix num2str(suffix) '.mat']);
        m = load(fullfile(indir, ws(ix).name));
        M = m.(fieldNm);
        opts = m.opts;
        return;
    end

    M = cell(numel(ws),1);
    for ii = 1:numel(ws)
        m = load(fullfile(indir, ws(ii).name));
        if ~exist('opts', 'var')
            opts = m.opts;
        end
        vs = strsplit(ws(ii).name, '.');
        vs = strsplit(vs{1}, '_');
        ind = str2num(vs{end});
        if skipPixels > 1
            mm = m.(fieldNm);
            for jj = 1:numel(mm)
                m.(fieldNm){jj} = mm{jj}(1:skipPixels:end, 1:skipPixels:end);
            end
        end
        assert(isempty(M{ind}));
        M{ind} = m.(fieldNm);
    end

end
