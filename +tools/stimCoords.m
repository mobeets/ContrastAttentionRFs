function stimLoc = stimCoords(stimCenter, nd, pixelsPerElem)
% stimCenter = [Z{1}.centerx Z{1}.centery];
% nd = 32;
% pixelsPerElem = 4; % fine; 8 would be coarse
% npixels = 128; % 128 = 4*32
% 

npixels = nd*pixelsPerElem;
centerx = stimCenter(1);
centery = stimCenter(2);
stimRect = [centerx-npixels/2 centerx+npixels/2; ...
    centery-npixels/2 centery+npixels/2];

% location of each stimulus patch
stimX = linspace(stimRect(1,1), stimRect(1,2), nd);
stimY = linspace(stimRect(2,1), stimRect(2,2), nd);
stimLoc = [stimX; stimY(end:-1:1)];

end
