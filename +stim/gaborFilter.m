function f = gabor_filter(OR, SF, sigma_x, sigma_y, imagesize)

nPix = floor((imagesize-1)/2);
[x,y] = meshgrid(-nPix:nPix + (1-mod(imagesize,2)));
X = x*cos(OR)+y*sin(OR);
Y = -sin(OR)+y*cos(OR);
f = (1/(2*pi*sigma_x*sigma_y)).* ...
    exp(-(1/2)*(((X/sigma_x).^2)+((Y/sigma_y).^2))).*sin(2*pi*SF*X);

end
