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

%% correlation calculation

bandA = 75;
bandB = 99;
bandC = 75;

totalpixels = cols * lines;

corSlice = zeros(cols, lines, 1);

for i = 1:cols
    for j = 1:lines
        %corSlice = reflectanceCube.DataCube(i, j, bandA) * 255;
        sumA = sumA + (reflectanceCube.DataCube(i, j, bandA) * 4095);
    end
end

for i = 1:cols
    for j = 1:lines
        sumB = sumB + (reflectanceCube.DataCube(i, j, bandB) * 4095);
    end
end

Ua = sumA / totalpixels;
Ub = sumB / totalpixels;

varA = 0;

for i = 1:cols
    for j = 1:lines
        varA = varA + ((reflectanceCube.DataCube(i, j, bandA) * 4095) - Ua)^2;
    end
end

covA = sqrt(varA);

varB = 0;

for i = 1:cols
    for j = 1:lines
        varB = varB + ((reflectanceCube.DataCube(i, j, bandB) * 4095) - Ub)^2;
    end
end

covB = sqrt(varB);

varAB = 0;
for i = 1:cols
    for j = 1:lines
        varAB = varAB + (((reflectanceCube.DataCube(i, j, bandA) * 4095) - Ua) * ((reflectanceCube.DataCube(i, j, bandB) * 4095) - Ub)) ;
    end
end

covAB = sqrt(varAB);

CC = varAB / (covA * covB)
