function rgb_Out = ConstructRgbImage(hsi_cube, redBand,greenBand, blueBand)

    [h, w, d] = size(hsi_cube);
    
    % Display image slices.
    slice1 = uint8(hsi_cube(:,:, redBand) * 255);
    slice2 = uint8(hsi_cube(:,:, greenBand) * 255);
    slice3 = uint8(hsi_cube(:,:, blueBand) * 255);

    slice = cat(3, slice3, slice2, slice1);
       
    rgb_Out = slice;
end