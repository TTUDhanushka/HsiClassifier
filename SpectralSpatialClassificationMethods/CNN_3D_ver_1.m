%%  3D CNN

% This script is based on "Spectral-spatial classification of hyperspectral
% imagery with 3D convolutional neural network" by Li, Ying et al.. the
% article was  published in MDPI "http://www.mdpi.com/2072-4292/9/1/67"

%% Read the dataset

mode = 'HSI_9';           % No of channels, by default this should be HSI_9

switch (mode)
    case 'HSI_9'
        imageSize = [512, 512, 9, 1];
        dataDir = 'HSI_9_Bands';
        
    case 'HSI_16'
        imageSize = [512, 512, 16, 1];
        dataDir = 'HSI_16_Bands';
        
    case 'RGB'
        imageSize = [645, 645, 3];
        dataDir = 'RGB_625_625';
end

datasetRoot = uigetdir();

imageDir = '';
labelDir = '';

dirList = dir(datasetRoot);

for nDir = 1: length(dirList)
    if (contains(dirList(nDir).name, dataDir))
        dataDirPath = fullfile(datasetRoot, dirList(nDir).name);
        imageDir = fullfile(dataDirPath,'images'); 
        labelDir = fullfile(dataDirPath,'labels');
    end
end

%%
% Get the files list

imageList = dir(imageDir);

for nFile = 1:10
    
    if contains(imageList(nFile).name, '.dat')
        fileName = imageList(nFile).name;
    end
end

switch (mode)
    case 'HSI_9'
        hsds = imageDatastore(imageDir, 'FileExtensions', '.dat', 'ReadFcn', @hsiReader); % _v2

    case 'RGB'
        hsds = imageDatastore(imageDir);
end
%% Dataset with labels and images

% Labels
classes = [
            "undefined"
            "grass"
            "concrete"
            "asphalt"
            "trees"
            "rocks"
            "water"
            "sky"
            "gravel"
            "objects"
            "dirt"
            "mud"
    ];

noOfClasses = length(classes);

cmap = zeros(noOfClasses, 3);

for nColor = 1:noOfClasses
    cmap(nColor, :) = Get_Label_Color(nColor);
end


% Convert labels to cell array.
labelIDs = {};

for n = 1:length(cmap)
    
    labelIDs = [labelIDs; {[cmap(n, 1) cmap(n, 2) cmap(n, 3)]}];
    
end

clear n nColor dirList;

cmap = cmap ./ 255;

pxds = pixelLabelDatastore(labelDir, classes, labelIDs);

%% Split dataset
switch (mode)
    case 'HSI_9'
        % Split the datastore
        [hsdsTrain, hsdsVal, hsdsTest, pxdsTrain, pxdsVal, pxdsTest] = splitHsiDataset(hsds, pxds, classes, labelIDs);
        
    case 'RGB'
        % Split the datastore
        [hsdsTrain, hsdsVal, hsdsTest, pxdsTrain, pxdsVal, pxdsTest] = splitDataset(hsds, pxds, classes, labelIDs);
end


numTrainingImages = numel(hsdsTrain.Files);
numValImages = numel(hsdsVal.Files);
numTestingImages = numel(hsdsTest.Files);

% Define validation data.
pximdsVal = pixelLabelImageDatastore(hsdsVal, pxdsVal); %, 'ReadFcn', hsiLabelReader_v2);

pximds = pixelLabelImageDatastore(hsdsTrain, pxdsTrain);

%% Network design
networkLayers = layers_5;

options = trainingOptions('sgdm','InitialLearnRate',1e-3, ... 
        'ValidationData',pximdsVal,...      
        'MiniBatchSize',4, ...
        'MaxEpochs',20, ...
        'Plots','training-progress', ...
        'VerboseFrequency',10);
    
networkHSI = trainNetwork(pximds, networkLayers, options);

% Performance matrices

% Results for the thesis