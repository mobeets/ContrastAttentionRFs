function ts = drawTruncExpStimLength(t0, t1, tMean, N)
% inverse transform sampling for truncated exponential
%   n.b. mean(ts) < tMean because you're chopping off the tails
    itexp = @(u, beta, tmax) -log(1-u*(1-exp(-tmax*beta)))/beta;
    rtexp = @(n, beta, tmax) itexp(rand(n,1), beta, tmax);
    ts = rtexp(N, 1/(tMean - t0), t1 - t0) + t0;
end
