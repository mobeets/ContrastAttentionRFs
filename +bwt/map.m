function y = map(X)
% http://www.mitpressjournals.org/doi/pdf/10.1162/neco.2007.05-07-513

if size(X,1) ~= size(X,2)
    error('Stimulus must be square');
end
nd = size(X,1);
ns = log(nd)/log(3);
if round(ns) ~= ns
    error('Size of stimulus must be a power of 3');
end

angs = 0:3;
sgns = 0:1;
scales = 1:ns-1;
% b = daughter(ang, sgn, scale);

end
