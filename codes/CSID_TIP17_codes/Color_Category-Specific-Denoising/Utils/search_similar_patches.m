function ssim_value = search_similar_patches(npatch, patchGroup)
    ssim_val = zeros(1, size(patchGroup, 3));
    for i_num = 1 : size(patchGroup, 3)
        ssim_val(i_num)  =  ssim(npatch, patchGroup(:,:, i_num)); % this ssim is a matlab function
    end
    ssim_value = mean(ssim_val);
end