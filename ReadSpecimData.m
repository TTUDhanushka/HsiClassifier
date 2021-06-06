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


%% Import data

% Image source is the camera type.
image_source = 'specim';

if classifyingLargeDataSet
    % get the path from workspace. Only for large datasets.
    directory_path = hsiImagePath;
    directory_path = strcat(directory_path,'\');   
else
    directory_path = uigetdir;
    directory_path = strcat(directory_path,'\');    
end


%% Get the data file paths from the data directory.

% RGB preview file
rgb_file = '';
header_file = '';
hsi_file = '';

% [rgb_file, header_file, hsi_file, white_ref_file,...
%     white_ref_hdr, dark_ref_file, dark_ref_hdr, reflectance_cube_file] = GetDataFiles(directory_path);

[rgb_file, header_file, hsi_file, dark_ref_file, dark_ref_hdr, ...
     white_ref_file, white_ref_hdr, reflectance_cube, reflectance_hdr,...
     ground_truth_File, simul_white_ref, highResRgbPath] = GetDataFiles_V2(directory_path);

% Get the header data
[cols, lines, bands, wave] = ReadHeader(header_file, image_source);

%% Get the preview RGB image.

%
%   This image is from the RGB camera on top of the Specim spectral
%   imaging sensor. This view and actual false RGB of HSI are not
%   necessarily matching.
%

rgb_image = imread(rgb_file);

% Display the RGB preview image
if ~(rgb_file == "")
    subplot(2,2,1), imshow(rgb_image)
    %set(gcf,'position',[10,10,1600,800]);
    title('PNG file from Specim');
end

%% Get the datacube, white reference and dark reference cubes and calibrate.

% image = multibandread('tst0012.fits', [31 73 5], ...
%                     'int16', 74880, 'bil', 'ieee-be', ...
%                     {'Band', 'Range', [1 3]} );

hsi_cube = multibandread(hsi_file, [cols lines bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

dark_ref_cube = multibandread(dark_ref_file, [cols 1 bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

% White ref cube only u for pre-calibrated images
if (simul_white_ref)
    white_ref_cube = multibandread(white_ref_file, [cols 1 bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

    % perform calibration with white dark reference (white_ref_cube is actually contains white dark ref).
    [correctd_hsi_cube, error] = Calibrate_Spectral_Image(hsi_cube, white_ref_cube,...
        dark_ref_cube, rgb_image, simul_white_ref);
else
    % For simultaneous white referenced images, send a dummy data cube as
    % white reference.
    [dummy_h, dummy_w, dummy_d] = size(dark_ref_cube);
    
    white_ref_cube = zeros(dummy_h, dummy_w, dummy_d);
    
    [correctd_hsi_cube, error] = Calibrate_Spectral_Image(hsi_cube, white_ref_cube,...
    dark_ref_cube, rgb_image, simul_white_ref);
end

% RGB reconstruction from HSI data cube. The bands were selected manually.
rgb_from_corrected = ConstructRgbImage(correctd_hsi_cube, 28, 58, 85);

reflectanceCube = hypercube(reflectance_cube);

% RGB reconstruction from reflectance data cube. The bands were selected manually.
rgb_from_ref = ConstructRgbImage(reflectanceCube.DataCube, 28, 58, 85);

rgb_from_corrected = imrotate(rgb_from_corrected, -90);
subplot(2,2,2), imshow(rgb_from_corrected);
title('Reconstructed image from white calib');

rgb_from_ref = imrotate(rgb_from_ref, -90);
subplot(2,2,3), imshow(rgb_from_ref);
title('Reconstructed image from reflectance');


%% Get the ground truth image

fileList = dir(directory_path);
groundTruthExist = false;

for fileId = 1 : length(fileList)
    if ((contains(fileList(fileId).name, 'gt') || contains(fileList(fileId).name, 'GT')) && contains(fileList(fileId).name, '.png'))
        groundTruthFileName = fileList(fileId).name;
        
        groundTruthFilePath = strcat(directory_path, groundTruthFileName);
        
        groundTruthImage = imread(groundTruthFilePath);
        
        subplot(2,2,4), imshow(groundTruthImage);
        title('Manually labeled ground truth.');
    end
end

higResRgb = imread(highResRgbPath);
higResRgbRot = imrotate(higResRgb, 90);


%% Clean up workspace.

clear image_source  header_file fileId fileList white_ref_cube white_ref_file white_ref_hdr ...
    dark_ref_cube dark_ref_file dark_ref_hdr







 
