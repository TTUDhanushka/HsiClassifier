close all;
clc;

% Keep the workspace
% clear;

%% Read specim HSI data cube from local drive
%   
%   Dhanushka Liyanage
%   
%   Read Different HSI data cubes to the workspace, create calibrated image, and preview images.
%   Tested with specim camera images.
%
%   Feature selection methods
%       PCA
%       Max Pooling
%       Min-Max Pooling

%% Add necessary folders to path

addpath HelperFunctions

%% Import data

% Image source is the camera type.
image_source = 'specim';

directory_path = uigetdir;

directory_path = strcat(directory_path,'\');

%% Get the data file paths from the data directory.

% RGB preview file
rgb_file = '';
header_file = '';
hsi_file = '';

[rgb_file, header_file, hsi_file, white_ref_file,...
    white_ref_hdr, dark_ref_file, dark_ref_hdr] = GetDataFiles(directory_path);

% Get the header data
[cols, lines, bands, wave] = ReadHeader(header_file, image_source);

%% Get the preview RGB image.

%
%   This image is from the RGB camera on top of the Specim spectral
%   imaging sensor. This view and actual false RGB of HSI are not
%   necessarily matching.
%

rgb_image = imread(rgb_file);

rgb_image = RotateRgbImage(rgb_image, 90);

% Display the RGB preview image
if ~(rgb_file == "")
    subplot(2,2,1), imshow(rgb_image)
    set(gcf,'position',[10,10,1600,800]);
    title('PNG file from Specim');
end

%% Get the datacube, white reference and dark reference cubes and calibrate.

% image = multibandread('tst0012.fits', [31 73 5], ...
%                     'int16', 74880, 'bil', 'ieee-be', ...
%                     {'Band', 'Range', [1 3]} );

hsi_cube = multibandread(hsi_file, [cols lines bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

white_ref_cube = multibandread(white_ref_file, [cols 1 bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

dark_ref_cube = multibandread(dark_ref_file, [cols 1 bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});


[correctd_hsi_cube, error] = ConstructFalseRgbImage(hsi_cube, white_ref_cube,...
    dark_ref_cube);

% RGB reconstruction from HSI data cube
rgb_from_hsi = ConstructRgbImage(correctd_hsi_cube, 28, 58, 85);

% The bands has been inserted to the program manually
subplot(2,2,2), imshow(rgb_from_hsi);
title('Reconstructed image from selected bands');

rgb_2_from_hsi = ConstructRgbImage(correctd_hsi_cube);
subplot(1,3,3), imshow(rgb_2_from_hsi);
title('Reconstructed image from selected bands - corrected');

% figure()

% %%
% 
% desired_bands = 25;
% 
% %%
% % % Principle component analysis
% pca_bands = HsiCubePca (hsi_cube, desired_bands);
% % 
% % pca_cube = zeros(512, 512, 204);
% % 
% % GG = G * F;
% % 
% % [len, d] = size(G);
% % 
% % mod_in = 1;
% % div_in = 1;
% % 
% % for index = 1: len
% %     
% %     for dd = 1: 204
% %         pca_cube(div_in, mod_in, dd) = GG(index, dd);
% %     end
% %     
% %     mod_in = (mod (index, 512)) + 1;
% %     div_in = int16((index / 512) + 1);
% % end
% % 
% % imshow(pca_cube(:,:,1));
% 
% %% Pooling for band selection.
% 
% 
% single_step_band_cnt = floor(204 / desired_bands);
% 
% % linear_image = Convert_to_1d_Spectral(hsi_cube);
% linear_image = Convert_to_1d_Spectral(correctd_hsi_cube);
% 
% pool_layers = Max_Pooling(linear_image, single_step_band_cnt);
% % [mul_step_bands, st] = Multi_Step_Pooling(linear_image, desired_bands);
% 
% min_max_pool_bands = Min_Max_Pooling(linear_image, desired_bands);
% 
% [samples, band_count] = size(pool_layers);
% selected_bands = zeros(1,band_count);
% wave_length_list = zeros(1,band_count);
% wave = wave.';
% 
% for k = 1:band_count
%     
%     column_id = round(mean(pool_layers(:,k))); 
%     
%     selected_bands(1,k) = column_id;
%     
%     wave_length_list(1,k) = wave(column_id);
% end
% 
% 
% 
% %% Construct minimum bands image from two methods.
% 
% reduced_hsi_image = Create_Min_Band_Image(correctd_hsi_cube, selected_bands);
% reduced_hsi_image_min_max = Create_Min_Band_Image(correctd_hsi_cube, min_max_pool_bands);
% reduced_hsi_image_pca = Create_Min_Band_Image(correctd_hsi_cube, pca_bands);
% 
% % reduced_hsi_image_mul_stp = Create_Min_Band_Image(hsi_cube, mul_step_bands);
% 
% %% Display segmented image according to the classes
% % Need to change
% 
% number_of_classes = 5;          % How many classes in the image
% samples_per_class = 1;          % How many training samples per class
% read_coords_from_file = false;   % Read training sample coordinates from file.
% 
% seg_image = rgb_2_from_hsi;     % zeros(cols, lines, 3, 'uint8');
% 
% % All the class names
% class_names = [ "class1" "class2" "class3" "class4"...
%                 "class5" "class6" "class7" "class8"...
%                 "class9" "class10" "class11" "class12"...
%                 "class13" "class14" "class15" "class16"...
%                 "class17" "class18" "class19" "class20"];
% %             ...
% %                 "class21" "class22" "class23" "class24"
% 
% % class_coord = zeros(number_of_classes, 4);
% 
% sample_coords_struct = struct;
% 
% 
% if ~read_coords_from_file
%     
%     for mask_id = 1: (number_of_classes * samples_per_class)
%         
%         masking_color = Get_Masking_Color(number_of_classes, mask_id);
%         
%         [im, im_x, im_y] = Select_Pixel_Class(rgb_file, true);
%         
%         sample_coords_struct(mask_id).im_x = im_x;
%         sample_coords_struct(mask_id).im_y = im_y;
%         sample_coords_struct(mask_id).color = masking_color;
%         
%         seg_image = Display_Classified_Image(seg_image, im_x, im_y, masking_color);
%         
%     end
%     
%     writetable(struct2table(sample_coords_struct),'coords.txt')
%     
% else
%     coords_table = readtable('coords.txt');
%     
%     table_size = size(coords_table);
%     table_len = table_size(1,1);
%     
%     for i = 1: table_len
%         im_x = [coords_table.im_x_1(i) coords_table.im_x_2(i)];
%         im_y = [coords_table.im_y_1(i) coords_table.im_y_2(i)];
%         
%         mask_color = [coords_table.color_1(i) coords_table.color_2(i) coords_table.color_3(i)];
%         
%         seg_image = Display_Classified_Image(seg_image, im_x, im_y, mask_color);
%         
%         % Extract the HSI pixels from reconstructued image
% %         class_cube = Extract_Training_Pixels(reduced_hsi_image, im_x, im_y);
%         
%         % Extract the HSI pixels from min max pooling
%         class_cube = Extract_Training_Pixels(reduced_hsi_image_min_max, im_x, im_y);
%         
%         % Extract the HSI pixels from reconstructued image from PCA
% %         class_cube = Extract_Training_Pixels(reduced_hsi_image_pca, im_x, im_y);
% 
%         Generate_Training_Datacubes(class_names(i), class_cube);
%     end
% 
% end
% 
% figure();
% imshow(seg_image);
% title('Classes on the image');
% 
% 
% % Extract the HSI pixels from reconstructued image for multi step
% % hhh_2 = Extract_Training_Pixels(reduced_hsi_image_mul_stp, im_x, im_y); 
% 
% % Extract pixels from original image
% % hhh = Extract_Training_Pixels(correctd_hsi_cube, im_x, im_y); 
% 
% %% Saving as new data cubes
% 
% % Moved to another file
% 
% % multibandwrite(reduced_hsi_image,'reduced_hsi_image.bil','bil');
% % % multibandwrite(reduced_hsi_image_min_max,'reduced_hsi_image_min.bil','bil');
% % multibandwrite(reduced_hsi_image_mul_stp,'reduced_hsi_image_mul_stp.bil','bil');
% % multibandwrite(reduced_hsi_image_pca,'reduced_hsi_image_pca.bil','bil');
% 
% %% Plotting spectral graphs
% 
% % % 
% % X_axis_1 = linspace(0,desired_bands,desired_bands);
% % Y_axis_1 = linspace(0,desired_bands,desired_bands);
% % 
% % X_axis_2 = linspace(0,desired_bands,desired_bands);
% % Y_axis_2 = linspace(0,desired_bands,desired_bands);
% % 
% % X_axis_3 = linspace(0,204,204);
% % Y_axis_3 = linspace(0,204,204);
% % 
% % % Plot all the graphs in same figure.
% % figure();
% % subplot(3,1,1);
% % 
% % for i = 1:2 %(green_cols * green_row)
% %     hold on
% %     for j = 1:10
% %         for k = 1: desired_bands
% %             Y_axis_1(1,k) = hhh_1(i,j,k);
% %         end
% %         plot(X_axis_1, Y_axis_1);
% %     end
% % end
% % title('Graph with single max pooling');
% % 
% % hold off
% % 
% % subplot(3,1,2);
% % 
% % for i = 1:2 %(green_cols * green_row)
% %     hold on
% %     for j = 1:10
% %         for k = 1: desired_bands
% %             Y_axis_2(1,k) = hhh_2(i,j,k);
% %         end
% %         plot(X_axis_2, Y_axis_2);
% %     end
% % end
% % title('Graph with min max pooling');     %% same as for multi step
% % hold off
% % 
% % subplot(3,1,3);
% % 
% % for i = 1:2 %(green_cols * green_row)
% %     hold on
% %     for j = 1:10
% %         for k = 1: 204
% %             Y_axis_3(1,k) = hhh(i,j,k);
% %         end
% %         plot(X_axis_3, Y_axis_3);
% %     end
% % end
% % title('Graph with original data');
% % hold off
% 
% 
