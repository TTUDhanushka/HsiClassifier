% Copy RGB images from datacube folders to the RGB segmentation dataset.
% The RGB files of 625 x 625 resolution and its labels will be used to do
% comparison for the HSI based RGB segmentation. This data need to be
% collected to separate folder

HsiDatasetFolderName = 'HSI Dataset';
RGB_Dataset_specim = 'RGB_625_625';
RGB_Dataset_Hsi = 'HSI_RGB';

Hsi_9_Folder = 'HSI_9_Bands';
Hsi_16_Folder = 'HSI_16_Bands';
Hsi_25_Folder = 'HSI_25_Bands';

imageFolder = 'images';
labelsFolder = 'labels';

png_ext = '.png';
reflectance_data_ext = '.dat';

bDatasetFolder = false;
bRGBFolder = false;                         % For 645x645 px RGB images from specim RGB sensor.
bRGB_images_labels = false;
bHsiRgbFolder = false;                      % For HSI to RGB conversion and NN training
bHsiRgb_images_labels = false;

root = uigetdir;

rgbImageFolder625_625 = '';
rgbLabelsFolder625_625 = '';

hsiToRgbImageFolder512_512 = '';
hsiToRgbLabelsFolder512_512 = '';

Hsi_9_bandImageFolder = '';
Hsi_9_bandLabelsFolder = '';

Hsi_16_bandImageFolder = '';
Hsi_16_bandLabelsFolder = '';

Hsi_25_bandImageFolder = '';
Hsi_25_bandLabelsFolder = '';


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
        hsiToRgbDataPath = fullfile(root, RGB_Dataset_Hsi);
                
        %% RGB Folders with training images / labels
        
        if (~bRGBFolder && contains(filesList(nFiles).name, RGB_Dataset_specim))
            bRGBFolder = true;
            rgbDataList = dir(rgbDataPath);
            
            for rgbFolders = 1:length(rgbDataList)
                if (~contains(rgbDataList(rgbFolders).name, imageFolder) || (~bRGB_images_labels))
                    mkdir(rgbDataPath, imageFolder);
                    mkdir(rgbDataPath, labelsFolder);
                    
                    bRGB_images_labels = true;
                    
                    rgbImageFolder625_625 = fullfile(rgbDataPath, imageFolder);
                    rgbLabelsFolder625_625 = fullfile(rgbDataPath, labelsFolder);
                end
                
                if bRGB_images_labels
                    break;
                end
            end
            
        else
            disp("No RGB dataset folder");
            
            % Create directory if it doesnt exist.
            mkdir(root, RGB_Dataset_specim);
            mkdir(rgbDataPath, imageFolder);
            mkdir(rgbDataPath, labelsFolder);
            
            rgbImageFolder625_625 = fullfile(rgbDataPath, imageFolder);
            rgbLabelsFolder625_625 = fullfile(rgbDataPath, labelsFolder);
            
            bRGBFolder = true;
            bRGB_images_labels = true;

        end
      
        %% HSI to RGB converted images and labels
        
        if (~bHsiRgbFolder && contains(filesList(nFiles).name, RGB_Dataset_Hsi))
            bHsiRgbFolder = true;
            hsiToRgbDataList = dir(rgbDataPath);
            
            for hsiToFolders = 1:length(hsiToRgbDataList)
                if (~contains(hsiToRgbDataList(hsiToFolders).name, imageFolder) || (~bHsiRgb_images_labels))
                    mkdir(hsiToRgbDataPath, imageFolder);
                    mkdir(hsiToRgbDataPath, labelsFolder);
                    
                    bHsiRgb_images_labels = true;
                    
                    hsiToRgbImageFolder512_512 = fullfile(hsiToRgbDataPath, imageFolder);
                    hsiToRgbLabelsFolder512_512 = fullfile(hsiToRgbDataPath, labelsFolder);
                end
                
                if bHsiRgb_images_labels
                    break;
                end
            end
            
        else
            disp("No RGB from HSI dataset folder");
            
            % Create directory if it doesnt exist.
            mkdir(root, RGB_Dataset_Hsi);
            mkdir(hsiToRgbDataPath, imageFolder);
            mkdir(hsiToRgbDataPath, labelsFolder);
            
            hsiToRgbImageFolder512_512 = fullfile(hsiToRgbDataPath, imageFolder);
            hsiToRgbLabelsFolder512_512 = fullfile(hsiToRgbDataPath, labelsFolder);
            
            bHsiRgbFolder = true;
            bHsiRgb_images_labels = true;

        end
        
        %% HSI 9 band images
        
        
        %% 
        
        % Go into the datacube folder and pick the dataCubes.
        
        for cubeId = 1 : length(dataCubesList)
            
            datacubePath = fullfile(dataSetPath, dataCubesList(cubeId).name);
            resultsList = dir(datacubePath);
            
            for nResultsFile = 1: length(resultsList)
                % Results folder contains reflectances.
                if contains(resultsList(nResultsFile).name, 'results')

                    str_temp = fullfile(datacubePath, resultsList(nResultsFile).name);
                    results_file_struct = dir(str_temp);

                    results_file_list = strings(length(results_file_struct), 1);

                    for idx = 1:length(results_file_struct)
                        results_file_list(idx) = results_file_struct(idx).name;

                        if (contains(results_file_struct(idx).name, 'RGBBACKGROUND') && ...
                                contains(results_file_struct(idx).name, png_ext) && ...
                                (contains(results_file_struct(idx).name, 'GT') || contains(results_file_struct(idx).name, 'gt')))

                            rgbLabels = strcat(str_temp, '\', results_file_struct(idx).name);
                            copyfile (rgbLabels, rgbLabelsFolder625_625, 'f');
                            
                        elseif (contains(results_file_struct(idx).name, 'RGBBACKGROUND') && ...
                                contains(results_file_struct(idx).name, png_ext) && ...
                                (~contains(results_file_struct(idx).name, 'GT') || ~contains(results_file_struct(idx).name, 'gt')))

                            rgbHighRes = strcat(str_temp, '\', results_file_struct(idx).name);
                            
                            copyfile (rgbHighRes, rgbImageFolder625_625, 'f');
                        end

                    end

                end
            end
        end
    end
    
    if (~bDatasetFolder) && (nFiles == length(filesList))
        disp("No dataset folder");
        return;
    end
end

%% Clear variables

vars = {'nFiles','filesList', 'bDatasetFolder', 'rgbHighRes'};

clear(vars{:})







