function [newX, newStimLoc] = shrinkStim(X, rfBounds, stimLoc)
% 
% X [ntrials x nd]
% rfBounds [2 x 2]
% stimLoc [1 x 2]
% 

stimX = stimLoc(1,:);
stimY = stimLoc(2,:);

% find stim indices to get closest to rfBounds
[~,ixya] = min((round(stimY) - rfBounds(2,1)).^2);
[~,ixyb] = min((round(stimY) - rfBounds(2,2)).^2);
[~,ixxa] = min((round(stimX) - rfBounds(1,1)).^2);
[~,ixxb] = min((round(stimX) - rfBounds(1,2)).^2);
if ixya > ixyb
    ixyc = ixya; ixya = ixyb; ixyb = ixyc;
end
if ixxa > ixxb
    ixxc = ixxa; ixxa = ixxb; ixxb = ixxc;
end

% make new stim a square
nd = numel(stimX);
offset = max(ixxb - ixxa, ixyb - ixya);
ixxb = ixxa + offset;
ixyb = ixya + offset;
if ixxb > nd    
    ixxa = ixxa - (ixxb - nd);
    ixxb = nd;
end
if ixyb > nd    
    ixya = ixya - (ixyb - nd);
    ixyb = nd;
end

% new stimulus bounds
vxa = stimX(ixxa);
vya = stimY(ixya);
vxb = stimX(ixxb);
vyb = stimY(ixyb);

% location of (new, truncated) stimulus patch
newStimX = linspace(vxa, vxb, ixxb-ixxa+1);
newStimY = linspace(vya, vyb, ixyb-ixya+1);
newStimLoc = [newStimX; newStimY];

% truncate each trial's stimulus using new bounds
nd0 = sqrt(size(X,2));
nd = (ixxb-ixxa+1);
ntrials = size(X,1);
newX = nan(ntrials, nd^2);
for ii = 1:ntrials
    x = reshape(X(ii,:), nd0, nd0);
    xx = x(ixya:ixyb, ixxa:ixxb);
    newX(ii,:) = xx(:);
end

end
