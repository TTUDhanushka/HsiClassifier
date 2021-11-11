% Spectral-spatial CNN for remote sensing image classification.
%
% Note:
% Indian pines dataset is in a different folder. Add the folder to the
% MATLAB path

%% Options

load 'Indian_pines_corrected.mat';
load 'indian_pines_gt.mat';



%%
% View a slice of the image
[w, h, d] = size(indian_pines_corrected);

slice = zeros(w, h, 'uint8');

bandId = 10;

for idx = 1: w
    for idy = 1:h
        slice(idx, idy) = uint8(indian_pines_corrected(idx, idy, bandId) / 16);
    end
end

figure()
imshow(slice);

%% Bands reduction

% bandsList = [9, 23, 48, 67, 90, 111, 133, 155, 177];
% bandsList = indian_16_bands_list;
bandsList = indian_25_bands_list;

indianBandsReduced = ReducedBandImage(indian_pines_corrected, bandsList);

%% Training dataset preperation

selectedBands = 25;  % d or 9, 16, 25
classes = 10;       % 17

ssKernelSz = 5;  % forming a 3 x 3 image with 200 channels

kernelSz = 12;  % to pick up trainng pixels

kernelPxPerClass = kernelSz - (ssKernelSz - 1);
totalTrainingPxPerClass = (kernelPxPerClass * kernelPxPerClass);

trainingData = zeros(ssKernelSz, ssKernelSz, selectedBands, totalTrainingPxPerClass * classes);


% Top left coordinates of each pixel class.
trainingPixelTpL = [[95, 1]; [31, 37]; [60, 4]; [74, 2]; [99, 58];...   % 0 - 4
                    [39, 122]; [40, 79]; [79, 56]; [13, 56]; [118, 102]];
    
%                 trainingPixelTpL = [[9, 2]; [70, 99]; [20, 7]; [1, 1]; [36, 9 ]; [83, 12];...
%                     [68, 33]; [74, 110]; [46, 126]; [66, 23]; [13, 31];...
%                     [12, 103]; [19, 69]; [121, 44]; [129, 120]; [9, 93]; [17, 50]];
                
for nClass = 1:classes
    for kernelX = 1:kernelPxPerClass
       for kernelY = 1:kernelPxPerClass
            for ndx = 1:ssKernelSz
                for ndy = 1:ssKernelSz
                    trainingData(ndx, ndy, :, (totalTrainingPxPerClass * (nClass - 1)) + ((kernelX - 1) * kernelPxPerClass) + kernelY) ...
                        = indianBandsReduced((trainingPixelTpL(nClass,1) + kernelX - 1) + ndx, ...
                        (trainingPixelTpL(nClass, 2) + kernelY - 1) + ndy, :);
                end
            end
       end
    end   
end    

% Labels of the image
trainingLabels = zeros(1, totalTrainingPxPerClass * classes);

for nClass = 1:classes
    for kernelX = 1:kernelPxPerClass
        for kernelY = 1:kernelPxPerClass
            trainingLabels(1, (totalTrainingPxPerClass * (nClass - 1)) + ((kernelX - 1) * kernelPxPerClass) + kernelY) ...
                = indian_pines_gt_few_classes((trainingPixelTpL(nClass,1) + kernelX - 1) + 3, ...
                (trainingPixelTpL(nClass, 2) + kernelY - 1) + 3, :);           
        end
    end
end

% Augment training data
indices = randperm(totalTrainingPxPerClass * classes);

augData = zeros(ssKernelSz, ssKernelSz, selectedBands, totalTrainingPxPerClass * classes);
augLabels = zeros(1, totalTrainingPxPerClass * classes);

for nPerm = 1: length(indices)
   augData(:,:,:, indices(1, nPerm)) = trainingData(:,:,:, nPerm);
   augLabels(1, indices(1, nPerm)) = trainingLabels(1, nPerm);
end

augLabelsCat = categorical(augLabels);

%% CNN model


% Training options to increase epochs
opts = trainingOptions('adam', ...
    'MaxEpochs', 25,...
    'InitialLearnRate', 1e-3, ...
    'Plots','training-progress',...
    'Shuffle', 'every-epoch', ...
    'ExecutionEnvironment','gpu'); %Optimise using stochastic gradient descent with momentum

%  deep_net = trainNetwork(augData, augLabelsCat, NN_10_bands, opts);

% deep_net_16 = trainNetwork(augData, augLabelsCat, NN_16_bands, opts);

deep_net_25 = trainNetwork(augData, augLabelsCat, NN_25_bands, opts);
%% Predict

CNN_TestPixels = zeros(5, 5, selectedBands);

resultIndianPines = zeros(w, h, 'uint8');
resultIndianPines_vis = zeros(w, h, 3, 'uint8');

for kx = 1: w - 4
    for ky = 1:h - 4
        
        for i = 1:5
            for j = 1:5
                CNN_TestPixels(i, j, :) = indianBandsReduced((kx - 1) + i, (ky - 1) + j, : );
            end
        end
        
        predictY = predict(deep_net_25, CNN_TestPixels);
        [val, id] = max(predictY);
        resultIndianPines(kx + 2, ky + 2) = id - 1;
    end
end

for i = 1:w
    for j = 1:h
        colorIdx = resultIndianPines(i, j) + 1;
        resultIndianPines_vis(i, j, :) = revisedColorMap(colorIdx, :);
    end
end

%%
figure()
imshow(resultIndianPines_vis);

%% Overall accuracy

totalPixels = w * h;

correctPx = 0;
incorrect = 0;


for rx = 3:w-2
    for ry = 3: h-2
        if ~(indian_pines_gt_few_classes(rx, ry) == 0)
            if indian_pines_gt_few_classes(rx, ry) == resultIndianPines(rx, ry)
                correctPx = correctPx + 1;
            else
                incorrect = incorrect + 1;
            end
        end
    end
end

% background pixels
classPx = 0;

for rx = 3:w-2
    for ry = 3: h-2
        if ~(indian_pines_gt_few_classes(rx, ry) == 0)
            classPx = classPx + 1;
        end
    end
end

accuracy = (correctPx / classPx) * 100;

%% Class-wise accuracy

classResult = zeros(classes, 1);
classPixels = zeros(classes, 1);

for nClass = 1: classes - 1
    for rx = 3:w-2
        for ry = 3: h-2
            if (indian_pines_gt_few_classes(rx, ry) == nClass)
                
                classPixels(nClass, 1) = classPixels(nClass, 1) + 1;
                
                if indian_pines_gt_few_classes(rx, ry) == resultIndianPines(rx, ry)
                    classResult(nClass, 1) = classResult(nClass, 1) + 1;

                end
            end
        end
    end
end

px = (classResult ./ classPixels) * 100