function iouAccuracy = IoU(groundTruthImage, classificationResult)
    % Read result image and ground truth image
    noOfClasses = 13;

    % These files are taken from the workspace.
    [h, w, d] = size(groundTruthImage);
    [h_r, w_r, d_r] = size(classificationResult);

    channels = d;
    
    %     compare_image = zeros(h, w, channels, 'uint8');
    iouAccuracy = zeros(1, noOfClasses + 1, 'double');

    if ((h ~= h_r) || (w ~= w_r) || (d ~= d_r))
        disp('Image dimensions are not equal');
        return;
    end
    
    classGroundTruth = zeros(h, w, 'uint8');
    classResult = zeros(h, w, 'uint8');
    
    % Convert images into classes.
    for i = 1:h
        for k = 1:w
            classGroundTruth(i, j) = 
        end
    end
    
    
    % Get total number of pixels for each class in ground truth.
    
    for classId = 1: noOfClasses
        
    end
    
end