%% Band selection for Indian Pines dataset
% 
% This script extracts different number of spectral bands from Indian Pines
% dataset.
%   
%

%% Options

% Get the number of spectral bands for three options
requiredBandsCount = 9;     % 9, 16 or 25 bands

[w, h, d] = size(indian_pines_corrected);
classes = 10;
samplesPerClass = 10;      % From a 10 x 10 patch

% % Top left coordinates of each pixel class.
% trainingPixelTpL = [[9, 2]; [70, 99]; [20, 7]; [1, 1]; [36, 9 ]; [83, 12];...
%                     [68, 33]; [74, 110]; [46, 126]; [66, 23]; [13, 31];...
%                     [12, 103]; [19, 69]; [121, 44]; [129, 120]; [9, 93]; [17, 50]];
                

trainingPixelTpL = [[95, 1]; [31, 37]; [60, 4]; [74, 2]; [99, 58];...   % 0 - 4
                    [39, 122]; [40, 79]; [79, 56]; [13, 56]; [118, 102]];

classVecs = zeros(classes * samplesPerClass, d);

for nClassIdx = 1: classes
    for mdx = 1: 4
        for mdy = 1:4
            classVecs(((nClassIdx - 1 ) * samplesPerClass) + ((mdx - 1) * 10) + mdy, :) = indian_pines_corrected(trainingPixelTpL(nClassIdx,1) + mdx, ...
                        trainingPixelTpL(nClassIdx, 2) + mdy, :);
        end
    end
end


% Color map for visualization
colorMap = [0 0 0; 
            0 255 0; 
            0 0 255; 
            127 0 255; 
            0 127 255; 
            65 127 127; 
            127 65 0; 
            127 180 180;
            255 180 180;
            255 127 255;
            201 201 65;
            158 196 113;
            127 127 127;
            114 217 255;
            180 255 255;
            115 115 225;
            65 160 160];
        
        
indian_pines_gt_vis = zeros(w, h, 3, 'uint8');

for i = 1:w
    for j = 1:h
        colorId = indian_pines_gt(i, j) + 1;
        indian_pines_gt_vis(i, j, :) = colorMap(colorId, :);
    end
end

% Remove small terrain classes
listToRemove = [1; 4; 7; 9; 13; 15; 16];    % Removed 7 classes to make it 9

% Color map for visualization
revisedColorMap = [ 0 0 0;
                    0 0 255;
                    127 0 255;
                    65 127 127;
                    127 65 0;
                    255 180 180;
                    201 201 65;
                    158 196 113;
                    127 127 127;
                    180 255 255];

                
indian_pines_gt_few_classes = zeros(w, h, 'uint8');
                
for i = 1:w
    for j = 1:h
        terrainClass = indian_pines_gt(i, j);
        
        updatedClass = 0;
        
        switch terrainClass
            case 0
               updatedClass = 0;
               
            case 1
                updatedClass = 0;
                
            case 2
                updatedClass = 1;
                
            case 3
                updatedClass = 2;
                
            case 4
                updatedClass = 1;
                
            case 5
                updatedClass = 3;
                
            case 6
                updatedClass = 4;
                
            case 7
                updatedClass = 0;
                
            case 8
                updatedClass = 5;
                
            case 9
                updatedClass = 0;
                
            case 10
                updatedClass = 6;
                
            case 11
                updatedClass = 7;
                
            case 12
                updatedClass = 8;
                
            case 13
                updatedClass = 0;
                
            case 14
                updatedClass = 9;
                
            case 15
                updatedClass = 0;
                
            case 16 
                updatedClass = 0;
        end
        
        indian_pines_gt_few_classes(i, j) = updatedClass;
    end
end

indian_pines_gt_few_cls_vis = zeros(w, h, 3, 'uint8');

for i = 1:w
    for j = 1:h
        colorIdx = indian_pines_gt_few_classes(i, j) + 1;
        indian_pines_gt_few_cls_vis(i, j, :) = revisedColorMap(colorIdx, :);
    end
end

indianPinesRGB = zeros(w, h, 3, 'uint8');
indianPinesRGB(:,:, 3) = uint8(indian_pines_corrected(:,:, 111)./32);
indianPinesRGB(:,:, 2) = uint8(indian_pines_corrected(:,:, 35)./32);
indianPinesRGB(:,:, 1) = uint8(indian_pines_corrected(:,:, 12)./32);

figure();

subplot(1, 3, 1);
imshow(indianPinesRGB);

subplot(1, 3, 2);
imshow(indian_pines_gt_vis);

subplot(1, 3, 3);
imshow(indian_pines_gt_few_cls_vis);

%% Plot spectral characteristics vectors for each class.
figure()

revisedColorMap = revisedColorMap ./ 255;

for n = 1:100 - 1
    plot(classVecs(n, :) /9000, 'Color', revisedColorMap(ceil(n / 10), :))
    hold on;
end

title('Spectral signatures of each class');
xlabel ('Band number');
ylabel('Reflectance');

hold off;

%% Run min-max pooling


indian_9_bands_list = Min_Max_Pooling(classVecs, 9)


indian_16_bands_list = Min_Max_Pooling(classVecs, 16)
tic;

indian_25_bands_list = Min_Max_Pooling(classVecs, 25)
toc