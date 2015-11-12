close all;

% im = A(:,1);
im = X(1,:);

% im = load('~/code/MLProject/data/v4fv/scenes/v4fv_orig_71.mat');
% im = im.mov{1}(:,:,1);
% minsz = min(size(im));
% im = im(1:minsz, 1:minsz);

nd = sqrt(numel(im));
im = reshape(im,nd,nd);
% im = zeros(16,16);
% im(8:9,8:9) = 1;
% im(8,8) = 1;
% im(9,9) = 1;

figure; colormap gray;
imagesc(im);
imf = fftshift(fft2(im));

% The function fftshift is needed to put the DC component 
% (frequency = 0) in the center.  The power spectrum is just
% the square of the modulus of the Fourier transform,  
% which is obtained as follows:
impf = abs(imf).^2;

N = size(im,1);
assert(mod(N,2)==0);
f = -N/2:N/2-1; % frequencies

% display the log power spectrum
% You will note that the power falls off with frequency as 
% you move away from the center.  Ignore the vertical and 
% horizontal streak for now - its an artifact due to the 
% boundaries of the image. 
figure;
colormap gray;
imagesc(f,f,log10(impf));
axis xy;

% rotational average
f1 = 0:N/2;
Pf = mean(impf);
Pf = Pf(end-numel(f1)+1:end);
% Pf = rotavg(impf);
figure;
loglog(f1,Pf); % should be slope -2 if 1/f^2
