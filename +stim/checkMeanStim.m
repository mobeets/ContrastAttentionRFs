function checkMeanStim(Xtmp)

dim = size(Xtmp{1}{1});
s = zeros(dim);
c = 0;
for ii = 1:numel(Xtmp)
    for jj = 1:numel(Xtmp{ii})
        s = s + Xtmp{ii}{jj};
        c = c + 1;
    end
end
figure; colormap gray;
imagesc(s/c);
colorbar;

end
