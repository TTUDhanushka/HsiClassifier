function selected_bands = HsiCubePca(hsi_cube, bands_count)
    
%%
%   Implement principle component anlysis
%   
%   Coeff - Gives principle component coefficients for new pca image
%   Score - Gives the contribution of the principle compoent
%
%%
    selected_bands = zeros(1, bands_count);
    
    [h, w, d] = size(hsi_cube);

    len = h * w;
    vec_hsi = zeros(len, d);
    cnt = 1;
        
%     for i = 1: h
%         for j = 1:w
%             for k = 1: d
%                  vec_hsi(cnt, k) = hsi_cube(i, j, k);  
%             end
%             cnt = cnt + 1;
%         end
%     end

    for i = 1: h
        for j = 1:w
            for k = 1: d
                 vec_hsi(cnt, k) = hsi_cube(i, j, k);  
            end
            cnt = cnt + 1;
        end
    end
    
    size(vec_hsi);
    latent_list = zeros(1, d);
    
    for m = 1:d
        [coeff, score, latent] = pca(vec_hsi(:,m));   
        latent_list(1,m) = latent;
    end
    
    [p,q] = sort(latent_list,'descend');
    
        latent_list_2 = zeros(1, d);
    for m = 1:d
        [coeff_2, score_2, latent_2] = pca(hsi_cube(:,:,m));  
        lat_ave = sum(latent_2);
        latent_list_2(1,m) = lat_ave;
    end
    
    [r,s] = sort(latent_list_2, 'descend');
    
    temp_band_list = zeros(1, bands_count);
    
    for n = 1: bands_count
        temp_band_list(1, n) = s(1, n);
    end
    
    [sorted, index] = sort(temp_band_list);
    
    selected_bands = sorted;
    
%     [coeff, score, latent] = pca(vec_hsi);
    
    
    
end