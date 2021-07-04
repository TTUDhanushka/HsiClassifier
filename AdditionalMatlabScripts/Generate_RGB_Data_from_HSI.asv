% Generate RGB versions from HSI images.

% 'root' variable contains root of the image data folder.
if ~exist('root', 'var')
    root = uigetdir;
end

imageFolder = 'images';

% RGB Image from Specim RGB image data folder.
RGB_Dataset_specim = 'RGB_625_625';
rgbHighResPath = fullfile(root, RGB_Dataset_specim, imageFolder);

highResRGBImageList = dir(rgbHighResPath);

% 9 Bands HSI data from HSI data folder.
HSI_9bands_Dataset = 'HSI_9_Bands';
Hsi_9_bandImagePath = fullfile(root, HSI_9bands_Dataset, imageFolder);

Hsi_9_bandImagelist = dir(Hsi_9_bandImagePath);

% check for the number of images in the folder.
noOfRgbImgs = length(highResRGBImageList) - 2;
noOf_9_bandImgHdr = length(Hsi_9_bandImagelist) - 2;

noOf_9_bandImg = noOf_9_bandImgHdr / 2;

if ~(noOf_9_bandImg == noOfRgbImgs)
    disp('Error: Number of images in each folder are different.');
end

 
for nHsi_9_image = 1: noOf_9_bandImg
     
    if (~strcmp(Hsi_9_bandImagelist(nHsi_9_image).name, '.') && ~strcmp(Hsi_9_bandImagelist(nHsi_9_image).name, '..') && contains(Hsi_9_bandImagelist(nHsi_9_image).name, '.dat'))
        
        hsi_9_Path = fullfile(Hsi_9_bandImagePath, Hsi_9_bandImagelist(nHsi_9_image).name);
        
        hsiCubeData = hypercube(hsi_9_Path);
    end
end

%% 


% Manifold alignment from HSI to RGB.
SemiSupervisedManifoldAlignment;

% perform manifold alignment to generate RGB
Hsi_Rgb_manifold_alignment;

% Save image to the RGB images folder.
% imageName = 
% 
% rgbFromHsiPath = fullfile(hsiToRgbImageFolder512_512, );
% imwrite(imageGen, rgbFromHsiPath);