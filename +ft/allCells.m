function [objs, scs] = allCells(X, Y, fitNm, D, cellinds)
if nargin < 5
    cellinds = 1:size(Y,2);
end
if nargin < 4
    D = nan;
end
if nargin < 3
    fitNm = 'ML';
end
if isnan(D) && strcmpi(fitNm, 'asd')
    nd = sqrt(size(X,2));
    Xxy = tools.cartesianProduct({1:nd; 1:nd});
    D = asd.sqdist.space(Xxy);
end
c = 0; maxmsgs = 5;

objs = cell(size(Y,2),1);
for ii = cellinds
    objs{ii} = ft.oneCell(X, Y(:,ii), D, fitNm);
    if objs{ii}.score > 0.0
        if c < maxmsgs
            disp(['Cell ' num2str(ii) ' has a score of ' ...
                num2str(objs{ii}.score) '!']);
        elseif c == maxmsgs
            disp('Okay, I''m gonna shut up now. Lots of fits look good.');
        end
        c = c + 1;
    end
end
scs = nan(numel(objs),1);
scs(cellinds) = cellfun(@(d) d.score, objs(cellinds));

end
