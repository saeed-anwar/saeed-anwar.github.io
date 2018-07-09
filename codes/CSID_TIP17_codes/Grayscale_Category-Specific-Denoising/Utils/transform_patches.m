function dct_coeff = transform_patches(array2D, N1, N2 )
    for i = 1:size(array2D, 2)
        dct_coeff(:, i) = reshape(dct2(reshape(array2D(:, i), [N1, N2])), N1*N2, 1);
    end
end