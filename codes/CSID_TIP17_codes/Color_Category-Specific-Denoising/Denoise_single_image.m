clear;
close all;

colorspace = 'opp';

%%
addpath(genpath('CBM3D'));
addpath(genpath('Blk_matching'));
addpath(genpath('Utils'));

%%
save_path='Results';
if ~exist(save_path, 'dir')
    mkdir(save_path)
end
path = 'views/test/'; % path to test image
test_im = 'a.png'; % test image
path_train = 'views/train/'; % path to training images.
ext_train = '*.png';

sigma = 30;

%% Read test image

fprintf(' Sigma =%d \n', sigma);
gt   = im2double(imread(fullfile(path, test_im)));

if size(gt,3)~=3
    fprintf("Color denoising: Only accepts RGB images\n");
    return;
end
%%
randn('seed', 0 );
noisy  =  ( gt + randn(size(gt))*sigma/255); %Generate noisy image
[noisy, l2normLumChrom] = function_rgb2LumChrom(noisy,  colorspace);


%%
y_est = noisy;

%% Step 1
y_est(:,:, 1)  = CSID( noisy(:,:, 1),  y_est(:,:, 1),  sigma, path_train, ext_train);
y_cbm3d = CBM3D( noisy, sigma,'np', l2normLumChrom);

%% Step 2
if sigma > 30
    y_est(:,:, 1)  = CSID( noisy(:,:,1),  y_est(:,:, 1),  sigma, path_train, ext_train);
end
y_est(:, :, 2) = y_cbm3d(:, :, 2);
y_est(:, :, 3) = y_cbm3d(:, :, 3);

y_final = function_LumChrom2rgb(y_est,  colorspace);

%% Compute PSNR and save results.
PSNR_y_est= 10*log10(1/mean((y_final(:)-double(gt(:))).^2));
fprintf(' Ours PSNR : %2.2f',   PSNR_y_est);
cbm3d_denoise = function_LumChrom2rgb(y_cbm3d);
fprintf(' & BM3D: %2.2f\n',   10*log10(1/mean((cbm3d_denoise(:)-double(gt(:))).^2)));

imwrite(y_est, fullfile(save_path, ['CSID_' test_im(1:end-4) '_s' num2str(sigma) '.png']));

save(fullfile(save_path, 'Color_PSNR_im.mat'), 'PSNR_y_est');


