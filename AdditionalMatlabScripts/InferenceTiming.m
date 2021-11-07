% Get the inference timing for images.

% Start process-tick counter
tic;

% Run inference
testDatasetPath = uigetdir();

testImgDir = fullfile(testDatasetPath, 'images');
testLabelsDir = fullfile(testDatasetPath, 'labels');

imdsTest = imageDatastore(testImgDir);
pxdsTest = pixelLabelDatastore(testLabelsDir, classes, labelIDs);

for nImages = 1: length(imdsTest.Files)
    testImg = readimage(imdsTest, nImages);
    
    C = semanticseg(testImg, net);
    
    
end


% Stop process tick counter
toc;

% Elapsed time