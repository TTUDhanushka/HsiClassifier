function rgb_from_hsi = ConstructRgbImage(hsi_cube)

    [h, w, d] = size(hsi_cube);
    

    % Display image slices.
    slice1 = uint8(hsi_cube(:,:,20)/16);
    slice2 = uint8(hsi_cube(:,:,58)/16);
    slice3 = uint8(hsi_cube(:,:,85)/16);

    slice = cat(3, slice3, slice2, slice1);
       
%     rgb_from_hsi = imrotate(slice, 0);
    rgb_from_hsi = slice;
end