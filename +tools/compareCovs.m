function [s, s2, s3, s4] = compareCovs(D1, D2)
% src: "A simple procedure for the comparison of covariance matrices"
% http://bmcevolbiol.biomedcentral.com/articles/10.1186/1471-2148-12-222
% 
% s = s2 + s3 = 0 if cov(D1) and cov(D2) have the same orientation/shape
% s2 = 0 iff cov(D1) and cov(D2) have same orientation
% s3 = 0 iff cov(D1) and cov(D2) have same shape
% 

    [u1,v11,~] = svd(corr(D1), 'econ');
    [u2,v22,~] = svd(corr(D2), 'econ');
    v11 = diag(v11)'; % var(D1*u1);
    v22 = diag(v22)'; % var(D2*u2);
    v21 = var(D2*u1);
    v12 = var(D1*u2);
    s = 2*sum((v11 - v21).^2 + (v12 - v22).^2); % s = s2 + s3
    s2 = sum(((v11 + v22) - (v12 + v21)).^2); % orientation
    s3 = sum(((v11 + v12) - (v21 + v22)).^2); % shape
    s4 = sum((v11 - v12).^2 + (v22 - v21).^2);
end
