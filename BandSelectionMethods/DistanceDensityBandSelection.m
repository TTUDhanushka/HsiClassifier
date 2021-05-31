function [selectedBands, max_accuracy] = DistanceDensityBandSelection(hsiData1D, labels1D, partitions, bandsPerPartition, reqBands)

%   Distance density method based on IEEE article "Hyperspectral Band 
%   Selection Based on Deep Convolutional Neural Network and Distance 
%   Density".
%

%   Notes: The spectral data need to be read before running this script.
%   For example, ReadSpecimData script can get necessary data into
%   workspace.


%% Distance density input parameters.
    % Inputs
    %    partitions = 4;                                     % Number of partitions, p.
    %    bandsPerPartition = 50;                             % Original number of bands per partition.

    totalDdBands = partitions * bandsPerPartition;      % Total number of bands
    
    %% Calculate distance density
    
    noOfTestData = length(hsiData1D);
       
    selectedBands = zeros(1, reqBands);
    
    dd = zeros(1, partitions);                                      % Distance densities.

    % Notes: This method seems taking one class at a time. However, their
    % article results can't be reproduced.
    
    for cnt_X = 1: noOfTestData
        
        radiance = zeros(1, totalDdBands);                          % Radiance of band.
        
        for i = 1: totalDdBands
            radiance(1, i) = hsiData1D(1, i, 1, cnt_X);
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
    end
    
    
    %% Bands list
    
    totalDistanceDensities = sum(dd);
    nd = zeros(1, partitions);
  
    
    for l = 1:partitions
        nd(1, l) =  round((dd(1, l) / totalDistanceDensities) * reqBands);        
    end
    
    
    %% Select bands
    
    max_accuracy = 5;                  % Minimum 5% accuracy
    
    selectedIds = [];
    
    for iterations = 1:500
        
        bandIds = [];
        
        for ptn = 1: length(nd)
            selectedIds = randperm(bandsPerPartition, nd(1, ptn)) + bandsPerPartition * (ptn - 1);
            selectedIds = sort(selectedIds);
            
            bandIds = [bandIds, selectedIds];
            
        end
        
        % Create memory for the test dataset
        [h,w,c,s] = size(hsiData1D);
        DD_TestPixels = zeros(h, w, c, s);
        

        for bandIdx = 1:length(bandIds)
            DD_TestPixels(1, bandIds(bandIdx), 1, :) = hsiData1D(1, bandIds(bandIdx), 1, :);
        end

        network = evalin('base', 'distance_dens_net'); 
        predictY = predict(network, DD_TestPixels);
        
        correct = 0;
        
        for n = 1: length(predictY)
            [a, c] = max(predictY(n, :));
            
            if(c == double(string(labels1D(n))))
                correct = correct + 1;
            end
        end

        accuracy = (correct / length(predictY)) * 100
        

        
        if (max_accuracy < accuracy)
            max_accuracy = accuracy;
            selectedBands = bandIds;
        end
        
    end

end
