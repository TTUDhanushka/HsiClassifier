% Indian_Pines training data

bands = 200;
samples = 4;

kernelSz = 16;

maskPx = zeros(bands, samples);
maskLbl = zeros(1, samples);

% Top left coordinates of each pixel class.
trainingPixelTpL = [[9, 2]; [70, 99]; [20, 7]; [1, 1]; [36, 9 ]; [83, 12];...
                    [68, 33]; [74, 110]; [46, 126]; [66, 23]; [13, 31];...
                    [12, 103]; [19, 69]; [121, 44]; [129, 120]; [9, 93]; [17, 50]];
                
% trainingPixIndianPines = zeros(bands, length(trainingPixelTpL) * samples);                
% trainingLabelsIndianPines = zeros(1, length(trainingPixelTpL) * samples);
trainingPixIndianPines = [];
trainingLabelsIndianPines = [];

for class = 1:length(trainingPixelTpL)
    
    for x = 1:kernelSz
        for y = 1:kernelSz
            maskPx(:, (((x - 1) * kernelSz) + y)) = indian_pines_corrected(trainingPixelTpL(class, 1) + x, trainingPixelTpL(class, 2) + y, :);
            maskLbl(1, (((x - 1) * kernelSz) + y)) = indian_pines_gt(trainingPixelTpL(class, 1) + x, trainingPixelTpL(class, 2) + y, :);
        end
    end
    trainingPixIndianPines = cat(2, trainingPixIndianPines,  maskPx);
    trainingLabelsIndianPines = cat(2, trainingLabelsIndianPines, maskLbl);
    
end

%% Same CNN as in the paper

% 1D CNN

InputLayer = imageInputLayer([height,width,channels]); %'DataAugmentation', 'none'); %'Normalization', 'none');
c1 = convolution2dLayer([1 3], 32, 'stride', [1 3]); %Filter window size = [1 6], No of filters = 16, stride = [1 6].

% We use a max pooling layer as Downsampling layer. An alternative might be
% to use an average pooling layer e.g. AveragePooling2dLayer or a reluLayer
r1 = reluLayer();
p1 = maxPooling2dLayer([1 3],'stride',[1 3]); %PoolSize = [1 20], Stride = [1 20]

c2 = convolution2dLayer([1 3], 32, 'stride', [1 3]); %Filter window size = [1 5], No of filters = 16, stride = [1 10].
r2 = reluLayer();
p2 = maxPooling2dLayer([1 3],'stride',[1 3]); %PoolSize = [1 20], Stride = [1 20]

c3 = convolution2dLayer([1 3], 32, 'stride', [1 3]); %Filter window size = [1 5], No of filters = 16, stride = [1 10].
% r2 = reluLayer();
p3 = maxPooling2dLayer([1 3],'stride',[1 3]); %PoolSize = [1 20], Stride = [1 20]

f1 = fullyConnectedLayer(17); %Reduce to three output classes
s1 = softmaxLayer();
outputLayer=classificationLayer();

% convnet_BSCNN = [InputLayer; c1; r1; p1; c2; r2; p2; f1; s1; outputLayer]
convnet_BSCNN = [InputLayer; c1; p1; c2; p2; c3; p3; f1; s1; outputLayer]
% opts = trainingOptions('sgdm'); %Optimise using stochastic gradient descent with momentum

% Training options to increase epochs
opts = trainingOptions('sgdm', ...
    'LearnRateSchedule', 'piecewise',...
    'MaxEpochs', 25,...
    'Plots','training-progress',...
    'ExecutionEnvironment','gpu'); %Optimise using stochastic gradient descent with momentum

%% Convert for 1D format

height = 1;
width = bands;
channels = 1;
sampleSize = length(trainingLabelsIndianPines);
trainingPixIndianPines = normalize(trainingPixIndianPines);
trainingDataCnn = reshape(trainingPixIndianPines,[height, width, channels, sampleSize]);

trainingLabelCnn = categorical(trainingLabelsIndianPines);
             

deep_net = trainNetwork(trainingDataCnn, trainingLabelCnn, convnet_BSCNN, opts);
                

%% Prediction

inputData = zeros(bands, cube_h * cube_w);

for a = 1:cube_h
    for b = 1:cube_w
        inputData(:, ((a-1) * cube_h) + b) = indian_pines_corrected(a, b, :);
        %inputData(:, ((a-1) * data_w) + b) = correctd_hsi_cube(a, b, :);
    end
end


height = 1;
width = bands;
channels = 1;
sampleSize = cube_h * cube_w;

CNN_TestPixels = reshape(inputData,[height, width, channels, sampleSize]);

predictY = predict(deep_net, CNN_TestPixels);

%% Accuracy

 
classifiedImage = zeros(cube_h, cube_w, 3, 'uint8');

for n = 1: sampleSize
    [val, id] = max(predictY(n,:));
    
    row = fix(n/cube_w) + 1;
    column = mod(n,cube_w) + 1;
    classifiedImage(row, column, :) = Get_Label_Color(id);
end

figure()
imshow(classifiedImage)
