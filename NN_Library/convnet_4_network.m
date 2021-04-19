%% 1D CNN

InputLayer = imageInputLayer([height,width,channels]); %'DataAugmentation', 'none'); %'Normalization', 'none');
c1 = convolution2dLayer([1 5], 32, 'stride', [1 5]); %Filter window size = [1 5], No of filters = 16, stride = [1 10].

% We use a max pooling layer as Downsampling layer. An alternative might be
% to use an average pooling layer e.g. AveragePooling2dLayer or a reluLayer
r1 = reluLayer();
p1 = maxPooling2dLayer([1 3],'stride',[1 3]); %PoolSize = [1 20], Stride = [1 20]

c2 = convolution2dLayer([1 3], 16, 'stride', [1 2]);

f1 = fullyConnectedLayer(5); %Reduce to three output classes
s1 = softmaxLayer();
outputLayer=classificationLayer();

convnet_4 = [InputLayer; c1; r1; p1; c2; f1; s1; outputLayer]
% opts = trainingOptions('sgdm'); %Optimise using stochastic gradient descent with momentum

% Training options to increase epochs
opts = trainingOptions('sgdm', ...
    'LearnRateSchedule', 'piecewise',...
    'MaxEpochs', 20,...
    'Plots','training-progress',...
    'ExecutionEnvironment','gpu'); %Optimise using stochastic gradient descent with momentum