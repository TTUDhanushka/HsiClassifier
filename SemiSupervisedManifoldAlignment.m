% Extract pixel pairs from both HSI and RGB images manually and let the
% algorithm to pick up some random pixels for manifold alignment.

if ~exist('hsiToRgbManifoldDatasetGen', 'var')
    hsiToRgbManifoldDatasetGen = false;
end


if hsiToRgbManifoldDatasetGen
    fb_HSI_Image = RotateHsiImage(hsiCubeData.DataCube, -90);
    rgbFromHsi = ConstructRgbImage(fb_HSI_Image, 2, 3, 4);
    
else
    fb_HSI_Image = RotateHsiImage(reflectanceCube.DataCube, -90);
    rgbFromHsi = GetTriBandRgbImage(fb_HSI_Image);
end

classesInHsi = 7;
noOfSample = 10;

% Positions in [height, width] format.
extractedHsiPixels = zeros(noOfSample * classesInHsi, 2);
extractedHsiVector = zeros(noOfSample, 2);

extractedRgbPixels = zeros(noOfSample * classesInHsi, 2);
extractedRgbVector = zeros(noOfSample, 2);

 for nId = 1: classesInHsi
    
    [topLeft, btmRight] = PickUpPixelArea(rgbFromHsi);
    
    H = (btmRight(1) - topLeft(1));
    W = (btmRight(2) - topLeft(2));
    
    totalSamples = H * W;
    
    coordList = zeros(totalSamples, 2);
    
    for nX = 1:H
        for nY = 1:W
            coordList(((nX - 1) * W) + nY, :) = [(topLeft(1) - 1) + nX, (topLeft(2) - 1) + nY];
        end
    end
    
    % Randomize the data and pick n number of samples.
    randIds = randperm(totalSamples);
    
    for px = 1: noOfSample
        extractedHsiVector(px, :) = coordList(randIds(px), :);
    end
    
    extractedHsiPixels((((nId - 1) * noOfSample) + 1): (((nId - 1) * noOfSample) + noOfSample), :) = extractedHsiVector(:,:);
    
% end

%% RGB

% Positions in [height, width] format.

% for nId = 1: classesInHsi
    
    [topLeft, btmRight] = PickUpPixelArea(higResRgb);
    
    H = (btmRight(1) - topLeft(1));
    W = (btmRight(2) - topLeft(2));
    
    totalSamples = H * W;
    
    coordList = zeros(totalSamples, 2);
    
    for nX = 1:H
        for nY = 1:W
            coordList(((nX - 1) * W) + nY, :) = [(topLeft(1) - 1) + nX, (topLeft(2) - 1) + nY];
        end
    end
    
    % Randomize the data and pick n number of samples.
    randIds = randperm(totalSamples);
    
    for px = 1: noOfSample
        extractedRgbVector(px, :) = coordList(randIds(px), :);
    end
    
    extractedRgbPixels((((nId - 1) * noOfSample) + 1): (((nId - 1) * noOfSample) + noOfSample), :) = extractedRgbVector(:,:);
    
    close all;
    
end

%% Clear variables

vars = {'noOfSample', 'nId', 'btmRight', 'classesInHsi', 'coordList',...
     'randIds', 'px', 'nX', 'nY', 'H', 'W', 'topLeft', 'totalSamples'};

clear(vars{:});