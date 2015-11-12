function img = myifft2(Y)

F = myfft.real2complex2(Y);
img = ifft2(F, 'symmetric');
img = img(1:Y.nPix, 1:Y.nPix);

end
