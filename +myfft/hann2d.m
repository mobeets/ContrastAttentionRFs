function m = hann2d(nd)

w = hann(nd);
m = repmat(w, [1 nd]);
m = m.*m';

end
