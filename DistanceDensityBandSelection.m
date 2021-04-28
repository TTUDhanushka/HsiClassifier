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
    


    
%% Resize the datacube by removing some spectral bands.
cube_h = 145;
cube_w = 145;

DdCube = zeros(cube_h, cube_w, totalDdBands);
% DdCube(:,:,:) = correctd_hsi_cube(:,:,1:200);
DdCube(:,:,:) = indian_pines_corrected(:,:,1:200);

%% Calculate distance density

% Pixel position.
    selectedPxX = 1;
    selectedPxY = 1; 
    
    
    dd = zeros(1, partitions);                           % Distance densities.
    
% Notes: This method seems taking one class at a time. However, their
% article results can't be reproduced.

%     for cnt_X = 1: cube_h
%         for cnt_y = 1:cube_w
            
            radiance = zeros(1, totalDdBands);                          % Radiance of band.

            for i = 1: totalDdBands
                radiance(1, i) = DdCube(selectedPxX, selectedPxY, i);
            end

            distance_array = zeros(1, bandsPerPartition);                % Absolute distances.

            for k = 1:partitions
                
                absDistance = 0;
                curr_band = 0;
                
                for i = ((k - 1) * bandsPerPartition) + 1: (k * bandsPerPartition) - 1
                    curr_band = curr_band + 1;
                    distance_array(1, curr_band) = abs(radiance(1, i + 1) - radiance(1, i));
                    absDistance = absDistance + abs(radiance(1, i + 1) - radiance(1, i));
                end

                dd(1, k) = dd(1, k) + absDistance / bandsPerPartition;  

            end
%         end
%     end
    
%% Bands list

totalDistanceDensities = sum(dd);
nd = zeros(1, partitions);

reqBands = 40;

    for l = 1:partitions
        nd(1, l) =  round((dd(1, l) / totalDistanceDensities) * reqBands);
        
    end
    
    
%% Select bands

newCube = zeros(cube_h, cube_w, bands);
max_accuracy = 19;


selectedIds = [];

for iterations = 1:500
    
%     bandIds = [];
%     
%      for ptn = 1: length(nd)
%         selectedIds = randperm(bandsPerPartition, nd(1, ptn)) + bandsPerPartition * (ptn - 1);
%         selectedIds = sort(selectedIds);
%         
%         bandIds = [bandIds, selectedIds];
%         
%      end
    
    
    bandIds = finalBands;

    for cnt = 1: 204
        for id = 1: length(bandIds)
            if(cnt == bandIds(id))
                newCube(:, :, cnt) = reflectanceCube.DataCube(:,:, cnt);
            end
        end
    end


    % Unfold the datacube and get spectral data into rows
    reshapedData = zeros(data_d, data_h * data_w);

    for a = 1:data_h
        for b = 1:data_w
            reshapedData(:, ((a-1) * data_h) + b) = newCube(a, b, :);
        end
    end

    height = 1;
    width = bands;
    channels = 1;
    sampleSize = data_h * data_w;

    DD_TestPixels = reshape(reshapedData,[height, width, channels, sampleSize]);

    predictY = predict(deep_net, DD_TestPixels);

    usedClassList = [2 6 7 10 13];

    classifiedImage = zeros(data_h, data_w, 3, 'uint8');

    for n = 1: sampleSize
        [val, id] = max(predictY(n,:));

        row = fix(n/data_w) + 1;
        column = mod(n,data_w) + 1;
        classifiedImage(row, column, :) = Get_Label_Color(usedClassList(id));
    end

    figure()
    imshow(classifiedImage)

    Classification_Accuracy();

    if (max_accuracy < accuracy)
        max_accuracy = accuracy;
        finalBands = bandIds;
    end

end


%% plot the radiance for the first pixel

% This graph used for Indian Pines dataset which shows same plot in the paper.

figure()
plot(radiance(1, :))
hold on;

for kk = 1: partitions - 1
    line([(kk * bandsPerPartition) (kk * bandsPerPartition)], [0 7000], 'Color', [0.5, 0.5, 0.5])
end
hold off;

