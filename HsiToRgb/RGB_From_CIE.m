function [rgbImage] = RGB_From_CIE(dataCube, selectedBands)

    rotDataCube = RotateHsiImage(dataCube, -90);
    
    % Get the sizes of HSI data cube.
    [h, w, ~] = size(rotDataCube);

    rgbImage = zeros(h, w, 3, 'uint8');
    rgbTempImage = zeros(h, w, 3, 'double');
    
    XYZ_to_RGB = [3.2404542 -1.5371385 -0.4985314;
        -0.9692660 1.8760108 0.0415560;
        0.0556434 -0.2040259 1.0572252];
    
    upperBand = 141;        % This represent the 812 nm wavelength.

    bandsInVisRegion = [];
    
    for nBand = 1:length(selectedBands)
        if (selectedBands(nBand) < upperBand)
            bandsInVisRegion = [bandsInVisRegion, selectedBands(nBand)];
        end
    end
    
    lowBandImage = ReducedBandImage(rotDataCube, bandsInVisRegion);
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
            
            rgbTempImage(i, j, :) = pixelColor;
            
        end
    end
    
    redMax = max(rgbTempImage(:,:, 1), [],'all');
    redMin = min(rgbTempImage(:,:, 1), [],'all');
    
    greenMax = max(rgbTempImage(:,:, 2), [],'all');
    greenMin = min(rgbTempImage(:,:, 2), [],'all');
    
    blueMax = max(rgbTempImage(:,:, 3), [],'all');
    blueMin = min(rgbTempImage(:,:, 3), [],'all');
    
    brightness = 550;
    
    rgbImage(:, :, 1) = ((rgbTempImage(:, :, 1) - redMin) / (redMax - redMin)) * brightness;
    rgbImage(:, :, 2) = ((rgbTempImage(:, :, 2) - greenMin) / (greenMax - greenMin)) * brightness;
    rgbImage(:, :, 3) = ((rgbTempImage(:, :, 3) - blueMin) / (blueMax - blueMin)) * brightness;
    
    figure();
    imshow(rgbImage)
    
end