function [clust_cent, c_idx]= loadClusters(image_patches, level)
% Written by Saeed
% Load clusters but it will be later merged with Parset;

    fprintf('Loading clusters....\n');
    load( ['clusters_knn_noDC_' num2str(level) '.mat']);
    c_idx = cluster.clusters;
    if level==1
        N =3;
    else
        N=size(c_idx,2);
    end
    for k=1:length(c_idx)
       clust_patchs = image_patches(:, c_idx(k, 1:N) );
       clust_cent(:,k) = mean(clust_patchs,2);
    end

end