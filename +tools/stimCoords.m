function stimLoc = stimCoords(stimCenter, nd, npixels)
% stimCenter = [Z{1}.centerx Z{1}.centery];
% nd = 32;
% npixels = 128;
% 

centerx = stimCenter(1);
centery = stimCenter(2);
stimRect = [centerx-npixels/2 centerx+npixels/2; ...
    centery-npixels/2 centery+npixels/2];

% location of each stimulus patch
stimX = linspace(stimRect(1,1), stimRect(1,2), nd);
stimY = linspace(stimRect(2,1), stimRect(2,2), nd);
stimLoc = [stimX; stimY(end:-1:1)];

end
