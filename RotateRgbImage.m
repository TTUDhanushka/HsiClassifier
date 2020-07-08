function output_image = RotateRgbImage(rgb_image, angle)
    %% 
    % imrotate function works only for grayscale images, therefore color
    % plances extracted from original image and rotated individually.
    % Finally combine all the planes together to rebuild the RGB color
    % image.
    
    %%

    r_plane = rgb_image(:,:,1);
    r_plane = imrotate(r_plane, angle);
    
    g_plane = rgb_image(:,:,2);
    g_plane = imrotate(g_plane, angle);
    
    b_plane = rgb_image(:,:,3);
    b_plane = imrotate(b_plane, angle);
        
    output_image = cat(3,r_plane, g_plane, b_plane);
end