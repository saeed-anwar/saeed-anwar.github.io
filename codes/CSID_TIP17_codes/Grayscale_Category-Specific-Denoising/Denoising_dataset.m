clear;
% clc;
close all;
addpath(genpath('Utils'));

%%
save_path = 'Grayscale_results_dataset';
if ~exist(save_path, 'dir')
    mkdir(save_path);
end
%%  Paths to test and train images.
path = 'face\test\';
ext = '*.png';

path_train = 'face\train\';
ext_train = '*.png';

test_im = dir([path ext]);

%%
sigma_list = [30, 50, 70, 80, 100];
PSNR_y_est = zeros(length(sigma_list), length(test_im));

%%
for i = 1: length(sigma_list)
    for j= 1:length(test_im)
        
        fprintf('Sigma =%d, Image No : %d\n', i, j);
        
        %% read the images.
        gt = imread([path test_im(j).name]); 

        if size(gt,3)>1
            image = rgb2ycbcr( gt );
            y = im2double(image(:, :, 1));
            fprintf('Grayscale denoising: Image converted to grayscale.\n');
        else
            y = im2double(gt);
        end
        
        %% introduce the noise in the test image.
        sigma  = sigma_list(i);
        randn('seed', 0 );
        noisy  =   y + randn(size(y))*sigma/255; %Generate noisy image

        %% Perform denoising
        level = 2;
        [y_final, low_est]  = CSID( noisy, noisy,  sigma, level, path_train, ext_train);
        
        %% Save results.
        PSNR_y_est(i, j)= 10*log10(1/mean((y_final(:)-double(y(:))).^2));
        fprintf('PSNR: %2.2f\n\n',   PSNR_y_est(i, j));
        imwrite(y_final, fullfile(save_path, ['denoise_' test_im(j).name(1:end-4) '_s' num2str(sigma) '.png']));
        
    end
end
save(fullfile(save_path, 'grayscale_PSNR.mat'), 'PSNR_y_est');


