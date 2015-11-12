function Y = myfft2(img,x,y,k)

if ~exist('k','var')
    k=1;
end
if ~exist('x','var') || ~exist('y','var')
    [x,y] = meshgrid(1:size(img,1));
end

F = fft2(img, size(y,1)*k, size(y,2)*k);
Y = myfft.complex2real2(F,x,y);

end
