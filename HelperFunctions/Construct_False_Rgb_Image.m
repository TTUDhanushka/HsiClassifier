function rgb_from_hsi = Construct_False_Rgb_Image(corrected_hsi_cube, redBand,greenBand, blueBand)

    [h, w, d] = size(corrected_hsi_cube);
    
    % Display image slices.
    slice1 = uint8(corrected_hsi_cube(:,:, redBand)/16);
    slice2 = uint8(corrected_hsi_cube(:,:, greenBand)/16);
    slice3 = uint8(corrected_hsi_cube(:,:, blueBand)/16);

    slice = cat(3, slice3, slice2, slice1);
       
    rgb_from_hsi = slice;
end