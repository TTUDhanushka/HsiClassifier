function iouAccuracy = IoU(groundTruthImage, classificationResult)
    % Read result image and ground truth image
    noOfClasses = 13;

    % These files are taken from the workspace.
    [h, w, d] = size(groundTruthImage);
    [h_r, w_r, d_r] = size(classificationResult);

    channels = d;
    
    %     compare_image = zeros(h, w, channels, 'uint8');
    iouAccuracy = zeros(1, noOfClasses, 'double');

    if ((h ~= h_r) || (w ~= w_r) || (d ~= d_r))
        disp('Image dimensions are not equal');
        return;
    end
    
    classGroundTruth = zeros(h, w, 'uint8');
    classResult = zeros(h, w, 'uint8');
    
    gtPixelsCount = zeros(1, noOfClasses);
    resultPixelsCount = zeros(1, noOfClasses);
    
    intersect = zeros(1, noOfClasses);
            
    % Convert images into classes.
    for i = 1:h
        for j = 1:w
            gtPixelColor = [groundTruthImage(i, j, 1), groundTruthImage(i, j, 2), groundTruthImage(i, j, 3)];
            classGroundTruth(i, j) = GetPixelClassId(gtPixelColor);
            gtPixelsCount(1, classGroundTruth(i, j)) = gtPixelsCount(1, classGroundTruth(i, j)) + 1;
            
            
            resPixelColor = [classificationResult(i, j, 1), classificationResult(i, j, 2), classificationResult(i, j, 3)];
            classResult(i, j) = GetPixelClassId(resPixelColor);
            resultPixelsCount(1, classResult(i, j)) = resultPixelsCount(1, classResult(i, j)) + 1;
        end
    end
    
    
    % Get total number of pixels for each class in ground truth.    
    for i = 1:h
        for j = 1:w
            
            if (classGroundTruth(i, j) == classResult(i, j))
                intersect(1, classGroundTruth(i, j)) = intersect(1, classGroundTruth(i, j)) + 1;
            end
        end
    end
    
    union = gtPixelsCount + resultPixelsCount - intersect;
    
    iouAccuracy = (intersect ./ union) * 100;
end