function output_image = FlipHsiImage(hsi_image, direction)
    % Original HSI images are flipped on the given direction, It is either
    % horizontal or vertical
    % Note: Use the 'H' tranform only. The images are rotated in the
    % readFcn for dataloader.

    [h, w, d] = size(hsi_image);
    output_image = zeros(h, w, d);
    
    switch (direction)
        case 'H'
            for idx = 1: h
                output_image((h - (idx - 1)), :, :) = hsi_image(idx, :, :);
            end
            
        case 'V'
            for idw = 1: w
                output_image(:, (w - (idw - 1)), :) = hsi_image(:, idw, :);
            end
    end
           
end