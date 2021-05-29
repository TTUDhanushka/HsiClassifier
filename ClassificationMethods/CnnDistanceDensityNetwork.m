%% 1D CNN for distance density classification.

function [neuralNet, opts] = CnnDistanceDensityNetwork(height, width, channels)

    InputLayer = imageInputLayer([height,width,channels]); 

    % Distance density method uses [3, 1] or [5 1]convolutions.
    c2 = convolution2dLayer([1 3], 32, 'stride', [1 1]); %Filter window size = [1 5], No of filters = 16, stride = [1 5].

    % We use a max pooling layer as Downsampling layer. An alternative might be
    % to use an average pooling layer e.g. AveragePooling2dLayer or a reluLayer

    r1 = reluLayer();

    % Pooling layer should be [2 1] or [3 1]
    p3 = maxPooling2dLayer([1 3],'stride',[1 2]); %PoolSize = [1 20], Stride = [1 20]

    c4 = convolution2dLayer([1 3], 32, 'stride', [1 1]); %Filter window size = [1 5], No of filters = 16, stride = [1 10].

    % r2 = reluLayer();
    p5 = maxPooling2dLayer([1 3],'stride',[1 2]); %PoolSize = [1 20], Stride = [1 20]

    c6 = convolution2dLayer([1 3], 32, 'stride', [1 1]); %Filter window size = [1 5], No of filters = 16, stride = [1 10].

    % r2 = reluLayer();
    p7 = maxPooling2dLayer([1 3],'stride',[1 2]); %PoolSize = [1 20], Stride = [1 20]

    c8 = convolution2dLayer([1 3], 32, 'stride', [1 1]); %Filter window size = [1 5], No of filters = 16, stride = [1 10].

    % r2 = reluLayer();
    p9 = maxPooling2dLayer([1 3],'stride',[1 1]); %PoolSize = [1 20], Stride = [1 20]

    f10 = fullyConnectedLayer(16); % No of output classes
    s11 = softmaxLayer();

    outputLayer = classificationLayer();

    neuralNet = [InputLayer; c2; r1; p3; c4; p5; c6; p7; c8; p9; f10; s11; outputLayer];
    % opts = trainingOptions('sgdm'); %Optimise using stochastic gradient descent with momentum

    % Training options to increase epochs
    opts = trainingOptions('sgdm', ...
        'LearnRateSchedule', 'piecewise',...%         'MaxEpochs', 25,...
        'Plots','training-progress',...
        'ExecutionEnvironment','gpu'); %Optimise using stochastic gradient descent with momentum

end