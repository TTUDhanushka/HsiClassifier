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
       
    % White reference average
    white_ref_avg = zeros(1, d);
    dark_ref_avg = zeros(1, d);
    
    for i = 1:d
        dark_ref_avg(1,i) = mean (dark_ref(:,1,i));
        white_ref_avg(1,i) = mean (white_ref(:,1,i));
    end
    
    for i = 1:h
        for j = 1:w
            for k = 1:d
                calibrated_hsi(i,j,k) = (255 * (hsi_cube(i,j,k) - dark_ref_avg(k)) / (white_ref_avg(k) - dark_ref_avg(k)));
            end
        end
    end
    

end