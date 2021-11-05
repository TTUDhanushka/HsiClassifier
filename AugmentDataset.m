%
%   This script will create an augmented image dataset by flipping and
%   rotating images. It will multiply the number of images in the dataset
%   by four.
%

% Options

    DataType = 'RGB';      % RGB, HSI
%

ImagesDir = 'images';
LabelDir = 'labels';
HsiDataFIleExt = '.dat';
LblDataFileExt = '.png';

% Get the dataset folder
dataSetDir = uigetdir();

dirList = dir(dataSetDir);

for nFile = 1: length(dirList)
    if contains(ImagesDir, dirList(nFile).name)
        imagesDir = fullfile(dataSetDir, dirList(nFile).name);
    elseif contains(LabelDir, dirList(nFile).name)
        labelsDir = fullfile(dataSetDir, dirList(nFile).name);
    end
end
 
% Augment images 

if strcmp(DataType, 'RGB')
    rgbDatFilesList = dir(imagesDir);
    
    noOfRgbFiles = length(rgbDatFilesList) - 2;
    rgbFiles = strings(noOfRgbFiles, 1);

    rgbFileCount = 1;
    
    for nRgbImg = 1: length(rgbDatFilesList)
        if contains(rgbDatFilesList(nRgbImg).name, LblDataFileExt)
            rgbFiles(rgbFileCount, 1) = fullfile(imagesDir, rgbDatFilesList(nRgbImg).name);
            rgbFileCount = rgbFileCount + 1;
        end
    end
    
    for nRgbImgFile = 1: length(rgbFiles)
        rgbImgTemp = imread(rgbFiles(nRgbImgFile, 1));
        fNameWoExtRgb = erase(rgbFiles(nRgbImgFile, 1), LblDataFileExt);
        
        %rotatedClkFileNameLbl = strcat(fNameWoExtLbl, '_clk', '.png');
        FlpdFileNameRgb = strcat(fNameWoExtRgb, '_flp', '.png');
        %rotatedClkFlpFileNameLbl = strcat(fNameWoExtLbl, '_clk_flp', '.png');
        
        %rotateClkLbl = imrotate(labelTemp, -90);
        flippedRgbImg = flip(rgbImgTemp, 2);
        %rotateClkFlpdLbl = flip(rotateClkLbl, 1);
        
        %imwrite(rotateClkLbl, rotatedClkFileNameLbl);
        imwrite(flippedRgbImg, FlpdFileNameRgb);
        %imwrite(rotateClkFlpdLbl, rotatedClkFlpFileNameLbl);
    end
    
elseif strcmp(DataType, 'HSI')
    hdrDatFilesList = dir(imagesDir);
    
    noOfFiles = (length(hdrDatFilesList) - 2) / 2;
    
    hsiFiles = strings(noOfFiles, 1);
    
    fileCount = 1;
    
    for nHsi = 1: length(hdrDatFilesList)
        if contains(hdrDatFilesList(nHsi).name, HsiDataFIleExt)
            hsiFiles(fileCount, 1) = fullfile(imagesDir, hdrDatFilesList(nHsi).name);
            fileCount = fileCount + 1;
        end
    end
    
    for nHsiFile = 1: length(hsiFiles)
        hypercubeTemp = hypercube(hsiFiles(nHsiFile, 1));
        fNameWoExt = erase(hsiFiles(nHsiFile, 1), HsiDataFIleExt);
        
        %rotatedClkFileName = strcat(fNameWoExt, '_clk');
        FlpdFileName = strcat(fNameWoExt, '_flp');
        %rotatedClkFlpFileName = strcat(fNameWoExt, '_clk_flp');
        
        %rotateClkHsi = RotateHsiImage(hypercubeTemp.DataCube, -90);
        flippedHsi = FlipHsiImage(hypercubeTemp.DataCube, 'H');
        %rotateClkFlpdHsi = FlipHsiImage(rotateClkHsi, 'H');
        
        %hypercubeTemp = assignData(hypercubeTemp, ':', ':', ':', rotateClkHsi);
        %enviwrite(hypercubeTemp, rotatedClkFileName, 'Interleave','bil');
        
        hypercubeTemp = assignData(hypercubeTemp, ':', ':', ':', flippedHsi);
        enviwrite(hypercubeTemp, FlpdFileName, 'Interleave','bil');
        
        %hypercubeTemp = assignData(hypercubeTemp, ':', ':', ':', rotateClkFlpdHsi);
        %enviwrite(hypercubeTemp, rotatedClkFlpFileName, 'Interleave','bil');
    end
       
end


%% Augment labels

pngLblFilesList = dir(labelsDir);

noOfLblFiles = length(pngLblFilesList) - 2;

lblFiles = strings(noOfLblFiles, 1);

    lblFileCount = 1;
    
    for nLblImg = 1: length(pngLblFilesList)
        if contains(pngLblFilesList(nLblImg).name, LblDataFileExt)
            lblFiles(lblFileCount, 1) = fullfile(labelsDir, pngLblFilesList(nLblImg).name);
            lblFileCount = lblFileCount + 1;
        end
    end
    
    for nLabelFile = 1: length(lblFiles)
        labelTemp = imread(lblFiles(nLabelFile, 1));
        fNameWoExtLbl = erase(lblFiles(nLabelFile, 1), LblDataFileExt);
        
        %rotatedClkFileNameLbl = strcat(fNameWoExtLbl, '_clk', '.png');
        FlpdFileNameLbl = strcat(fNameWoExtLbl, '_flp', '.png');
        %rotatedClkFlpFileNameLbl = strcat(fNameWoExtLbl, '_clk_flp', '.png');
        
        %rotateClkLbl = imrotate(labelTemp, -90);
        flippedLbl = flip(labelTemp, 2);
        %rotateClkFlpdLbl = flip(rotateClkLbl, 1);
        
        %imwrite(rotateClkLbl, rotatedClkFileNameLbl);
        imwrite(flippedLbl, FlpdFileNameLbl);
        %imwrite(rotateClkFlpdLbl, rotatedClkFlpFileNameLbl);
    end
    