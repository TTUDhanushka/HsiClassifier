clc;

%% SVM classifier

% InputData preperation
% X = training_Data_Aug.';
rData = GetReducedBandData1D(training_Data_Aug, bSet_9);
X = rData.';
Y = training_Labels_Aug.';

%% Multiclass classifier training

model = fitcecoc(X,Y);

%% Predict

% testInputs = inputData.';

dataCube = RotateHsiImage(reflectanceCube.DataCube, -90);
[h, w, d] = size(dataCube);

inputData = dataCube; % ReducedBandImage(dataCube, bSet);
tempInputs = UnfoldHsiCube(inputData);

testInputs = tempInputs.';

predictY = predict(model, testInputs);
 

%% Classification outcome

imageResult = zeros(h, w,3, 'uint8');

for n = 1: length(predictY)
    lbl_id = predictY(n)
    
    row = fix(n/w) + 1;
    column = mod(n,w);
    
    if (mod(n,w) == 0)
        row = fix(n/w);
        column = w;
    end
    
    imageResult(row, column, :) = Get_Label_Color(lbl_id);
end


figure()
imshow(imageResult);

