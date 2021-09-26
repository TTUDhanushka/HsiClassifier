% Experiment with different image datastore creation methods for
% hyperspectral images.

mode = 'HSI_9';           % RGB or HSI_RGB

switch (mode)
    case 'HSI_9'
        imageSize = [512, 512, 9];
        dataDir = 'HSI_9_Bands';
        
    case 'HSI_16'
        imageSize = [512, 512, 16];
        dataDir = 'HSI_16_Bands';
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

hsds = imageDatastore(imageDir, 'FileExtensions', '.dat', 'ReadFcn', @hsiReader);

%%
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

%%
% Split the datastore
[hsdsTrain, hsdsVal, hsdsTest, pxdsTrain, pxdsVal, pxdsTest] = splitHsiDataset(hsds, pxds, classes, labelIDs);

numTrainingImages = numel(hsdsTrain.Files);
numValImages = numel(hsdsVal.Files);
numTestingImages = numel(hsdsTest.Files);

% Define validation data.
pximdsVal = pixelLabelImageDatastore(hsdsVal,pxdsVal);

augmenter = imageDataAugmenter('RandXReflection',true,...
    'RandXTranslation',[-10 10],'RandYTranslation',[-10 10]);

%% Define training data
pximds = pixelLabelImageDatastore(hsds, pxds, 'DataAugmentation', augmenter);

encoderDepth = 3;

lgraph = unetLayers(imageSize, noOfClasses, 'EncoderDepth', encoderDepth);

options = trainingOptions('sgdm','InitialLearnRate',1e-3, ... 
        'ValidationData',pximdsVal,...      
        'MiniBatchSize',4, ...
        'MaxEpochs',20, ...
        'Plots','training-progress', ...
        'VerboseFrequency',10);
    
net = trainNetwork(pximds, lgraph, options);

%% Test

I = readimage(hsdsTest, 1);
C = semanticseg(I, net);

rgb_Out = ConstructRgbImage(I, 1, 3, 4);

B = labeloverlay(rgb_Out,C,'Colormap',cmap,'Transparency',0.4);
imshow(B)
pixelLabelColorbar(cmap, classes);
    