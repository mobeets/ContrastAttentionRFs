function g = gaborFilter3(frequency, theta, bandwidth, ...
    sigma_x, sigma_y, n_stds, offset)
% 
% frequency : float
%     Spatial frequency of the harmonic function. Specified in pixels.
% theta : float, optional
%     Orientation in radians. If 0, the harmonic is in the x-direction.
% bandwidth : float, optional
%     The bandwidth captured by the filter. For fixed bandwidth, `sigma_x`
%     and `sigma_y` will decrease with increasing frequency. This value is
%     ignored if `sigma_x` and `sigma_y` are set by the user.
% sigma_x, sigma_y : float, optional
%     Standard deviation in x- and y-directions. These directions apply to
%     the kernel *before* rotation. If `theta = pi/2`, then the kernel is
%     rotated 90 degrees so that `sigma_x` controls the *vertical* direction.
% n_stds : scalar, optional
%     The linear size of the kernel is n_stds (3 by default) standard
%     deviations
% offset : float, optional
%     Phase offset of harmonic function in radians.
% 
% src: (scikit-image) /skimage/filters/_gabor.py
% 

if nargin < 3
    bandwidth = 1;
end
if nargin < 2
    theta = 0;
end
if nargin < 7
    offset = 0;
end
if nargin < 6
    n_stds = 3;
end
if nargin < 5
    sigma_y = sigma_prefactor(bandwidth)/frequency;
end
if nargin < 4
    sigma_x = sigma_prefactor(bandwidth)/frequency;
end

x0 = ceil(max(abs(n_stds * sigma_x * cos(theta)), ...
    abs(n_stds * sigma_y * sin(theta))));
y0 = ceil(max(abs(n_stds * sigma_y * cos(theta)), ...
    abs(n_stds * sigma_x * sin(theta))));
[y, x] = meshgrid(-y0:y0 + 1, -x0:x0 + 1);
rotx = x * cos(theta) + y * sin(theta);
roty = -x * sin(theta) + y * cos(theta);

% g = zeros(size(y));
g = exp(-0.5*(rotx.^2 / sigma_x^2 + roty.^2 / sigma_y^2));
g = g ./ (2*pi*sigma_x*sigma_y);
g = g .* (exp(1j*(2*pi*frequency .* rotx + offset)));

end

function sig = sigma_prefactor(b)
% See http://www.cs.rug.nl/~imaging/simplecell.html
sig = 1/pi*sqrt(log(2)/2)*(2^(b+1))/(2*b-1);
end
