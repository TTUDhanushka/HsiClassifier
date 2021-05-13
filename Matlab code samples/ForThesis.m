%% Pixel pairs image rotation for thesis

% higResRgbRot = higResRgbRot;
hsiCube = reflectanceCube.DataCube;
pixelListRgb = RGB_selectedpixels;
pixelListHsi = HSI_selectedpixels;

    [h, w, d] = size(hsiCube);

    point = 1;
    
higResRgbRotA = higResRgbRot;
    higResRgbRotA = imrotate(higResRgbRotA, -90);
    
    for n = 1:length(pixelListRgb)
 
%         scaleVal = 1.2598;
        r = 10;
        th = 0:pi/50:2*pi;
        xunit = 645 - round((r * cos(th)) + pixelListRgb(n, 1));
        yunit = round((r * sin(th)) + pixelListRgb(n, 2));


        
        for i = 1:length(xunit)
            higResRgbRotA(yunit(i), xunit(i), :) = [0, 0, 255];

        end

        higResRgbRotA = insertText(higResRgbRotA, [645 - pixelListRgb(n, 1), pixelListRgb(n, 2)], point);
        point = point + 1;

    end
    

    
    hsiImage = GetTriBandRgbImage(hsiCube);
    
    hsiImageA = hsiImage;
        
    hsiImageA = imrotate(hsiImageA, -90);    
    pointHs = 1;
    
    for n = 1:length(pixelListHsi)
 
        r = 10;
        th = 0:pi/50:2*pi;
        
        xunit = 512 - round((r * cos(th)) + pixelListHsi(n, 1));
        yunit = round((r * sin(th)) + pixelListHsi(n, 2));


        for i = 1:length(xunit)
            hsiImageA(yunit(i), xunit(i),  :) = [255, 200, 0];
        end

        hsiImageA = insertText(hsiImageA, [512 - pixelListHsi(n, 1), pixelListHsi(n, 2)], pointHs);
        pointHs = pointHs + 1;
    end
    
    figure();
    subplot(2,1,1);
    imshow(hsiImageA);
    imwrite(hsiImageA,'hsi_image_pixel_pairs.png');
    
    subplot(2,1,2);

    imshow(higResRgbRotA);
    imwrite(higResRgbRotA,'rgb_image_pixel_pairs.png');

%%