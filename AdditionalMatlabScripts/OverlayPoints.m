% Mark pixel pair locations as circles on image.

function varargout = OverlayPoints(higResRgbRot, hsiImage, pixelListRgb, pixelListHsi)

%     [h, w, d] = size(hsiCube);

    point = 1;

    for n = 1:length(pixelListRgb)
 
        r = 3;
        th = 0:pi/50:2*pi;
        xunit = round((r * cos(th)) + pixelListRgb(n, 1));
        yunit = round((r * sin(th)) + pixelListRgb(n, 2));

        
%         for i = 1:length(xunit)
%             higResRgbRot(xunit(i), yunit(i), :) = [0, 0, 255];
%         end
        
        higResRgbRot = insertText(higResRgbRot, [pixelListRgb(n, 2), pixelListRgb(n, 1)], point);
        point = point + 1;

    end
    
%     hsiImage = GetTriBandRgbImage(hsiCube);
    
    pointHs = 1;
    
    for n = 1:length(pixelListHsi)
 
        r = 10;
        th = 0:pi/50:2*pi;
        
        xunit = round((r * cos(th)) + pixelListHsi(n, 1));
        yunit = round((r * sin(th)) + pixelListHsi(n, 2));


%         for i = 1:length(xunit)
%             hsiImage(xunit(i), yunit(i), :) = [255, 200, 0];
%         end
        
        hsiImage = insertText(hsiImage, [pixelListHsi(n, 2), pixelListHsi(n, 1)], pointHs);
        pointHs = pointHs + 1;
    end
    
    figure();
    subplot(1,2,1);
    imshow(hsiImage);
    
    subplot(1,2,2);
    imshow(higResRgbRot);
    
end