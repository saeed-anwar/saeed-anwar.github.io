clear;
% clc;
close all;
addpath(genpath('Utils'));

%%
save_path = 'Grayscale_results';
if ~exist(save_path, 'dir')
    mkdir(save_path);
end
%%  Paths to test and train images.
% as an example we are providing face (Gore) dataset here.

path = 'face\test\'; % Path to test images.
test_im = '4.png'; % test image.

path_train = 'face\train\'; % Path to train images.
ext_train = '*.png'; % train images extension.


%% sigma value
sigma = 30;
fprintf('Sigma =%d\n', sigma);

%% read the images.
gt = imread(fullfile(path, test_im));

if size(gt,3)>1
    image = rgb2ycbcr( gt );
    y = im2double(image(:, :, 1));
    fprintf('Grayscale denoising: Image converted to grayscale.\n');
else
    y = im2double(gt);
end

%% introduce the noise in the test image.
randn('seed', 0 );
noisy  =   y + randn(size(y))*sigma/255; %Generate noisy image

%% Perform denoising
level = 2;
[y_final, low_est]  = CSID( noisy, noisy,  sigma, level, path_train, ext_train);

%% Save results.
PSNR_y_est= 10*log10(1/mean((y_final(:)-double(y(:))).^2));
fprintf('PSNR: %2.2f\n\n',   PSNR_y_est);
imwrite(y_final, fullfile(save_path, ['denoise_' test_im(1:end-4) '_s' num2str(sigma) '.png']));

save(fullfile(save_path, 'grayscale_PSNR.mat'), 'PSNR_y_est');


