function [Ys, W] = noisy_patchs_grouping(X, p_labels, par, nSig)
Ys =  ones(size(X));
W  =  ones(size(X));
idx = unique(p_labels);
for i = 1:length(idx)
    inds3 = find(idx(i)==p_labels);
    B = X(:, inds3);
    [X_new, dc] = remove_dc(B, 'columns');
    
    %array3D_sorting()
    [Ys(:,inds3), W(:, inds3)] =  Low_rank( X_new, par.tao, nSig, dc);
    
end

end