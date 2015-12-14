function S = structArrayAppend(S, fldnm, fldvals)
    
    grp = num2cell(fldvals);
    [S.(fldnm)] = deal(grp{:});
    
end
