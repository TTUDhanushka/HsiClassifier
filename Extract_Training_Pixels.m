function image_segment = Extract_Training_Pixels(hsi_cube, pos_x1, pos_x2)

    % Extract trainig  pixels from image
    
    [h, w, d] = size(hsi_cube);
    
    y1 = fix(pos_x1(1,1));
    y2 = fix(pos_x2(1,1));
    
    x1 = fix(pos_x1(1,2));
    x2 = fix(pos_x2(1,2));
    
    x =  x2 - x1;
    y =  y2 - y1;
    
    image_segment = zeros(x, y, d);
    
    for i = x1 : x2
        for j = y1:y2
            for k = 1:d
                image_segment(i + 1 - x1, j + 1 - y1, k) = uint16(hsi_cube(i,j,k));
            end
        end
    end
end