%% Pick training data samples from HSI data cube and ground truth.

% This script is for 1D CNN training only. The datacube is transformed into
% 4-D array as an input data set for the CNN while labels will be made as
% categorical vectors.

seg_image = rgb_from_corrected;     % zeros(cols, lines, 3, 'uint8');

% All the class names
class_names = [ "class1" "class2" "class3" "class4"...
                "class5" "class6" "class7" "class8"...
                "class9" "class10" "class11" "class12"...
                "class13" "class14" "class15" "class16"...
                "class17" "class18" "class19" "class20"];
%             ...
%                 "class21" "class22" "class23" "class24"

% class_coord = zeros(number_of_classes, 4);

sample_coords_struct = struct;

trainingDataCube = zeros(bands, lines * cols);
trainingDataLabels = zeros(1, lines * cols);

sampleLen = 0;

if ~read_coords_from_file
    
    for mask_id = 1: (number_of_classes * samples_per_class)
        
        masking_color = Get_Masking_Color(number_of_classes, mask_id);
        
        [im, im_x, im_y] = Select_Pixel_Class(seg_image, false);
        
        sample_coords_struct(mask_id).im_x = im_x;
        sample_coords_struct(mask_id).im_y = im_y;
        sample_coords_struct(mask_id).color = masking_color;
        
        seg_image = Display_Classified_Image(seg_image, im_x, im_y, masking_color);
        
        sampleHeight = im_y(1) - im_x(1);
        sampleWidth = im_y(2) - im_x(2);
        
        pointsInSample = sampleWidth * sampleHeight;
        
        % Extract the HSI pixels from calibrated hsi image datacube.
        class_cube = Extract_Training_Pixels(correctd_hsi_cube, im_x, im_y);
        
        for idX = 1: sampleWidth + 1                % Because matlab arrays are starting from 1.
            for idY = 1:sampleHeight + 1
               trainingDataCube(:, sampleLen + ((idX - 1) * sampleWidth) + idY) = class_cube(idX, idY,:);
            end
        end
        
        for idI = 1: sampleWidth + 1
            for idJ = 1:sampleHeight + 1
               trainingDataLabels(1, sampleLen + ((idI - 1) * sampleWidth) + idJ) = mask_id - 1;
            end
        end
        
        sampleLen = sampleLen + (sampleWidth * sampleHeight);

    end
    
    writetable(struct2table(sample_coords_struct),'coords.txt')
    
else
    coords_table = readtable('coords.txt');
    
    table_size = size(coords_table);
    table_len = table_size(1,1);
    
    for i = 1: table_len
        im_x = [coords_table.im_x_1(i) coords_table.im_x_2(i)];
        im_y = [coords_table.im_y_1(i) coords_table.im_y_2(i)];
        
        mask_color = [coords_table.color_1(i) coords_table.color_2(i) coords_table.color_3(i)];
        
        seg_image = Display_Classified_Image(seg_image, im_x, im_y, mask_color);        
        
        % Extract the HSI pixels from calibrated hsi image datacube.
        class_cube = Extract_Training_Pixels(correctd_hsi_cube, im_x, im_y);
        
        % Extract the labels from ground truth.
        class_labels = Extract_Labels(groundTruthImage, im_x, im_y);

        Generate_Training_Datacubes(class_names(i), class_cube);
    end

end

figure();
imshow(seg_image);
title('Classes on the image');

%% Convert to 4-D array

% Split the array
tempCube = trainingDataCube(:, 1: sampleLen);
tempLabels = trainingDataLabels(1, 1: sampleLen);

rndTempCube = zeros(bands, sampleLen);
rndTempLabels = zeros(1, sampleLen);

randIdx = randperm(sampleLen);

for i = 1: sampleLen
    rndTempCube(:, i) = tempCube(:, randIdx(i));
    rndTempLabels(1, i) = tempLabels(1, randIdx(i));
end

CNN_TrainingData = reshape(rndTempCube,[1, bands, 1, sampleLen]);
CNN_LabelData = categorical(rndTempLabels);