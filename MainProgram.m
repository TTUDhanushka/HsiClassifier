clc;

%% This is the main program for hyperspectral image classification.
%
% Author: Dhanushka
%
%
% Program execution guide:
%
% Depending on the application needs, the necesary parts of the program
% should be executed using "Run Section" command in the main toolbar.

%% Add necessary folders to path

    addpath HelperFunctions SpectralClassificationMethods BandSelectionMethods SpectralSpatialClassificationMethods
    addpath AdditionalMatlabScripts HsiToRgb ImageQualityMatrices FilterMethods AccuracyMatrices hsiDocs

    
%% Get HSI images into workspace and perform calculate relative reflectance.

classifyingLargeDataSet = false;        % This is only applicable for classyfing full image folder contain more than 1 image.

ReadSpecimData();                       % Reads all the files into workspace.


%% get training data for each class. This step need to be done class-by-class.

% Keep the same format as [tree_cube_Ref, tree_labels]
[sm_cube_Ref, sm_labels] = CollectObjectClassData("person", reflectanceCube.DataCube);

[classCube, classLabels] = UpdateClassSampleCubes("person", sm_cube_Ref, sm_labels, false);

clear sm_cube_Ref sm_labels classCube classLabels;

% Save data using UtilityFunctions.m


%% Read all the training / testing data MAT files into workspace.

trainingDataFolder = 'G:\3. Hyperspectral\5. Matlab HSI\3. TrainingData Mat Files\'; 
matFilesList = dir(trainingDataFolder);

for nFile = 1:length(matFilesList)
    if contains(matFilesList(nFile).name, '.mat')
        path = fullfile(trainingDataFolder, matFilesList(nFile).name);
        load (path);
    end
end

clear trainingDataFolder nFile matFilesList path;
%% Convert training data into 1-D array with n-samples.

TrainingPixelClassesTo1D();


%% Band selection methods

reduced_bands_count = 9;

bSet = Min_Max_Pooling(training_Data', reduced_bands_count);

% layer_ids = Mean_Pooling(training_Data', round(204 / reduced_bands_count));

% % Distance density method needs first time full network training.
% height = 1;
% width = bands;
% channels = 1;
% 
% % Get neural network
% Cnn_Distance_Density();
% 
% distance_dens_net = trainNetwork(trainingDataCnn, trainingLabelCnn, cnn_distance_density, opts);


%%

[bSetDd, acc] = DistanceDensityBandSelection(testDataCnn, testLabelCnn, 4, 50, 9)

%% Training
height = 1;
width = reduced_bands_count;
channels = 1;

% Get neural network
% [cnn_distance_density, opts] = CnnDistanceDensityNetwork(height, width, channels);
[network, options] = Cnn1D16bands(height, width, channels);

reducedBandData = GetReducedBandData1D(training_Data_Aug, bSet);

trainingDataSet = reshape(reducedBandData,[1, width, 1, length(training_Data_Aug)]);

trainedNet = trainNetwork(trainingDataSet, trainingLabelCnn, network, options);


%% Prediction

method = 'svm';

switch (method)
    case 'svm'
        SVM_Classifier();
        
        
    case 'cnn'
        
        % Transform data into CNN usable format
        rotatedCube = RotateHsiImage(reflectanceCube.DataCube, -90);
        
        % Band reduction
        reducedCube = ReducedBandImage(rotatedCube, bSet);
        
        [data_h, data_w, data_d] = size(reducedCube);
        inputData = UnfoldHsiCube(reducedCube);
        
        height = 1;
        width = data_d;
        channels = 1;
        sampleSize = data_h * data_w;
        
        CNN_TestPixels = reshape(inputData,[height, width, channels, sampleSize]);
        
        predictY = predict(trainedNet, CNN_TestPixels);
        
    case 'sam'
        % Spectral Angle Mapper
        predictY = SamClassification(reflectanceCube.DataCube);
end


%% Display classification

classifiedImage = DisplayClassificationResult(predictY, cols, lines);

figure();
imshow(imageResult)


%% Performance Matrices - Accuracy

accuracy = ClassificationAccuracy(groundTruthImage, imageResult ) % imageResult

