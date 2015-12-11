function B = behavHitAndMissOnly(B)

    ix = ([B.outcome] == 1) | ([B.outcome] == 4);
    B = B(ix);
    isCor = num2cell([B.outcome] == 1);
    [B.isCorrect] = deal(isCor{:});
    
end
