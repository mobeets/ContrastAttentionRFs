function nr = inferPixelRepeats(suff, fnm)

% nrmap = {'lCont_cGrid', 'hCont_cGrid', ...
%     'lCont_fGrid', 'hCont_fGrid', 'gauss_cGrid', 'ica_fGrid1', ...
%     'sps_fGrid', 'sps_cGrid'};
% nrval = [8 8 4 4 4 4 4 8];

if ~isempty(strfind(suff, 'gauss'))
    nr = 4; % always 4, though labeled as 'cGrid'
elseif ~isempty(strfind(suff, 'cGrid'))
    nr = 8;
elseif ~isempty(strfind(suff, 'fGrid'))
    nr = 4;
else
    error(['Could not interpret suffix "' suff '".']);
end
if ~isempty(strfind(fnm, '20151007'))
    nr = 16; % extra coarse!
end

end
