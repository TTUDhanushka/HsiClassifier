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

%% Training dataset preperation

selectedBands = d;
classes = 17;

ssKernelSz = 5;  % forming a 3 x 3 image with 200 channels

kernelSz = 16;  % to pick up trainng pixels

kernelPxPerClass = kernelSz - (ssKernelSz - 1);
totalTrainingPxPerClass = (kernelPxPerClass * kernelPxPerClass);

trainingData = zeros(ssKernelSz, ssKernelSz, selectedBands, totalTrainingPxPerClass * classes);


% Top left coordinates of each pixel class.
trainingPixelTpL = [[9, 2]; [70, 99]; [20, 7]; [1, 1]; [36, 9 ]; [83, 12];...
                    [68, 33]; [74, 110]; [46, 126]; [66, 23]; [13, 31];...
                    [12, 103]; [19, 69]; [121, 44]; [129, 120]; [9, 93]; [17, 50]];
    
for nClass = 1:classes
    for kernelX = 1:kernelPxPerClass
       for kernelY = 1:kernelPxPerClass
            for ndx = 1:ssKernelSz
                for ndy = 1:ssKernelSz
                    trainingData(ndx, ndy, :, (totalTrainingPxPerClass * (nClass - 1)) + ((kernelX - 1) * kernelPxPerClass) + kernelY) ...
                        = indian_pines_corrected((trainingPixelTpL(nClass,1) + kernelX - 1) + ndx, ...
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
                = indian_pines_gt((trainingPixelTpL(nClass,1) + kernelX - 1) + 3, ...
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

deep_net = trainNetwork(augData, augLabelsCat, layers_3, opts);


%% Predict

CNN_TestPixels = zeros(5, 5, 200);

for i = 1:5
    for j = 1:5
        CNN_TestPixels(i, j, :) = indian_pines_corrected(i + 6, j + 12, : );
    end
end

predictY = predict(deep_net, CNN_TestPixels)
