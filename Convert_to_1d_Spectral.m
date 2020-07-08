function single_dim_image = Convert_to_1d_Spectral(hsi_cube)

    [h, w, d] = size(hsi_cube);
    
    len = h * w;
    vec_hsi = zeros(len, d);
    cnt = 1;
        
    for i = 1: h
        for j = 1:w
            for k = 1: d
                 vec_hsi(cnt, k) = hsi_cube(i, j, k);  
            end
            cnt = cnt + 1;
        end
    end
    
    single_dim_image = vec_hsi;
end