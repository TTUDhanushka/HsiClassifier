% Copy RGB images from datacube folders to the RGB segmentation dataset.
% The RGB files of 625 x 625 resolution and its labels will be used to do
% comparison for the HSI based RGB segmentation. This data need to be
% collected to separate folder

HsiDatasetFolderName = 'HSI Dataset';
RGB_Dataset_specim = 'RGB_625_625';
RGB_Dataset_Hsi = 'HSI_RGB';
Hsi_9_bands = '';
Hsi_16_bands = '';
Hsi_25_bands = '';

imageFolder = 'images';
labelsFolder = 'labels';

bDatasetFolder = false;
bRGBFolder = false;
bRGB_images_labels = false;

root = uigetdir;


if (root == "")
    disp("Root folder not selected.");
    return;
else
    filesList = dir(root);
end

for nFiles = 1: length(filesList)
    if contains(filesList(nFiles).name, HsiDatasetFolderName)
        bDatasetFolder = true;
        
        dataSetPath = fullfile(root, filesList(nFiles).name);
        
        dataCubesList = dir(dataSetPath);
        
        rgbDataPath = fullfile(root, RGB_Dataset_specim);
        
        if (~bRGBFolder || contains(filesList(nFiles).name, RGB_Dataset_specim))
            bRGBFolder = true;
            rgbDataList = dir(rgbDataPath);
            
            for rgbFolders = 1:length(rgbDataList)
                if (~contains(rgbDataList(rgbFolders).name, imageFolder) || (~bRGB_images_labels))
                    mkdir(rgbDataPath, imageFolder);
                    mkdir(rgbDataPath, labelsFolder);
                    
                    bRGB_images_labels = true;
                    break;
                end
            end
            
        else
            disp("No RGB dataset folder");
            
            % Create directory if it doesnt exist.
            mkdir(root, RGB_Dataset_specim);
            mkdir(rgbDataPath, imageFolder);
            mkdir(rgbDataPath, labelsFolder);
            
            bRGBFolder = true;
            bRGB_images_labels = true;
            break;
        end
        
        
    end
    
    if (~bDatasetFolder) && (nFiles == length(filesList))
        disp("No dataset folder");
        return;
    end
end

function [] = CopyRGBImages()
end






