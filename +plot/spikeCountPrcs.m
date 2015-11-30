function [Yprc, mods] = spikeCountPrcs(Y, prcs)
if nargin < 2
    prcs = [20 50 80];
end
Yprc = prctile(Y, prcs, 1)';

figure; hold on;
subplot(1,2,1);
plot(sortrows(Yprc, 2));
subplot(1,2,2);
hist(Yprc(:,3)-Yprc(:,1));

mods = [(1:size(Y,2))' Yprc(:,end)-Yprc(:,1)];

end
