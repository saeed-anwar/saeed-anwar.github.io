function [im_train_sim, similar_im] = search_similar_images(im, pathDir, similar_im, ext)
   
%     ext = '*.jpg';
    Dir = dir([pathDir ext]);
        
    for i_num=1:length(Dir)
        im_train_temp = (imread([pathDir Dir(i_num).name]));
        if size(im_train_temp,3)> 2
%             im_train_temp = im2double(rgb2gray(im_train_temp(:, :, 1:3)));
            im_train_temp = im2double(rgb2ycbcr(im_train_temp(:, :, 1:3)));
            im_train_temp = im_train_temp(:,:,1);
        else
           im_train_temp = im2double(im_train_temp);
        end
        
        im_train(:, :, i_num) = imresize(im_train_temp, [size(im,1), size(im,2)]);
%         ssim_val(i_num)     = cal_ssim(im, im_train(:,:, i_num), 0, 0);
        ssim_val(i_num)     =  ssim(im, im_train(:,:, i_num));
    end
    [~, S_idx]= sort(ssim_val, 'descend');
    
    similar_im = min(similar_im, length(Dir));
    im_train_sim = im_train(:, :, S_idx(1:similar_im));
end
    