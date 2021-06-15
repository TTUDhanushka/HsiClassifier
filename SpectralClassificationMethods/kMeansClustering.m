%% K means clustering method for object classification

% Notes: Get the datacubes into workspace using MainProgram.m file.
% Otherwise ReadSpecimData.m also can read the data directly from the
% directory.


%% k-Means
% Define the k parameter which is number of classes in the image (clusters).
    kClasses = 13;
    
    
% Unfold the datacube with samples on rows and spectral data on columns.
    kInputCube = zeros(cols * lines, bands);
    
    for i = 1:cols
        for j = 1:lines
%             kInputCube(((i - 1) * lines + j), :) = reflectanceCube.DataCube(i, j, :);
            kInputCube(((i - 1) * lines + j), :) = sgFilteredCube(i, j, :);
        end
    end
    

    [idx, C] = kmeans(kInputCube, kClasses);
    
%% Classification output

    usedClassList = [2 6 7 10 13];

    classifiedImage = zeros(cols, lines, 3, 'uint8');

    for n = 1: length(idx)

        row = fix(n/lines) + 1;
        column = mod(n,lines) + 1;
        classifiedImage(row, column, :) = Get_Label_Color(usedClassList(idx(n)));
    end

    figure()
    imshow(classifiedImage)