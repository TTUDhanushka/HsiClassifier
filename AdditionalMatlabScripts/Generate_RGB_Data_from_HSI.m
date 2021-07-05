% Generate RGB versions from HSI images.

hsiToRgbManifoldDatasetGen = true;

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

Hsi_Convert_RGB = 'HSI_RGB';
hsiToRgbImageFolder512_512 = fullfile(root, Hsi_Convert_RGB, imageFolder);

% check for the number of images in the folder.
noOfRgbImgs = length(highResRGBImageList) - 2;
noOf_9_bandImgHdr = length(Hsi_9_bandImagelist) - 2;

noOf_9_bandImg = noOf_9_bandImgHdr / 2;

if ~(noOf_9_bandImg == noOfRgbImgs)
    disp('Error: Number of images in each folder are different.');
end

bHsiImage = false;
bRgbImage = false;

convertedFilesList = dir(hsiToRgbImageFolder512_512);
noOfConvertedFiles = length(convertedFilesList);

if noOfConvertedFiles == 0
    noOfConvertedFiles = 1;
else
    noOfConvertedFiles = noOfConvertedFiles + 1;
end
 
for nFileId = noOfConvertedFiles: 10 %noOf_9_bandImg
    
    if (nFileId > 2)        % Skip fist two file names as they are '.' and '..'
        
        % 9 Bands HSI image
        hsiId = ((nFileId - 2) * 2) + 1;
        
        if (~strcmp(Hsi_9_bandImagelist(hsiId).name, '.') && ~strcmp(Hsi_9_bandImagelist(hsiId).name, '..') && contains(Hsi_9_bandImagelist(hsiId).name, '.dat'))
                        
            hsi_9_Path = fullfile(Hsi_9_bandImagePath, Hsi_9_bandImagelist(hsiId).name);            
            
            hsiCubeData = hypercube(hsi_9_Path);
            
            bHsiImage = true;
        end
        
        % RGB high res image.
        if (~strcmp(highResRGBImageList(nFileId).name, '.') && ~strcmp(highResRGBImageList(nFileId).name, '..'))
            
            rgbFullPath = fullfile(rgbHighResPath, highResRGBImageList(nFileId).name);
            
            higResRgb = imread(rgbFullPath);
            
            bRgbImage = true;
        end
    end
    
    if (bHsiImage && bRgbImage)
        
        % Manifold alignment from HSI to RGB.
        SemiSupervisedManifoldAlignment;

        % perform manifold alignment to generate RGB
        Hsi_Rgb_manifold_alignment;

        % Save image to the RGB images folder.
        imageName = highResRGBImageList(nFileId).name;

        rgbFromHsiPath = fullfile(hsiToRgbImageFolder512_512, imageName);
        imwrite(imageGen, rgbFromHsiPath);
    end
end

%% clear variables 




