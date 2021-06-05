function [rgbImage] = RGB_From_CIE(dataCube, selectedBands)

    % Get the sizes of HSI data cube.
    [h, w, ~] = size(dataCube);

    rgbImage = zeros(h, w, 3, 'uint8');

    XYZ_to_RGB = [3.2404542 -1.5371385 -0.4985314;
        -0.9692660 1.8760108 0.0415560;
        0.0556434 -0.2040259 1.0572252];
    
    upperBand = 141;        % This represent the 812 nm wavelength.

    bandsInVisRegion = [];
    
    for nBand = 1:length(selectedBands)
        if selectedBands(nBand) < upperBand
            bandsInVisRegion = [bandsInVisRegion, selectedBands(nBand)];
        end
    end
    
    lowBandImage = ReducedBandImage(dataCube, bandsInVisRegion);
    pixel = zeros(1, length(bandsInVisRegion));
    
    
    for i = 1:h
        for j = 1:w
            
            pixel(1, :) = lowBandImage(i, j, :);
            pixelColor = zeros(3, 1, 'double');
            
            for nBand = 1:length(bandsInVisRegion)
                xyz = CieLutTable(bandsInVisRegion(nBand));

                rgbColor = (XYZ_to_RGB * xyz(2:4)') .* pixel(1, nBand);
                
                pixelColor = pixelColor + rgbColor;
            end
            
            rgbImage(i, j, :) = (pixelColor / nBand) .* 255;
            
        end
    end
    
    figure();
    imshow(rgbImage);
end