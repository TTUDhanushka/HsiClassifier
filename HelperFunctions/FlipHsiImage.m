function output_image = FlipHsiImage(hsi_image, direction)
    % Original HSI images are flipped on the given direction, It is either
    % horizontal or vertical
    %

    [w, h, d] = size(hsi_image);
    output_image = zeros(h, w, d);
    
    
    for idx = 1: h
        output_image((h - (idx - 1)), :, :) = hsi_image(idx, :, :);
    end
           
end