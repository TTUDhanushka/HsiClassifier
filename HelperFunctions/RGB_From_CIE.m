function [rgbImage] = RGB_From_CIE(dataCube)

    % Get the sizes of HSI data cube.
    [h, w, d] = size(dataCube);
    
    rgbImage = zeros(h, w, 3, 'uint8');
end