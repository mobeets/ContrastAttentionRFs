
cind = 51;
pos1 = abs(X(:,cind))==1;

rsl = nan(size(X,2),1);
for ii = 1:size(X,2)
    if ii == cind
        continue;
    end
    pos2 = abs(X(:,ii))==1;
    pos = [ones(sum(pos1),1); zeros(sum(pos2),1)];
    sps = [Y(pos1,:); Y(pos2,:)];

%     spinds = find(scs > prctile(scs,90));
    spinds = 59;
    cls = fitcdiscr(sps(:,spinds), pos);%,'DiscrimType','quadratic');
    rsl(ii) = resubLoss(cls);

end

%%

figure;
imagesc(reshape(rsl,8,8));

%%

figure; colormap gray;
w = objs{1}{59}.w;
nd = sqrt(numel(w));
imagesc(reshape(w, nd, nd));
