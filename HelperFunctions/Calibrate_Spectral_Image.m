function [calibrated_hsi, error] = Calibrate_Spectral_Image(hsi_cube, white_ref, dark_ref, userInputImage, pre_calib)
    
%%  White / dark correction
%   
%   For the HSI datacubes captured with white calibration pad placed on the
%   scene itself. In such situations, the white reference should be taken
%   from the image as user input.

%% Get the image cube and prepare preview image.

    [h, w, d] = size(hsi_cube);
    [h_w, w_w, d_w] = size(white_ref);
    [h_d, w_d, d_d] = size(dark_ref);
    
    calibrated_hsi = zeros(h, w, d);
    
    % Get the dimensions of the image.  numberOfColorBands should be = 1.
    [rows columns numberOfColorBands] = size(userInputImage(:,:,1));
    
    greyImage = userInputImage(:,:,1);
    
    if not(pre_calib)
        % Display the original gray scale image.
        imshow(userInputImage, []);

        % Enlarge figure to full screen.
        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
        set(gcf,'name','Extract samples','numbertitle','off') 

        message = sprintf('Draw a box');
        uiwait(msgbox(message));

        k = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);

    % p_1 and p_2 are in reverse order.
        p_1 = fix(point1);
        p_2 = fix(point2);

        white_ref_cube = zeros(p_2(2)-p_1(2), p_2(1)-p_1(1), d);

        for idy_white = 1: (p_2(2)-p_1(2))
            for idx_white = 1: (p_2(1)-p_1(1))
                white_ref_cube(idy_white, idx_white, :) = hsi_cube(idy_white + p_1(2), idx_white + p_1(1), :);
            end    
        end
        
    end

    
%% Perform white calibration 
    
    % Check the number of bands in each reference image and raw image.
    if (d ~= d_w) || (d ~= d_d)
        error = "dimensions are not equal";
    else
        error = "";
    end
       
    % White reference average
    white_ref_avg = zeros(1, d);
    dark_ref_avg = zeros(1, d);
            

    if not(pre_calib)
        for idx_dark = 1:d
            dark_ref_avg(1,idx_dark) = mean (dark_ref(:,1,idx_dark));
            white_ref_avg(1,idx_dark) = mean (white_ref_cube(:,1,idx_dark));
        end
    else
        for idx_dark = 1:d
            dark_ref_avg(1,idx_dark) = mean (dark_ref(:,1,idx_dark));
            white_ref_avg(1,idx_dark) = mean (white_ref(:,1,idx_dark));
        end
    end
  
             
    for i = 1:h
        for j = 1:w
            for k = 1:d
                calibrated_hsi(i,j,k) = (hsi_cube(i,j,k) - dark_ref_avg(k)) / (white_ref_avg(k) - dark_ref_avg(k));
            end
        end
    end

end