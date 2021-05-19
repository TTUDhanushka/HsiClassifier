function output_image = RotateHsiImage(hsi_image, angle)
    % Original HSI images are rotated counter-clockwise 90 deg which need
    % to be corrected.
    % use -90 as angle.

    [w, h, d] = size(hsi_image);
    output_image = zeros(h, w, d);
    tempRotImage = zeros(h, w);
    
    for layer = 1:d
        tempRotImage(:,:) = imrotate(hsi_image(:,:, layer), angle);        
        output_image(:,:, layer) =  tempRotImage(:,:); 
    end
        
end