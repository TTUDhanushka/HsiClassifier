%% CNN for spectral classification


%% Transform data into CNN usable format
rotatedCube = RotateHsiImage(reflectanceCube.DataCube, -90);

[data_h, data_w, data_d] = size(rotatedCube);
inputData = UnfoldHsiCube(rotatedCube);

height = 1;
width = data_d;
channels = 1;
sampleSize = data_h * data_w;

CNN_TestPixels = reshape(inputData,[height, width, channels, sampleSize]);


%% Call NN and perform the test

% predictY = predict(deep_net, CNN_TestPixels);

predictY = predict(distance_dens_net, CNN_TestPixels);

%% Create result classification

classifiedImage = DisplayClassificationResult(predictY, data_h, data_w);

figure()
imshow(classifiedImage)


% Rotated ground truth
% rot_groundTruth = imrotate(groundTruth, -90);

%% Perform accuracy / precision test