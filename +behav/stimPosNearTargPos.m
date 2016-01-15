function pos = stimPosNearTargPos(B, M, targColor)
    
    if nargin < 3
        targColor = 0;
    end

    pos = nan(numel(B),2);
    for ii = 1:numel(B)
        b = B(ii);
        x = M{b.suffix};
        x = cat(3, x{:});
        
        % index of stimulus just prior to target onset
        ind = floor(b.TIMEBEFORETARGET / 100)+1;
        if ind > size(x,3)
            continue;
        end
        x = x(:,:,ind);
        
        % stim location (for sparse stimuli => only one stim per pulse)
        [pos(ii,1), pos(ii,2)] = find(x == targColor);
    end

end
