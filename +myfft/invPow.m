function [img, noise] = invPow(nd, wDeg, noise)
% 
% nd   - resolution of image (pixels)
% wDeg - size of image (in degrees)
% 
if nargin < 3
    noise = randn(nd);
end

[x,y] = meshgrid(linspace(-wDeg/2,wDeg/2,nd+1));
x = x(1:end-1,1:end-1);
y = y(1:end-1,1:end-1);

F = myfft.myfft2(noise,x,y,1);
A = 1./(F.sf.^2);
% A = exp(-F.sf.^2/2^2);

F.amp = F.amp.*A;
img = myfft.myifft2(F);

end



