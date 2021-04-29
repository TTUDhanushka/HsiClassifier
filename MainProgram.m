clc;

%% This is the main program for hyperspectral image classification.
%
% Author: Dhanushka
%

%% Program execution guide.

% Depending on the application needs, the necesary parts of the program
% should be executed using "Run Section" command in the main toolbar.

%% Add necessary folders to path

    addpath HelperFunctions
    addpath NN_Library

%% Parameters

% Camera model: Specim IQ
% Simultaneous capture and 

    number_of_classes = 5;          % How many classes in the image
    samples_per_class = 1;          % How many training samples per class
    
    read_coords_from_file = false;  % True: Read training sample coordinates from file.
                                    % False: Capture manually.

    
%% Get HSI images into workspace and perform calculate relative reflectance.

ReadSpecimData();               % Reads all the files into workspace.


%% get training data for each class. This step need to be done class-by-class.

CollectTrainingData();


%% Read all the training data MAT files into workspace.



%%

DatacubeTransformTo1D();


%% Training
height = 1;
width = bands;
channels = 1;

% Get neural network
convnet_2_network();

deep_net = trainNetwork(trainingDataCnn, trainingLabelCnn, convnet_2, opts);


%% Prediction
% call HSI_Cnn_1D_Dataset.m file. This should run section by section.

%% Classification  accuracy

Classification_Accuracy();

