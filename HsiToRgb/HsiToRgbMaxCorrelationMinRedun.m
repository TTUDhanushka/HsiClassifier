%% True color image generation 

% reference: Hyperspectral Image Visualization Using Band Selection,
% Hongjun Su, Qian Du, Peijun Du
%

redBandRange = [610, 700];
greenBandRange = [500, 570];
blueBandRange = [450, 500];


if ~exist('bands')
    bands = 204;
end

suitableRedBands = [];
suitableGreenBands = [];
suitableBlueBands = [];

for n = 1:length(bSet)
    if (redBandRange(1) < reflectanceCube.Wavelength(bSet(n))) && (redBandRange(2) > reflectanceCube.Wavelength(bSet(n)))
        suitableRedBands = [suitableRedBands, bSet(n)];
        
    elseif (greenBandRange(1) < reflectanceCube.Wavelength(bSet(n))) && (greenBandRange(2) > reflectanceCube.Wavelength(bSet(n)))
        suitableGreenBands = [suitableGreenBands, bSet(n)];
    
    elseif (blueBandRange(1) < reflectanceCube.Wavelength(bSet(n))) && (blueBandRange(2) > reflectanceCube.Wavelength(bSet(n)))
        suitableBlueBands = [suitableBlueBands, bSet(n)];
    end
end

%% Get the maximum correlated band from a group

% dataCube = reflectanceCube.DataCube;

theRedBand = 0;

if length(suitableRedBands) > 2   
    decisionMatrixRed = zeros(length(suitableRedBands));
    
    for nId = 1: length(suitableRedBands)
        
        band1 = nId;
        band2 = nId + 1;
        
        if (nId + 1) > 3
            band2 = nId + 1 - 3;
        end
        
        decisionMatrixRed(band1, band2) = CovarianceHsiBands(suitableRedBands(band1), suitableRedBands(band2), reflectanceCube.DataCube);
        decisionMatrixRed(band2, band1) = CovarianceHsiBands(suitableRedBands(band1), suitableRedBands(band2), reflectanceCube.DataCube);
                
    end
    
    [v, index] = max(sum(decisionMatrixRed));
    
    theRedBand = suitableRedBands(index);
    
elseif (length(suitableRedBands) == 2)
    band1_mean = mean2(reflectanceCube.DataCube(:, :, suitableRedBands(1)));
    band2_mean = mean2(reflectanceCube.DataCube(:, :, suitableRedBands(2)));
    
    if (band1_mean > band2_mean)
        theRedBand = suitableRedBands(1);
    else
        theRedBand = suitableRedBands(2);
    end
else
    % Get the only band and use it
    theRedBand = suitableRedBands(1);
end

theGreenBand = 0;

if length(suitableGreenBands) > 2   
    decisionMatrixGreen = zeros(length(suitableGreenBands));
    
    for nId = 1: length(suitableGreenBands)
        
        band1 = nId;
        band2 = nId + 1;
        
        if (nId + 1) > 3
            band2 = nId + 1 - 3;
        end
        
        decisionMatrixGreen(band1, band2) = CovarianceHsiBands(suitableGreenBands(band1), suitableGreenBands(band2), reflectanceCube.DataCube);
        decisionMatrixGreen(band2, band1) = CovarianceHsiBands(suitableGreenBands(band1), suitableGreenBands(band2), reflectanceCube.DataCube);
                
    end
    
    [v, index] = max(sum(decisionMatrixGreen));
    
    theGreenBand = suitableGreenBands(index);
    
elseif (length(suitableGreenBands) == 2)
    band1_mean = mean2(reflectanceCube.DataCube(:, :, suitableGreenBands(1)));
    band2_mean = mean2(reflectanceCube.DataCube(:, :, suitableGreenBands(2)));
    
    if (band1_mean > band2_mean)
        theGreenBand = suitableGreenBands(1);
    else
        theGreenBand = suitableGreenBands(2);
    end
else
    % Get the only band and use it
    theGreenBand = suitableGreenBands(1);
end

theBlueBand = 0;

if length(suitableBlueBands) > 2   
    decisionMatrixBlue = zeros(length(suitableBlueBands));
    
    for nId = 1: length(suitableBlueBands)
        
        band1 = nId;
        band2 = nId + 1;
        
        if (nId + 1) > 3
            band2 = nId + 1 - 3;
        end
        
        decisionMatrixBlue(band1, band2) = CovarianceHsiBands(suitableBlueBands(band1), suitableBlueBands(band2), reflectanceCube.DataCube);
        decisionMatrixBlue(band2, band1) = CovarianceHsiBands(suitableBlueBands(band1), suitableBlueBands(band2), reflectanceCube.DataCube);
                
    end
    
    [v, index] = max(sum(decisionMatrixBlue));
    
    theBlueBand = suitableBlueBands(index);
    
elseif (length(suitableBlueBands) == 2)
    band1_mean = mean2(reflectanceCube.DataCube(:, :, suitableBlueBands(1)));
    band2_mean = mean2(reflectanceCube.DataCube(:, :, suitableBlueBands(2)));
    
    if (band1_mean > band2_mean)
        theBlueBand = suitableBlueBands(1);
    else
        theBlueBand = suitableBlueBands(2);
    end
else
    % Get the only band and use it
    theBlueBand = suitableBlueBands(1);
end

selectedTriBands = [theRedBand, theGreenBand, theBlueBand];

%% Display the image

falseRgbImage = zeros(cube_h, cube_w, 3, 'uint8');

for i = 1:cube_h
    for j = 1: cube_w
        falseRgbImage(i, j, 1) = uint8(reflectanceCube.DataCube(i, j, selectedTriBands(1)) * 255);
        falseRgbImage(i, j, 2) = uint8(reflectanceCube.DataCube(i, j, selectedTriBands(2)) * 255);
        falseRgbImage(i, j, 3) = uint8(reflectanceCube.DataCube(i, j, selectedTriBands(3)) * 255);
    end
end

% figure();

rot_Image = imrotate(falseRgbImage, -90);
% imshow(rot_Image);
