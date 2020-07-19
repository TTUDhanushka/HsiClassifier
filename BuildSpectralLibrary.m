clc;
close All;

addpath('HelperFunctions');

%% Options for the code.

desired_bands = 25;                 % Number of spectral bands needed for for the classification.

% if the program runs for the first time, there are no predefined bands in
% the workspace. Therefore it should be "false". This will generate set of
% bands according to the image.

use_predefined_bands = false;       % Get the spectral data cubes from predefined bands
white_ref_set = false;

%% Build spectral library for all the terrain classes

% Image source is the camera type.
image_source = 'specim';

% HSI data cube folder.
directory_path = uigetdir;
directory_path = strcat(directory_path,'\');

% Get the library folder.
currentFolder = pwd;
library_path = strcat(currentFolder,'\', 'SpectralLibrary');

% Read the HSI data cube.
rgb_file = '';
header_file = '';
hsi_file = '';

[rgb_file, header_file, hsi_file, white_ref_file,...
    white_ref_hdr, dark_ref_file, dark_ref_hdr] = GetDataFiles(directory_path);

% Get the header data
[cols, lines, bands, wave] = ReadHeader(header_file, image_source);



%% Image correction

% image = multibandread('tst0012.fits', [31 73 5], ...
%                     'int16', 74880, 'bil', 'ieee-be', ...
%                     {'Band', 'Range', [1 3]} );

hsi_cube = multibandread(hsi_file, [cols lines bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

dark_ref_cube = multibandread(dark_ref_file, [cols 1 bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

% Reconstruct RGB image from the cube
dummyRGB = zeros(512, 512, 3, 'uint8');
br = 30;
dummyRGB(:,:,1) = uint8(hsi_cube(:,:,26) / 16) + br;
dummyRGB(:,:,2) = uint8(hsi_cube(:,:,53) / 16) + br + 10;
dummyRGB(:,:,3) = uint8(hsi_cube(:,:,104) / 16) + br + 15;

% Select white reference area

if ~(white_ref_set)
    [wh_ref_im, wh_ref_im_x, wh_ref_im_y] = Select_Pixel_Class(dummyRGB, false);

    white_ref_cube = Extract_Training_Pixels(hsi_cube, wh_ref_im_x, wh_ref_im_y);
    
    white_ref_set = true;
end

[wh_ref_h, wh_ref_w, wh_ref_d] = size(white_ref_cube);

X_axis = linspace(1, wh_ref_d, wh_ref_d);
Y_axis = zeros(wh_ref_h *  wh_ref_w, wh_ref_d);

for i = 1:wh_ref_h
    
    for j = 1:wh_ref_w
        
        Y_axis(((i - 1) * wh_ref_w) + j, :) = white_ref_cube(i, j, :);
        hold on
        
        plot(X_axis, Y_axis(((i - 1) * wh_ref_w) + j, :));
    end
end

white_ref_avg = zeros(1, wh_ref_d);
dark_ref_avg = zeros(1, wh_ref_d);

for i = 1:wh_ref_d
     dark_ref_avg(1,i) = mean (dark_ref_cube(:,1,i));   
     white_ref_avg(1,i) = mean (Y_axis(:,i));
end

figure()
plot(X_axis, white_ref_avg, 'b', 'LineWidth', 2)
hold on
plot(X_axis, dark_ref_avg, 'r', 'LineWidth', 2)
hold off
    
correctd_hsi_cube = zeros(cols, lines, bands);


    for i = 1:cols
        for j = 1:lines
            for k = 1:bands

                correctd_hsi_cube(i,j,k) = (4096 * (hsi_cube(i,j,k) - dark_ref_avg(k)) / (white_ref_avg(k) - dark_ref_avg(k)));
            end
        end
    end


%% Band reduction


single_step_band_cnt = floor(204 / desired_bands);

reduced_hsi_image_min_max = zeros(cols, lines, desired_bands);

if (use_predefined_bands)
    for i = 1:cols
        for j=1:lines
            for k=1:desired_bands
                reduced_hsi_image_min_max(i,j,k) = correctd_hsi_cube(i,j, min_max_pool_bands(k));
            end
        end
    end
else
    
    % linear_image = Convert_to_1d_Spectral(hsi_cube);
    linear_image = Convert_to_1d_Spectral(correctd_hsi_cube);
    
    min_max_pool_bands = Min_Max_Pooling(linear_image, desired_bands);
    
    % Write band numbers to a text file.
    fid = fopen('bands_list.txt', 'w');

    nbytes = fprintf(fid, '%3.2f \n', min_max_pool_bands)
    fclose(fid);
    
    reduced_hsi_image_min_max = Create_Min_Band_Image(correctd_hsi_cube, min_max_pool_bands);
end
%% Extract image classes
% Need to change

% samples_per_class = input('How many samples per class? ')               % How many training samples per class
class_name = input('Class name?', 's')

files_list = dir(library_path);
items_in_dir = size(files_list);
class_exist = false;

fileFormat = 'bil';
dataFileName = strcat(class_name, '.',  fileFormat);
classFilePath = fullfile(library_path, dataFileName);

hdrFormat = 'txt';
hdrFileName = strcat(class_name, '.',  hdrFormat);
headerFilePath = fullfile(library_path, hdrFileName);

for i = 1:items_in_dir(1)
    class_exist = contains(files_list(i).name,class_name,'IgnoreCase',true)
    
    if(class_exist)
        break;
    end
end


clear seg_image; 

seg_image = dummyRGB;     % zeros(cols, lines, 3, 'uint8');

sample_coords_struct = struct;

masking_color = [0 128 192];

[im, im_TL, im_BR] = Select_Pixel_Class(dummyRGB, false);     % if the image in memory, second parameter should be "false".

seg_image = Display_Classified_Image(dummyRGB, im_TL, im_BR, masking_color);

class_cube = Extract_Training_Pixels(reduced_hsi_image_min_max, im_TL, im_BR);

[h_class, w_class, d_class] = size(class_cube);


temp_cube = zeros(h_class * w_class, 1, d_class);

for i = 1:h_class
    for j=1:w_class
        temp_cube(((w_class * (i-1)) + j), 1, :) =  class_cube(i,j,:);
    end
end

if (class_exist)
    
    lib_attrib = readmatrix(headerFilePath);
    
    class_lib_cols = lib_attrib(1, 1);
    class_lib_row = lib_attrib(1, 2);
    class_lib_smpl = lib_attrib(1, 3);
    
    lib_class = multibandread(classFilePath, [class_lib_cols class_lib_row class_lib_smpl],...
        'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 class_lib_smpl]});
    
    temp_cube = [lib_class; temp_cube];
    
end

figure();
imshow(seg_image);
title(class_name);

% Plot the spectral distribution.
locImageFormat = 'png';
locImageFileName = strcat(class_name, '_location.',  locImageFormat);
locImageFilePath = fullfile(library_path, locImageFileName);
saveas(gcf, locImageFilePath);

%% Writing datacubes in to the library
header_data = size(temp_cube);

writematrix(header_data, headerFilePath, 'Delimiter', ',');

multibandwrite(temp_cube, classFilePath, fileFormat);

%% Write the image file
multibandwrite(reduced_hsi_image_min_max,'reduced_hsi_image_min.bil','bil');
%%
figure();

% plot original data
X_axis = linspace(0,desired_bands,desired_bands);
Y_axis = linspace(0,desired_bands,desired_bands);

lightBlue = [208 208 208] ./ 255;
darkBlue = [71 71 71] ./ 255;

plotColorMain = darkBlue;
plotColorSub = lightBlue;

for i = 1:(h_class * w_class)
    
    Y_axis(1,:) = temp_cube(i,1,:) / 4096;
    
    hold on
    plot(X_axis, Y_axis, 'Color', plotColorSub);
    
end

spec_avg = zeros(1, desired_bands);
for i = 1:desired_bands
    spec_avg(1,i) = mean (Y_axis(:,i));
end

plot(X_axis, spec_avg, 'Color', plotColorMain , 'LineWidth', 2)

xlim([0 desired_bands])
xlabel('Band number')
ylim([0 1])
ylabel('Normalized reflectance')
title(class_name);
hold off

% Plot the spectral distribution.
pltFormat = 'png';
plotFileName = strcat(class_name, '.',  pltFormat);
plotFilePath = fullfile(library_path, plotFileName);
saveas(gcf, plotFilePath);
    