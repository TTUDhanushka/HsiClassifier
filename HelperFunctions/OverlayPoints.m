% plot the circles on image.

function varargout = OverlayPoints(higResRgbRot, pixelList)
 
    for n = 1:length(pixelList)
 
        scaleVal = 1.2598;
        r = 10;
        th = 0:pi/50:2*pi;
        xunit = round(((r * cos(th)) + pixelList(n, 1) * scaleVal));
        yunit = round(((r * sin(th)) + pixelList(n, 2) * scaleVal));


        for i = 1:length(xunit)
            higResRgbRot(xunit(i), yunit(i), :) = [0, 0, 255];
        end
    end
    
    figure();
    imshow(higResRgbRot)
end