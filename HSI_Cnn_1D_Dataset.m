%% CNN for spectral classification

%% Get HSI data and make white / dark correction

%
%   Note: Add "HelperFunctions" to the path.
%

ReadSpecimData();
%%
% Get input data from workspace.
% [data_h, data_w, data_d] = size(correctd_hsi_cube);
[data_h, data_w, data_d] = size(correctd_hsi_cube);

%% Unfold the datacube and get spectral data into rows
inputData = zeros(data_d, data_h * data_w);

for a = 1:data_h
    for b = 1:data_w
        inputData(:, ((a-1) * data_h) + b) = correctd_hsi_cube(a, b, :);
    end
end

%% Output labels

% Get the ground truth.
%labelImage = imread("G:\3. Hyperspectral\5. Matlab HSI\20200420\REFLECTANCE_2019-11-18_021_gt.png");
labelImage = groundTruthImage; %imrotate(labelImage, 90);

[h,w,d] = size(labelImage);

% Display the labelled image
imshow(labelImage);

classes = uint8([[128 128 128 1];[128 128 0 2];[117 76 36 3];[109 207 246 4]; [133 96 168 5]; [255 242 0 6]]);

outPutLabelsRaw = zeros(h * w, 1);

for i = 1:h
    for j = 1:w
        for class = 1:6
            if((classes(class,1) == labelImage(i,j,1)) && (classes(class,2) == labelImage(i,j,2)) && (classes(class,3) == labelImage(i,j,3))) 
                outPutLabelsRaw(((i - 1) * h ) + j) = class;  
            end
        end
    end
end

outPutLabels = outPutLabelsRaw.';

%% Transform data into CNN usable format

height = 1;
width = data_d;
channels = 1;
sampleSize = data_h * data_w;

CNN_TestPixels = reshape(inputData,[height, width, channels, sampleSize]);

CNN_TestLabel = categorical(outPutLabels);

%% Call NN and perform the test

predictY = predict(deep_net, CNN_TestPixels);

%% Create result classification

classifiedImage = zeros(data_h, data_w, 1, 'uint8');

for n = 1: sampleSize
    row = fix(n/data_w) + 1;
    column = mod(n,data_w) + 1;
    classifiedImage(row, column) = predictY(n) * 50;
end

figure()
imshow(classifiedImage)