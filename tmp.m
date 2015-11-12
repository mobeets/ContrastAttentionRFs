function tmp()
A = load('data/ICA.mat'); A = A.G;
nd = sqrt(size(A,1));
A2 = nan((2*nd)^2, size(A,2));
for ii = 1:size(A,1)
    a0 = reshape(A(:,ii), nd, nd);
    a = imresize(a0, [2*nd+2 2*nd+2]);
    a1 = a(2:end-1,2:end-1);
    A2(:,ii) = a1(:)';
end
end
