% Super pixel clustering.

imgCopy = imrotate(higResRgb, 90);

no_Of_Superpixels = 200;


[L,N] = superpixels(imgCopy, no_Of_Superpixels);

figure
BW = boundarymask(L);
imshow(imoverlay(imgCopy,BW,'cyan'),'InitialMagnification',67)

areaMean = zeros(N, 3, 'uint8');

[h, w] = size(L);

temp = zeros(645*645, 3);

sparseimage = zeros(h, w, 3, 'uint8');

for k = 1:N
    cnt = 1;
    
    for i = 1:h
        for j = 1:w
            if L(i, j) == k
                temp(cnt, :) = imgCopy(i, j, :);
                cnt = cnt + 1;
            end
        end
    end
    
    areaMean(k, :) = uint8(mean(temp(1:cnt, :)));
end

for k = 1:N
    for i = 1:h
        for j = 1:w
            
            if L(i, j) == k
                sparseimage(i, j ,:) = areaMean(k, :);
            end            
        end
    end
end

figure
imshow(sparseimage);
    
%% Second SLIC


[L2,N2] = superpixels(sparseimage, classesCount);

figure
BW2 = boundarymask(L2);
imshow(imoverlay(imgCopy,BW2,'cyan'),'InitialMagnification',67)

pointsPerClass = zeros(classesCount, 1);
tempClassPoints = zeros(645 * 645, 14, 2);

for k = 1:classesCount 
    cnt = 1;
    for i = 1:h
        for j = 1:w
            if L2(i, j) == k
                pointsPerClass(k, 1) = pointsPerClass(k, 1) + 1;
                tempClassPoints(cnt, k, :) = [i, j];
                cnt = cnt + 1;
            end
        end
    end
end


%% Get 10 random samples from each class and 

augClassPoints = zeros(645 * 645, 14, 2);
pixelPairs = zeros(10 * classesCount, 2);

pixeCnt = 1;

for class = 1: classesCount

    rand_idx = randperm(pointsPerClass(class), pointsPerClass(class));
    
    for n = 1: length(rand_idx)
        augClassPoints(n, class, :) = tempClassPoints(rand_idx(n), class, :);
    end
    
    for pixel = 1:10
        pixelPairs(((class - 1) * 10) + pixel, :) = augClassPoints(pixel, class, :);
        pixeCnt = pixeCnt + 1;
    end
end

