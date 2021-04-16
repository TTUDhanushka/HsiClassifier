function rgb_from_hsi = ConstructFalseRgbImage(corrected_hsi_cube, ,greenBand, blueBand)

    [h, w, d] = size(corrected_hsi_cube);
    
    % Display image slices.
    slice1 = uint8(corrected_hsi_cube(:,:,redBand)/16);
    slice2 = uint8(corrected_hsi_cube(:,:,58)/16);
    slice3 = uint8(corrected_hsi_cube(:,:,85)/16);

    slice = cat(3, slice3, slice2, slice1);
       
    rgb_from_hsi = slice;
end