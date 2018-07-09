function X_new= inv_transform_patches(X,  par)
    % X: Denoised Vectorise patchs
    % dc: DC components
    
    cluster_noisy = [];
    
    %% Add DC in the Coefficient Domain
    % X = [dc; X];
    for i = 1:size(X, 2)
        Coeff = idct2(reshape(X(:,i), par.win1, par.win2));
        cluster_noisy = [cluster_noisy Coeff(:)];
    end
    X_new = cluster_noisy;
    
    %% Add DC to the intensity values
    % X = [zeros(1, length(X)); X];
    % for i = 1:length(X)
    %     Coeff = idct2(reshape(X(:,i),8,8));
    %     cluster_noisy = [cluster_noisy Coeff(:)];
    % end
    % X_new = add_dc(cluster_noisy, noisy_dc, 'columns');
end