function [network, options] = Cnn1D16bands(height, width, channels)

    % 1D CNN for 16 bands spectral data in 16 classes.

    InputLayer = imageInputLayer([height,width,channels]); 

    c1 = convolution2dLayer([1 2], 16, 'stride', [1 1]); %Filter window size = [1 5], No of filters = 16, stride = [1 5].

    % We use a max pooling layer as Downsampling layer. An alternative might be
    % to use an average pooling layer e.g. AveragePooling2dLayer or a reluLayer

    r1 = reluLayer();

    c2 = convolution2dLayer([1 2], 16, 'stride', [1 1]); %Filter window size = [1 5], No of filters = 16, stride = [1 10].
    
    r2 = reluLayer();

    c3 = convolution2dLayer([1 2], 16, 'stride', [1 1]); %Filter window size = [1 5], No of filters = 16, stride = [1 10].
    
    f1 = fullyConnectedLayer(13); % No of output classes
    
    s1 = softmaxLayer();
    outputLayer = classificationLayer();

    network = [InputLayer; c1; r1; c2; r2; c3; f1; s1; outputLayer];
    % opts = trainingOptions('sgdm'); %Optimise using stochastic gradient descent with momentum

    % Training options to increase epochs
    options = trainingOptions('sgdm', ...
        'LearnRateSchedule', 'piecewise',...
        'MaxEpochs', 25,...
        'Plots','training-progress',...
        'ExecutionEnvironment','gpu'); %Optimise using stochastic gradient descent with momentum

end