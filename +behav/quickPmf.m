function quickPmf(expnm)

    B = behav.loadBehav(expnm);
    B = behav.behavHitAndMissOnly(B);
    B = behav.addBinnedField(B, 'TIMEBEFORETARGET', 'targonset', 10);
    
    figure;
    subplot(2,2,1);
    title(expnm);
    behav.plotPctCor1d(B, 'TARGETTIMEON', 'target duration (msec)');
    subplot(2,2,2);
    behav.plotPctCor1d(B, 'targonset', 'target onset (msec)');
    subplot(2,2,3);
    behav.plotPctCor2d(B, 'targx', 'targy');
    subplot(2,2,4);
    behav.plotPctCor2d(B, 'targonset', 'TARGETTIMEON', ...
        'target onset (msec)', 'target duration (msec)');
    set(gcf, 'color', 'w');

end
