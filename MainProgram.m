clc;

%% This is the main program for hyperspectral image classification.
%
% Author: Dhanushka
%

%% Program execution guide.

% Depending on the application needs, the necesary parts of the program
% should be executed using "Run Section" command in the main toolbar.

%% Add necessary folders to path

    addpath HelperFunctions ClassificationMethods BandSelectionMethods 
    addpath AdditionalMatlabScripts HsiToRgb ImageQualityMatrices

%% Parameters

% Camera model: Specim IQ
% Simultaneous capture and 

    number_of_classes = 16;          % How many classes in the image
    samples_per_class = 1;          % How many training samples per class
    
    read_coords_from_file = false;  % True: Read training sample coordinates from file.
                                    % False: Capture manually.

    
%% Get HSI images into workspace and perform calculate relative reflectance.

classifyingLargeDataSet = false;        % This is only applicable for classyfing full image folder contain more than 1 image.

ReadSpecimData();               % Reads all the files into workspace.


%% Save RGB images to image folder.


%% get training data for each class. This step need to be done class-by-class.

% Run the script directly from source.
CollectTrainingData();

% Save data using UtilityFunctions.m


%% Read all the training data MAT files into workspace.

trainingDataFolder = 'G:\3. Hyperspectral\5. Matlab HSI\3. TrainingData Mat Files\'; 
matFilesList = dir(trainingDataFolder);

for nFile = 1:length(matFilesList)
    if contains(matFilesList(nFile).name, '.mat')
        path = fullfile(trainingDataFolder, matFilesList(nFile).name);
        load (path);
    end
end


% Convert training data into 1-D array with n-samples.

TrainingPixelClassesTo1D();


%% Band selection methods

reduced_bands_count = 100;

% bSet = Min_Max_Pooling(training_Data', reduced_bands_count);
% 
% layer_ids = Mean_Pooling(training_Data', round(204 / reduced_bands_count));

bSetDd = DistanceDensityBandSelection(reflectanceCube.DataCube, 4, 50);

%% Training
height = 1;
width = bands;
channels = 1;

% Get neural network
convnet_2_network();

deep_net = trainNetwork(trainingDataCnn, trainingLabelCnn, convnet_2, opts);


%% Prediction
% call HSI_Cnn_1D_Dataset.m file. This should run section by section.



%% Display classification
% Classificationn method.

% Spectral Angle Mapper
resultVec = SamClassification(reflectanceCube.DataCube);

classifiedImage = DisplayClassificationResult(resultVec, cols, lines);

figure();
imshow(classifiedImage)

%% Classification  accuracy

Classification_Accuracy();

