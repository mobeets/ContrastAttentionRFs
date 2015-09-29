function showTrial(X, pauseTime)
if nargin < 2
    pauseTime = 0.1;
end

colormap(gray);
for ii = 1:numel(X)
    imagesc(X{ii});
    caxis([0 256]);
    axis off;
    pause(pauseTime);
end

end
