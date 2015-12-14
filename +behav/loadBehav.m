function B = loadBehav(expnm, expdir)    
    if nargin < 2
        expdir = fullfile('data', 'behav');
    end
    if nargin < 1
        expnms = dir(fullfile(expdir, '*.mat'));
        expnm = expnms(1).name;
        expnm = strrep(expnm, '.mat', '');
    end

    exp = load(fullfile(expdir, [expnm '.mat']));
    B = tools.struct2structArray(exp.behav);
    
    % outcomes:
    % 0: failed to achieve fixation
    % 1: correct
    % 2: broke fix
    % 3: early
    % 4: miss
    % 10: successful catch trial

    % currently ignored fields:
    % * result
    % * targRad
    % * targcolor1
    % * targcolor2
    % * targcolor3
    % * prefix

    % fields to check:
    % * suffix

    % descriptions:
    % * targon = B.TIMEBEFORETARGET;
    % * targdur = B.TARGETTIMEON;
    % * targpos = [B.targx B.targy];

end
