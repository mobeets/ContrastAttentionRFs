function A = loadGaborFilterBank(datadir)

datafile = fullfile(datadir, 'gaborBank.mat');
if exist(datafile, 'file') == 2
    G = load(datafile);
else
    G = stim.gaborFilterBank(4,10,16,16);
end

G = G.G;
A = cat(3, G{:});
A = permute(A, [3 1 2]);
A = A(1:end, :)';
A1 = real(A);
A2 = real(imag(A));
A = [A1 A2];
nmA = sqrt(sum(abs(A).^2));
A = A./(repmat(nmA, size(A,1), 1));

end
