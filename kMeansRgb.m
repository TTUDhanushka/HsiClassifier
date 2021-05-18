%% k-Means
    
    % Define the k parameter which is number of classes in the image (clusters).
    kClasses = 8;
    [colsRGB, linesRGB, channels] = size(higResRgb);
    
    % Unfold the datacube with samples on rows and spectral data on columns.
    kInputRGB = zeros(colsRGB * lines, channels);
    
    for i = 1:colsRGB
        for j = 1:linesRGB

            kInputRGB(((i - 1) * linesRGB + j), :) = higResRgb(i, j, :);
        end
    end
    
    [idx, C] = kmeans(kInputRGB, kClasses);
    
    
    %% Display classification result.
    
%    usedClassList = [3, 4, 5, 7, 8, 9, 10, 13];

     classifiedImage = zeros(cols, lines, channels, 'uint8');

    for n = 1: length(idx)

        row = fix(n/linesRGB) + 1;
        column = mod(n,linesRGB) + 1;
        classifiedImage(row, column, :) = Get_Label_Color(idx(n));
    end

    clear colsRGB linesRGB row column kInputRGB kClasses;
    
    figure()
    imshow(classifiedImage)