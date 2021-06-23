%% Semantic segmentation using resnet18.
% net = resnet18;

% Get dataset folder 
datasetFolder = uigetdir;

% Raw images folder which contain sliced images of 625 x 625 px
imgDir = fullfile(datasetFolder, 'images');
imds = imageDatastore(imgDir);

I = readimage(imds,1);
I = histeq(I);
imshow(I)

%% classes, labels

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
            "person"
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

cmap = cmap ./ 255;

clear nColor
  
%%
  
labelDir = fullfile(datasetFolder,'labels');
pxds = pixelLabelDatastore(labelDir,classes,labelIDs);


%%

C = readimage(pxds,1);

B = labeloverlay(I,C,'ColorMap',cmap);
imshow(B)
pixelLabelColorbar(cmap,classes);


tbl = countEachLabel(pxds)

frequency = tbl.PixelCount/sum(tbl.PixelCount);

bar(1:numel(classes),frequency)
xticks(1:numel(classes)) 
xticklabels(tbl.Name)
xtickangle(45)
ylabel('Frequency')

% Split the datastore

[imdsTrain, imdsVal, imdsTest, pxdsTrain, pxdsVal, pxdsTest] = splitDataset(imds,pxds, classes, labelIDs);

numTrainingImages = numel(imdsTrain.Files)

numValImages = numel(imdsVal.Files)

numTestingImages = numel(imdsTest.Files)

%% Network
% Specify the network image size. This is typically the same as the traing image sizes.
imageSize = [625 625 3];

% Specify the number of classes.
numClasses = numel(classes);

% Create DeepLab v3+.
lgraph = deeplabv3plusLayers(imageSize, numClasses, "resnet18");

imageFreq = tbl.PixelCount ./ tbl.ImagePixelCount;
classWeights = median(imageFreq) ./ imageFreq

pxLayer = pixelClassificationLayer('Name','labels','Classes',tbl.Name,'ClassWeights',classWeights);
lgraph = replaceLayer(lgraph,"classification",pxLayer);

% Define validation data.
pximdsVal = pixelLabelImageDatastore(imdsVal,pxdsVal);

% Define training options. 
options = trainingOptions('sgdm', ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropPeriod',10,...
    'LearnRateDropFactor',0.3,...
    'Momentum',0.9, ...
    'InitialLearnRate',1e-3, ...
    'L2Regularization',0.005, ...
    'ValidationData',pximdsVal,...
    'MaxEpochs',30, ...  
    'MiniBatchSize',8, ...
    'Shuffle','every-epoch', ...
    'CheckpointPath', tempdir, ...
    'VerboseFrequency',2,...
    'Plots','training-progress',...
    'ValidationPatience', 4);

augmenter = imageDataAugmenter('RandXReflection',true,...
    'RandXTranslation',[-10 10],'RandYTranslation',[-10 10]);

pximds = pixelLabelImageDatastore(imdsTrain,pxdsTrain, ...
    'DataAugmentation',augmenter)

doTraining = true;

if doTraining    
    [net, info] = trainNetwork(pximds,lgraph,options);
else
    data = load(pretrainedNetwork); 
    net = data.net;
end

I = readimage(imdsTest,3);
C = semanticseg(I, net);

B = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.4);
imshow(B)
pixelLabelColorbar(cmap, classes);

