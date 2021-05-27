%% 1D CNN for 25 bands spectral data in 16 classes.

InputLayer = imageInputLayer([height,width,channels]); 

c1 = convolution2dLayer([1 5], 16, 'stride', [1 5]); %Filter window size = [1 65], No of filters = 16, stride = [1 5].

% We use a max pooling layer as Downsampling layer. An alternative might be
% to use an average pooling layer e.g. AveragePooling2dLayer or a reluLayer

r1 = reluLayer();
p1 = maxPooling2dLayer([1 3],'stride',[1 3]); %PoolSize = [1 20], Stride = [1 20]

c2 = convolution2dLayer([1 5], 64, 'stride', [1 5]); %Filter window size = [1 5], No of filters = 16, stride = [1 10].
r2 = reluLayer();
p2 = maxPooling2dLayer([1 2],'stride',[1 2]); %PoolSize = [1 20], Stride = [1 20]

f1 = fullyConnectedLayer(16); % No of output classes
s1 = softmaxLayer();
outputLayer = classificationLayer();

convnet_2 = [InputLayer; c1; r1; p1; c2; r2; p2; f1; s1; outputLayer]
% opts = trainingOptions('sgdm'); %Optimise using stochastic gradient descent with momentum

% Training options to increase epochs
opts = trainingOptions('sgdm', ...
    'LearnRateSchedule', 'piecewise',...
    'MaxEpochs', 25,...
    'Plots','training-progress',...
    'ExecutionEnvironment','gpu'); %Optimise using stochastic gradient descent with momentum