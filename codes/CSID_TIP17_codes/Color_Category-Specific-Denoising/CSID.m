function y_est  = CSID( noisy, y_est, sigma, path, ext)

% Main denoising code.

tau_match  =  0;
Ns        =  51;
cands_per_im = 40;
cands_patchs = 8;
top_similar = 16;
im_similar = 16;

im_train_sim  = search_similar_images(noisy, path, im_similar, ext);
top_similar = min(top_similar, size(im_train_sim,3));
par = ParSet(sigma);
N1 = par.win1;
N2 = par.win2;

Nstep = 1;
nSig = sigma;

[height, width] = size(y_est);
rem_h = mod(height,Nstep);
rem_w = mod(width,Nstep);

if rem_h == 0
    ext_h = N1 - Nstep;
else
    ext_h = N1 - rem_h;
end
if rem_w == 0
    ext_w = N2 - Nstep;
else
    ext_w = N2 - rem_w;
end

z = noisy;
z = [z, z(:,end:-1:end-ext_w+1)];
z = [z; z(end:-1:end-ext_h+1,:)];
y_est = [y_est, y_est(:,end:-1:end-ext_w+1)];
y_est = [y_est; y_est(end:-1:end-ext_h+1,:)];

y_den = zeros(size(z));
weight_total = zeros(size(z));


gamma1 = 0.5;
gamma2 = 40.0;
n_coeffs = N1*N2;

for row = 1:Nstep:height
    for col = 1:Nstep:width
        blk_est = y_est(row:row+N1-1, col:col+N2-1);
        array3D = [];
        
        row_min = max(row-(Ns-1)/2,1);
        row_max = min(row+(Ns-1)/2,size(noisy,1));
        col_min = max(col-(Ns-1)/2,1);
        col_max = min(col+(Ns-1)/2,size(noisy,2));
        
        if (row_max - row_min)< (Ns-1)/2
            row_min = size(noisy,1)-(Ns-1)/2;
            row_max = size(noisy,1);
        end
        
        if (col_max - col_min)< (Ns-1)/2
            col_min = size(noisy,2)-(Ns-1)/2;
            col_max = size(noisy,2);
        end
        array3D_p= [];
        for idx = 1:size(im_train_sim,3)
            train_image = im_train_sim(:,:,idx);
            array3D_temp = train_image(row_min:row_max, col_min:col_max);
            array3D_p = cat(3, array3D_p, array3D_temp);
        end
        
        noisy_window = y_est(row_min:row_max, col_min:col_max);
        search_window =  array3D_sorting(noisy_window, array3D_p, top_similar , tau_match);
        
        for idx = 1:top_similar
            [array3D_temp, ~, ~] = blk_matching(blk_est, search_window(:,:, idx), cands_per_im , tau_match);
            array3D = cat(3, array3D, array3D_temp);
        end
        
        suitable_cands = N1*N2;
        array3D = array3D_sorting(blk_est, array3D, suitable_cands , tau_match);       
        
        suitable_cands_len = min(suitable_cands, size(array3D, 3));
        array2D_low = reshape(array3D, ([suitable_cands , suitable_cands_len ]));
        array3D = array3D(:, :, 1 : cands_patchs);
        array2D = reshape(array3D, [N1*N2, size(array3D,3)]);
        
        blk_ref = z(row:row+N1-1, col:col+N2-1);
        blk_ref = blk_ref(:);
        
        % Non local means weighting
        W_vec = (array2D - repmat(blk_ref, 1, size(array2D,2))).^2;
        W_vec = sum(W_vec) - N1*N2*nSig^2;
        W_vec = exp(-max(W_vec, 0)/(N1*N2*nSig^2*0.6*0.6));
        W_vec = W_vec'/sum(W_vec);
        mu = array2D * W_vec;
        
        blk_ref = blk_ref - mu;
        
        array2D = array2D - repmat(mu, 1, size(array2D,2));
        
        W_vec = (array2D_low - repmat(blk_ref, 1, size(array2D_low,2))).^2;
        W_vec = sum(W_vec) - N1*N2*nSig^2;
        W_vec = exp(-max(W_vec, 0)/(N1*N2*nSig^2*0.6*0.6));
        W_vec = W_vec'/sum(W_vec);
        mu_low = array2D_low * W_vec;
        array2D_low = array2D_low - repmat(mu_low, 1, size(array2D_low, 2));
        
        
        x_Low_rank = Low_rank([blk_ref array2D_low], par.tao, nSig/255);
        x_Low_coeff = reshape(dct2(reshape(x_Low_rank, [N1, N2])), N1*N2, 1);
        array2D_coeff = transform_patches(array2D, N1, N2 );
        
        blk_ref_coeff = reshape(dct2(reshape(blk_ref, [N1, N2]) ),N1*N2, 1);
        
        denum = (1 + gamma2 ) * eye(n_coeffs-1)+ gamma1* inv(diag(var(array2D_coeff(2:end, :),[], 2)));
        num = 1*blk_ref_coeff(2:end) + gamma1 * inv(diag(var(array2D_coeff(2:end, :), [],2))) * mean(array2D_coeff(2:end, :), 2) + gamma2 * x_Low_coeff(2:end);
        x_noisy_new = denum\num;
        
        x_noisy_new = reshape(dct2(reshape([blk_ref_coeff(1); x_noisy_new], [N1, N2])), N1*N2, 1);
        x_noisy_new = x_noisy_new + mu;
        
        rec_ref = reshape(x_noisy_new, [N1,N2]);
        
        
        weight = 1;
        y_den(row:row+N1-1, col:col+N2-1)    = y_den(row:row+N1-1, col:col+N2-1)    + rec_ref;
        weight_total(row:row+N1-1, col:col+N2-1) = weight_total(row:row+N1-1, col:col+N2-1) + weight;
        
    end
end
y_est  = y_den(1:height,1:width)./weight_total(1:height,1:width);

end