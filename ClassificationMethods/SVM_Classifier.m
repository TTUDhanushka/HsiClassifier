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

totalClasses = 16;

pointsPerSvmClass = zeros(totalClasses, 1);

tempSvmClassPoints = zeros(645 * 645, 14, 2);

cntArr = ones(totalClasses, 1);

for n = 1: length(predictedLabels)
    lbl_id = predictedLabels(n);
    
    row = fix(n/data_w) + 1;
    column = mod(n,data_w) + 1;
    classifiedImage(row, column, :) = Get_Label_Color(lbl_id);
    
    pointsPerSvmClass(lbl_id, 1) = pointsPerSvmClass(lbl_id, 1) + 1; 
    
    tempSvmClassPoints(cntArr(lbl_id), lbl_id, :) = [row, column];
    cntArr(lbl_id) = cntArr(lbl_id) + 1;
end


figure()
imshow(classifiedImage)


%% Extract 10 pixels from each class

classesCount = 0;

augHsiClassPoints = zeros(cols * lines, 14, 2);

extractedHsiPixels = zeros(10 * classesCount, 2);

pixeCnt = 1;

% ignore all the classes which has less than 1% of pixels.
for n = 1:length(pointsPerSvmClass)
    if pointsPerSvmClass(n) > (4096)        % 645 * 645 * 0.01. Less than 1%
        classesCount = classesCount + 1;
        
        rand_idx = randperm(pointsPerSvmClass(n), pointsPerSvmClass(n));
        
        for m = 1: length(rand_idx)
            augHsiClassPoints(m, n, :) = tempSvmClassPoints(rand_idx(m), n, :);
        end
        
        for pixel = 1:10
            extractedHsiPixels(((classesCount - 1) * 10) + pixel, :) = augHsiClassPoints(pixel, n, :);
            pixeCnt = pixeCnt + 1;
        end
    end
end


