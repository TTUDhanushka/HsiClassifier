function [imdsTrain, imdsVal, imdsTest, pxdsTrain, pxdsVal, pxdsTest] = splitHsiDataset(imds,pxds, classesList, labelIDs)
% Set initial random state for example reproducibility.
rng(0); 
numFiles = numel(imds.Files);
shuffledIndices = randperm(numFiles);

% Use 60% of the images for training.
numTrain = round(0.80 * numFiles);
trainingIdx = shuffledIndices(1:numTrain);

% Use 20% of the images for validation
numVal = round(0.10 * numFiles);
valIdx = shuffledIndices(numTrain+1:numTrain+numVal);

% Use the rest for testing.
testIdx = shuffledIndices(numTrain+numVal+1:end);

% Create image datastores for training and test.
trainingImages = imds.Files(trainingIdx);
valImages = imds.Files(valIdx);
testImages = imds.Files(testIdx);

imdsTrain = imageDatastore(trainingImages, 'FileExtensions', '.dat', 'ReadFcn', @hsiReader);
imdsVal = imageDatastore(valImages, 'FileExtensions', '.dat', 'ReadFcn', @hsiReader);
imdsTest = imageDatastore(testImages, 'FileExtensions', '.dat', 'ReadFcn', @hsiReader);

% Create pixel label datastores for training and test.
trainingLabels = pxds.Files(trainingIdx);
valLabels = pxds.Files(valIdx);
testLabels = pxds.Files(testIdx);

pxdsTrain = pixelLabelDatastore(trainingLabels, classesList, labelIDs);
pxdsVal = pixelLabelDatastore(valLabels, classesList, labelIDs);
pxdsTest = pixelLabelDatastore(testLabels, classesList, labelIDs);
end