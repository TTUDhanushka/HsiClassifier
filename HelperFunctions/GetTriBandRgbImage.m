function imgOut = GetTriBandRgbImage(sample_cube)
    % This uses three image bands from the HSI image. Band 26, 51 and 99
    % are the three bands to generate RGB equivalent.
    
    
    [cube_h, cube_w, ~] = size(sample_cube);

    imgOut = zeros(cube_h, cube_w, 3, 'uint8');


    for i = 1:cube_h
        for j = 1: cube_w
            imgOut(i, j, 3) = uint8(sample_cube(i, j, 26) * 255);
            imgOut(i, j, 2) = uint8(sample_cube(i, j, 51) * 255);
            imgOut(i, j, 1) = uint8(sample_cube(i, j, 99) * 255);
        end
    end

end