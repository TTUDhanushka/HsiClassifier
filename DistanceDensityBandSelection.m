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
    
    
%% Select bands

newCube = zeros(cube_h, cube_w, bands);
max_accuracy = 19;

for iterations = 1:500

%     for ptn = 1: nd(1, 1)
        partition_1 = randi([1, 50], 1, nd(1, 1));
        partition_1 = sort(partition_1);
        
%     end

%     for ptn = 1: nd(1, 2)
        partition_2 = randi([51, 100], 1, nd(1, 2));
        partition_2 = sort(partition_2);
%     end

%     for ptn = 1: nd(1, 3)
        partition_3 = randi([101, 150], 1, nd(1, 3));
        partition_3 = sort(partition_3);
%     end

%     for ptn = 1: nd(1, 4)
        partition_4 = randi([151, 204], 1, nd(1, 4));
        partition_4 = sort(partition_4);
%     end


    % Select bands
    bandIds = [partition_1, partition_2, partition_3, partition_4];


    for cnt = 1: 204
        for id = 1: reqBands - 1
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

%     figure()
%     imshow(classifiedImage)

    Classification_Accuracy();

    if (max_accuracy < accuracy)
        max_accuracy = accuracy;
        finalBands = bandIds;
    end

end
