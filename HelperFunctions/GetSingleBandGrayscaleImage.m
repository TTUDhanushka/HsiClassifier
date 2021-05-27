
% Display signel band hyperspectral image.

function imgGrayOut = GetSingleBandGrayscaleImage(data_cube, band)

    [cube_h, cube_w, ~] = size(data_cube);

    imgGrayOut = zeros(cube_h, cube_w, 1, 'uint8');


    for i = 1:cube_h
        for j = 1: cube_w
            imgGrayOut(i, j) = uint8(data_cube(i, j, band) * 255);
        end
    end
   
end
