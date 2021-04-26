%
%   Distance density method based on IEEE article "Hyperspectral Band 
%   Selection Based on Deep Convolutional Neural Network and Distance 
%   Density".
%

%   Notes: The spectral data need to be read before running this script.
%   For example, ReadSpecimData script can get necessary data into
%   workspace.

%% Distance density input parameters.

% Inputs
    partitions = 4;                                     % Number of partitions, p.
    bandsPerPartition = 50;                             % Original number of bands per partition.
 
    totalDdBands = partitions * bandsPerPartition;      % Total number of bands
    
    radiance = zeros(1,totalDdBands);                   % Radiance of band.

    
%% Resize the datacube by removing some spectral bands.

DdCube = zeros(cube_h, cube_w, totalDdBands);
DdCube(:,:,:) = correctd_hsi_cube(:,:,1:200);


%% Calculate distance density

% Pixel position.
    selectedPxX = 10;
    selectedPxY = 10;      
    
    for i = 1: totalDdBands
        radiance(1, i) = DdCube(selectedPxX,     selectedPxY, i);
    end
    
    distance_array = zeros(1, bandsPerPartition);                % Absolute distances.
    dd = zeros(1, partitions);                      % Distance densities.
    absDistance = 0;
    
    for k = 1:partitions
        curr_band = 0;
        for i = ((k - 1) * bandsPerPartition) + 1: (k * bandsPerPartition) - 1
            curr_band = curr_band + 1;
            distance_array(1, curr_band) = abs(radiance(1, i + 1) - radiance(1, i));
            absDistance = absDistance + abs(radiance(1, i + 1) - radiance(1, i));
        end
        
        dd(1, k) = absDistance / bandsPerPartition;
        
    end
    
%% Bands list

totalDistanceDensities = sum(dd);
nd = zeros(1, partitions);

reqBands = 25;

    for l = 1:partitions
        nd(1, l) =  round((dd(1, l) / totalDistanceDensities) * reqBands);
        
    end