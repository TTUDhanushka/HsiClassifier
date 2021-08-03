% U-Net 

% Set parameters
mode = 'RGB';           % RGB or HSI_RGB

switch (mode)
    case 'RGB'
        imageSize = [648, 648, 3];
        dataDir = 'RGB_625_625';
        
    case 'HSI_RGB'
        imageSize = [512, 512, 3];
        dataDir = 'HSI_RGB';
end

%% Data

% Dataset directory
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

clear nDir datasetRoot dataDirPath;

if (~(imageDir == "") && ~(labelDir == ""))
    imds = imageDatastore(imageDir);
end

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


% Split the datastore
[imdsTrain, imdsVal, imdsTest, pxdsTrain, pxdsVal, pxdsTest] = splitDataset(imds, pxds, classes, labelIDs);

numTrainingImages = numel(imdsTrain.Files);
numValImages = numel(imdsVal.Files);
numTestingImages = numel(imdsTest.Files);

% Define validation data.
pximdsVal = pixelLabelImageDatastore(imdsVal,pxdsVal);

augmenter = imageDataAugmenter('RandXReflection',true,...
    'RandXTranslation',[-10 10],'RandYTranslation',[-10 10]);

% Define training data
pximds = pixelLabelImageDatastore(imdsTrain, pxdsTrain, 'DataAugmentation',augmenter);


%%

encoderDepth = 3;

lgraph = unetLayers(imageSize, noOfClasses, 'EncoderDepth', encoderDepth);

options = trainingOptions('sgdm','InitialLearnRate',1e-3, ...
        'ValidationData',pximdsVal,...
        'MiniBatchSize',4, ...
        'MaxEpochs',20,'VerboseFrequency',10);
    
net = trainNetwork(pximds, lgraph, options);


%% Test

I = readimage(imdsTest,3);
C = semanticseg(I, net);

B = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.4);
imshow(B)
pixelLabelColorbar(cmap, classes);
    