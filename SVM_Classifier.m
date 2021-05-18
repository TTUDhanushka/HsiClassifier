clc;

%% SVM classifier

% InputData preperation
% X = training_Data_Aug.';

X = rData.';
Y = training_Labels_Aug.';

%% Multiclass classifier training

model = fitcecoc(X,Y);

%% Predict

% testInputs = inputData.';
tempInputs = GetReducedBandData1D(inputData, bSet);
testInputs = tempInputs.';

predictedLabels = predict(model, testInputs);


%% Create result classification

classifiedImage = zeros(data_h, data_w, 3, 'uint8');

for n = 1: length(predictedLabels)
    lbl_id = predictedLabels(n);
    
    row = fix(n/data_w) + 1;
    column = mod(n,data_w) + 1;
    classifiedImage(row, column, :) = Get_Label_Color(lbl_id);
end

figure()
imshow(classifiedImage)