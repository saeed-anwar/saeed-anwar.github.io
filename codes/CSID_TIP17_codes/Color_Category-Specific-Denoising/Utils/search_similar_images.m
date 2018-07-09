function im_train_sim = search_similar_images(im, pathDir, similar_im, ext)
    
    Dir = dir([pathDir ext]);
    im_train = zeros(size(im, 1), size(im, 2) , length(Dir));
    ssim_val = zeros(1, length(Dir));
    
    %%
    for i_num = 1:length(Dir)
        
        im_t = rgb2gray(im2double(imread([pathDir Dir(i_num).name])));
        im_train_temp = im_t;%(:,:,1);
        
        im_train(:, :, i_num) = imresize(im_train_temp, [size(im,1), size(im,2)]);
        ssim_val(i_num)     =  ssim(im, im_train(:,:, i_num)); % this is matlab function
        
    end
    
    %%
    [~, S_idx]= sort(ssim_val, 'descend');
    
    similar_im = min(similar_im, length(Dir));
    im_train_sim = im_train(:, :, S_idx(1:similar_im));
    
end
