function [calibrated_hsi, error] = Calibrate_Spectral_Image(hsi_cube, white_ref, dark_ref)
    
%%  Flat field correction
%   
%

%%
    [h, w, d] = size(hsi_cube);
    [h_w, w_w, d_w] = size(white_ref);
    [h_d, w_d, d_d] = size(dark_ref);
    
    calibrated_hsi = zeros(h, w, d);
    
    % Check the number of bands in each reference image and raw image.
    if (d ~= d_w) || (d ~= d_d)
        error = "dimensions are not equal";
    else
        error = "";
    end
    
    dark_ref_avg = zeros(1, d);
    white_ref_avg = zeros(1, d);
    
    for i = 1:d
        dark_ref_avg(1,i) = mean (dark_ref(:,1,i));
        white_ref_avg(1,i) = mean (white_ref(:,1,i));
    end
    
    z = zeros(512, 204);
    
    for z_idx = 1:512
        for z_idy = 1:204
            z(z_idx, z_idy) = white_ref(z_idx,1,z_idy);
        end
    end
    
%     figure()
%     xx = linspace(1, 512, 512)
%     plot(xx, z(:,1))
    
    
    for i = 1:h
        for j = 1:w
            for k = 1:d
                calibrated_hsi(i,j,k) = (4096 * (hsi_cube(i,j,k) - dark_ref(i,1,k)) / (white_ref(i,1,k) - dark_ref(i,1,k)));
            end
        end
    end
    

end