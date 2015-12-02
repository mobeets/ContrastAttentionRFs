function X = discretizeStimIfBinary(X)

uns = unique(X(:));
if numel(uns) == 3
    disp('binary-izing');
    nvals = sort(uns);
    assert(nvals(2)==0);
    X(X == nvals(1)) = -1;
    X(X == nvals(2)) = 0;
    X(X == nvals(3)) = 1;
end

end
