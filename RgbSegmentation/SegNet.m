% SegNet image semantic segmentation

% Set parameters
mode = 'RGB';           % RGB or HSI_RGB

switch (mode)
    case 'RGB'
        imageSize = [645, 645];
        dataDir = 'RGB_625_625';
        
    case 'HSI_RGB'
        imageSize = [512, 512];
        dataDir = 'HSI_RGB';
end


%% Training

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

clear n nColor;

pxds = pixelLabelDatastore(labelDir, classes, labelIDs);

pximds = pixelLabelImageDatastore(imds,pxds);

%% Model
model = '';

lgraph = segnetLayers(imageSize, noOfClasses, 2);

options = trainingOptions('sgdm','InitialLearnRate',1e-3, ...
      'MaxEpochs',20,'VerboseFrequency',10);
  
net = trainNetwork(pximds,lgraph,options);


