function [im_patchs2, im_patchs3, similar_im]=search(im, pathDir, similar_im)


    ext = '*.jpg';
    Dir = dir([pathDir ext]);
    
    similar_im = min(similar_im, length(Dir));
    fprintf('Number of Similar images: %d\n', similar_im);

    for i_num=1:length(Dir)
        im_train_temp = (imread([pathDir Dir(i_num).name]));
        if size(im_train_temp,3) == 3
            im_train(:, :, i_num) = im2double(rgb2gray(im_train_temp));
        else
           im_train(:, :, i_num) = im2double(im_train_temp);
        end

        ssim_val(i_num)     = cal_ssim(im, im_train(:,:, i_num), 0, 0);
    end
    [~, S_idx]= sort(ssim_val, 'descend');

    im_train_sim = im_train(:, :, S_idx(1:similar_im));
    
%%
    im_patchs1 = retrieve_image(im_train_sim); 
    im_patchs2 = retrieve_image(im_patchs1);
    im_patchs3 = retrieve_image(im_patchs2);

end

function im_patchs = retrieve_image(im) 
    ParS = determineStep(im);
    j=1;

    for idx = 1:size(im, 4)
        for row = 1 : ParS.Nsteph : ParS.win1
            for col = 1 : ParS.Nstepw : ParS.win2
           
                im_patchs(:, :, :, j) = im(row:row + ParS.win1-1, col:col + ParS.win2-1, :, idx);
                j=j+1;

            end
        end
    end

end


% function ParS = determineStep(x)
%     
%     h = size(x,1);
%     r = size(x,2); 
%     ParS.win1 = ceil(h/2);
%     ParS.win2 = ceil(r/2);
%     ParS.Nsteph = floor(ParS.win1/2)- mod(h,2);
%     ParS.Nstepw = round(ParS.win2/2)- mod(r,2);
% 
% end
