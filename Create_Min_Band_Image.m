function reduced_hsi = Create_Min_Band_Image(hsi_cube, bands)

    % Create a HSI image with reduced number of bands
    
    [h, w, d] = size(hsi_cube);
    [x, band_count] = size(bands);
    
    reduced_hsi = zeros(h,w,band_count);

        
    for i = 1:h
        for j = 1:w
            for k = 1: band_count
                reduced_hsi(i,j,k) = hsi_cube(i,j,bands(1, k));
            end
        end
    end

end