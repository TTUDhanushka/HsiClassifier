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


%% Parameters

% Camera model: Specim IQ
% Simultaneous capture and 

    number_of_classes = 5;          % How many classes in the image
    samples_per_class = 1;          % How many training samples per class
    
    read_coords_from_file = false;  % True: Read training sample coordinates from file.
                                    % False: Capture manually.

    
%% Collect HSI datacubes

ReadSpecimData();               % Reads all the files into workspace.

BuildTrainingDataset();         % Collect training data and labels for CNN.