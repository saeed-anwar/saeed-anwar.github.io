clear;
close all;

colorspace = 'opp';
%%
addpath(genpath('CBM3D'));
addpath(genpath('Blk_matching'));
addpath(genpath('Utils'));

%%
save_path='Results_dataset';
if ~exist(save_path, 'dir')
    mkdir(save_path)
end
%%
path = 'views/test/';
ext = '*.png';

path_train = 'views/train/';
ext_train = '*.png';

test_im = dir([path ext]);

sigma_list = [100, 80, 70, 50, 30, 20];
PSNR_y_est = zeros(length(sigma_list), length(test_im));

%%
for i = 1: length(sigma_list)
    for j= 1:length(test_im)
        
        fprintf('Sigma =%d, Image No : %d', sigma_list(i), j);
        gt   = im2double(imread([path test_im(j).name]));

        if size(gt,3)~=3
            fprintf("Color denoising: Only accepts RGB images\n");
            return;
        end
        %%
        sigma  = sigma_list(i);
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
        
        imwrite(y_est, fullfile(save_path, ['CSID_' test_im(j).name(1:end-4) '_s' num2str(sigma) '.png']));
        
    end
    
end
save(fullfile(save_path, 'Color_PSNR_dataset.mat'), 'PSNR_y_est');


