function [accuracy] = ClassificationAccuracy(groundTruthImage, classificationResult)

    % Read result image and ground truth image
    noOfClasses = 13;
    channels = 3;
    
    % These files are taken from the workspace.
    [h, w, d] = size(groundTruthImage);
    [h_r, w_r, d_r] = size(classificationResult);

%     compare_image = zeros(h, w, channels, 'uint8');
    accuracy = zeros(1, noOfClasses + 1, 'double');

    if ((h ~= h_r) || (w ~= w_r) || (d ~= d_r))
        disp('Image dimensions are not equal');
        return;
    end
    
    gtPixelsCount = zeros(1, noOfClasses);
    resultPixelsCount = zeros(1, noOfClasses);
        
    classColors = zeros(noOfClasses, channels);
    
    for nClass = 1:noOfClasses
        classColors(nClass, :) = Get_Label_Color(nClass);
    end
    
    gtPixel = zeros(1, 3, 'uint8');
    resultPixel = zeros(1, 3, 'uint8');
    
    for i = 1:h
        for j = 1:w
            gtPixel(1, :) = groundTruthImage(i, j, :);
            resultPixel(1, :) = classificationResult(i, j, :);
            
            classID = 1;
            
            for nColor = 1:length(classColors)
                if (classColors(nColor, :) == gtPixel)
                    classID = nColor;
                end
            end
            
            if isequal(gtPixel, resultPixel)
                switch(classID)
                    case 1
                        gtPixelsCount(1, 1) = gtPixelsCount(1, 1) + 1;
                        resultPixelsCount(1, 1) = resultPixelsCount(1, 1) + 1;
                    case 2
                        gtPixelsCount(1, 2) = gtPixelsCount(1, 2) + 1;
                        resultPixelsCount(1, 2) = resultPixelsCount(1, 2) + 1;
                    case 3
                        gtPixelsCount(1, 3) = gtPixelsCount(1, 3) + 1;
                        resultPixelsCount(1, 3) = resultPixelsCount(1, 3) + 1;
                    case 4
                        gtPixelsCount(1, 4) = gtPixelsCount(1, 4) + 1;
                        resultPixelsCount(1, 4) = resultPixelsCount(1, 4) + 1;
                    case 5
                        gtPixelsCount(1, 5) = gtPixelsCount(1, 5) + 1;
                        resultPixelsCount(1, 5) = resultPixelsCount(1, 5) + 1;
                    case 6
                        gtPixelsCount(1, 6) = gtPixelsCount(1, 6) + 1;
                        resultPixelsCount(1, 6) = resultPixelsCount(1, 6) + 1;
                    case 7
                        gtPixelsCount(1, 7) = gtPixelsCount(1, 7) + 1;
                        resultPixelsCount(1, 7) = resultPixelsCount(1, 7) + 1;
                    case 8
                        gtPixelsCount(1, 8) = gtPixelsCount(1, 8) + 1;
                        resultPixelsCount(1, 8) = resultPixelsCount(1, 8) + 1;
                    case 9
                        gtPixelsCount(1, 9) = gtPixelsCount(1, 9) + 1;
                        resultPixelsCount(1, 9) = resultPixelsCount(1, 9) + 1;
                    case 10
                        gtPixelsCount(1, 10) = gtPixelsCount(1, 10) + 1;
                        resultPixelsCount(1, 10) = resultPixelsCount(1, 10) + 1;
                    case 11
                        gtPixelsCount(1, 11) = gtPixelsCount(1, 11) + 1;
                        resultPixelsCount(1, 11) = resultPixelsCount(1, 11) + 1;
                    case 12
                        gtPixelsCount(1, 12) = gtPixelsCount(1, 12) + 1;
                        resultPixelsCount(1, 12) = resultPixelsCount(1, 12) + 1;
                    case 13
                        gtPixelsCount(1, 13) = gtPixelsCount(1, 13) + 1;
                        resultPixelsCount(1, 13) = resultPixelsCount(1, 13) + 1;
                end
            else
                switch(classID)
                    case 1
                        gtPixelsCount(1, 1) = gtPixelsCount(1, 1) + 1;
                    case 2
                        gtPixelsCount(1, 2) = gtPixelsCount(1, 2) + 1;
                    case 3
                        gtPixelsCount(1, 3) = gtPixelsCount(1, 3) + 1;
                    case 4
                        gtPixelsCount(1, 4) = gtPixelsCount(1, 4) + 1;
                    case 5
                        gtPixelsCount(1, 5) = gtPixelsCount(1, 5) + 1;
                    case 6
                        gtPixelsCount(1, 6) = gtPixelsCount(1, 6) + 1;
                    case 7
                        gtPixelsCount(1, 7) = gtPixelsCount(1, 7) + 1;
                    case 8
                        gtPixelsCount(1, 8) = gtPixelsCount(1, 8) + 1;
                    case 9
                        gtPixelsCount(1, 9) = gtPixelsCount(1, 9) + 1;
                    case 10
                        gtPixelsCount(1, 10) = gtPixelsCount(1, 10) + 1;
                    case 11
                        gtPixelsCount(1, 11) = gtPixelsCount(1, 11) + 1;
                    case 12
                        gtPixelsCount(1, 12) = gtPixelsCount(1, 12) + 1;
                    case 13
                        gtPixelsCount(1, 13) = gtPixelsCount(1, 13) + 1;
                end
            end

        end
    end
    

    
    %% Compare overall accuracy

    totalPixels = h * w;

    for idx = 1:noOfClasses
        accuracy(1, idx) = double((resultPixelsCount(1, idx) / gtPixelsCount(1, idx))) * 100;
    end

    success = sum(resultPixelsCount);
    
    accuracy(1, noOfClasses + 1) = (success / totalPixels) * 100;


 end

