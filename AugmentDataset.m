%
%   This script will create an augmented image dataset by flipping and
%   rotating images. It will multiply the number of images in the dataset
%   by four.
%

% Options

    DataType = 'HSI';      % RGB, HSI
%

ImagesDir = 'images';
LabelDir = 'labels';
HsiDataFIleExt = '.dat';

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
 
if strcmp(DataType, 'RGB')
    
elseif strcmp(DataType, 'HSI')
    hdrDatFilesList = dir(imagesDir);
    
    noOfFiles = (length(hdrDatFilesList) - 2) / 2;
    
    hsiFiles = strings(noOfFiles, 1);
    
    fileCount = 1;
    
    for nHsi = 1: length(hdrDatFilesList)
        if contains(hdrDatFilesList(nHsi).name, HsiDataFIleExt)
            hdrDatFilesList(nHsi).name
            hsiFiles(fileCount, 1) = fullfile(imagesDir, hdrDatFilesList(nHsi).name);
            fileCount = fileCount + 1;
        end
    end
    
    for nHsiFile = 1: length(hsiFiles)
        hypercubeTemp = hypercube(hsiFiles(nHsiFile, 1));
        fNemWoExt = erase(hsiFiles(nHsiFile, 1), HsiDataFIleExt);
        
        rotatedClkFileName = strcat(fNemWoExt, '_clk');
        FlpdFileName = strcat(fNemWoExt, '_flp');
        rotatedClkFlpFileName = strcat(fNemWoExt, '_clk_flp');
        
        rotateClkHsi = RotateHsiImage(hypercubeTemp.DataCube, -90);
        flippedHsi = FlipHsiImage(hypercubeTemp.DataCube, 'H');
        rotateClkFlpdHsi = FlipHsiImage(rotateClkHsi, 'H');
        
        hypercubeTemp = assignData(hypercubeTemp, ':', ':', ':', rotateClkHsi);
        enviwrite(hypercubeTemp, rotatedClkFileName, 'Interleave','bil');
        
        hypercubeTemp = assignData(hypercubeTemp, ':', ':', ':', flippedHsi);
        enviwrite(hypercubeTemp, FlpdFileName, 'Interleave','bil');
        
        hypercubeTemp = assignData(hypercubeTemp, ':', ':', ':', rotateClkFlpdHsi);
        enviwrite(hypercubeTemp, rotatedClkFlpFileName, 'Interleave','bil');
    end
       
end

% Rotate HSI datacube by 90 deg clockwise

% Rotate label 90 deg clockwise

