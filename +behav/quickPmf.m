function B = quickPmf(expnm, xnm, ynm)
    if nargin < 2
        xnm = 'TARGETTIMEON';
    end
    if nargin < 3
        ynm = 'targonset';
    end
    xlbl = getLabel(xnm);
    ylbl = getLabel(ynm);

    B = behav.loadBehav(expnm);
    B = behav.behavHitAndMissOnly(B);
    
    % bin the target onset
    B = behav.addBinnedField(B, 'TIMEBEFORETARGET', 'targonset', 10);
    
    % add target's onset time relative to nearest stimulus pulse onset
    B = tools.structArrayAppend(B, 'targphase_raw', ...
        mod([B.TIMEBEFORETARGET], 100));
    B = behav.addBinnedField(B, 'targphase_raw', 'targphase', 10);
    
    figure;
    subplot(2,2,1);
    title(expnm);
    behav.plotPctCor1d(B, xnm, xlbl);
    subplot(2,2,2);
    behav.plotPctCor1d(B, ynm, ylbl);
    subplot(2,2,3);
    behav.plotPctCor2d(B, 'targx', 'targy');
    subplot(2,2,4);
    behav.plotPctCor2d(B, ynm, xnm, ...
        ylbl, xlbl);
    set(gcf, 'color', 'w');

end

function lbl = getLabel(nm)
    switch nm
        case 'TARGETTIMEON'
            lbl = 'target duration (msec)';
        case 'targonset'
            lbl = 'target onset (msec)';
        otherwise
            lbl = nm;
    end
end
