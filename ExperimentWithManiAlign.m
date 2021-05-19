% Script to shuffle the pixels for rgb. The RGB pixels were extracted using
% superpixel classification which isn't correctly clustering the image.

bushPx = 41;
mudPx = 51;
rocksPx = 61;
concretePx = 71;
skyPx = 21;
snowPx = 31;
dirtPx = 11;
objectsPx = 1;

PxClassVector = [41, 51, 61, 71, 21, 31, 11, 1];
newRgbPxPairs = zeros(10 * classesCount, 2);

for nn = 1:length(PxClassVector)
    for i = 1:10
        newRgbPxPairs(((nn - 1) * 10) + i, :) = pixelPairs((PxClassVector(nn) - 1) + i, :);
    end
end

RGB_selectedpixels = newRgbPxPairs;
HSI_selectedpixels = extractedHsiPixels;

