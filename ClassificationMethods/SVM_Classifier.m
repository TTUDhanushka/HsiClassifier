clc;

%% SVM classifier

% InputData preperation
% X = training_Data_Aug.';
rData = GetReducedBandData1D(training_Data_Aug, bSet);
X = rData.';
Y = training_Labels_Aug.';

%% Multiclass classifier training

model = fitcecoc(X,Y);

%% Predict

% testInputs = inputData.';

dataCube = RotateHsiImage(reflectanceCube.DataCube, -90);
[h, w, d] = size(dataCube);

inputData = ReducedBandImage(dataCube, bSet);
tempInputs = UnfoldHsiCube(inputData);

testInputs = tempInputs.';

predictedLabels = predict(model, testInputs);
 

%% Classification outcome

imageResult = zeros(h, w,3, 'uint8');

for n = 1: length(predictedLabels)
    lbl_id = predictedLabels(n);
    
    row = fix(n/w) + 1;
    column = mod(n,w) + 1; %
    
    imageResult(row, column, :) = Get_Label_Color(lbl_id);
end


figure()
imshow(imageResult);

