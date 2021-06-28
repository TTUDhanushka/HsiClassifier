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
bHsi_9_Folder = false;
bHsi_16_Folder = false;
bHsi_25_Folder = false;
bHsi_9_images_labels = false;
bHsi_16_images_labels = false;
bHsi_25_images_labels = false;

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
        hsi_9_bandsDataPath = fullfile(root, Hsi_9_Folder);
        hsi_16_bandsDataPath = fullfile(root, Hsi_16_Folder);
        hsi_25_bandsDataPath = fullfile(root, Hsi_25_Folder);
        
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
        
        if (~bHsi_9_Folder && contains(filesList(nFiles).name, Hsi_9_Folder))
           bHsi_9_Folder = true; 
           
           bHsi_9_DirList = dir(hsi_9_bandsDataPath);
           
           for nHsi_9_Folder = 1: length(bHsi_9_DirList)
               if (~contains(nHsi_9_Folder(nHsi_9_Folder).name, imageFolder) || (~bHsi_9_images_labels))
                   mkdir(hsi_9_bandsDataPath, imageFolder);
                   mkdir(hsi_9_bandsDataPath, labelsFolder);
                   
                   bHsi_9_images_labels = true;
                   
                   Hsi_9_bandImageFolder = fullfile(hsi_9_bandsDataPath, imageFolder);
                   Hsi_9_bandLabelsFolder = fullfile(hsi_9_bandsDataPath, labelsFolder);
               end
               
               if bHsi_9_images_labels
                   break;
               end
           end
           
        else
            disp("No data folders for 9 band HSI dataset.")
           
            mkdir(root, Hsi_9_Folder);
            mkdir(hsi_9_bandsDataPath, imageFolder);
            mkdir(hsi_9_bandsDataPath, labelsFolder);
            
            bHsi_9_Folder = true;
            bHsi_9_images_labels = true;
            
            Hsi_9_bandImageFolder = fullfile(hsi_9_bandsDataPath, imageFolder);
            Hsi_9_bandLabelsFolder = fullfile(hsi_9_bandsDataPath, labelsFolder);
        end
        
        %% HSI 16 band images
        
        if (~bHsi_16_Folder && contains(filesList(nFiles).name, Hsi_16_Folder))
           bHsi_16_Folder = true; 
           
           bHsi_16_DirList = dir(hsi_16_bandsDataPath);
           
           for nHsi_16_Folder = 1: length(bHsi_16_DirList)
               if (~contains(nHsi_16_Folder(nHsi_16_Folder).name, imageFolder) || (~bHsi_16_images_labels))
                   mkdir(hsi_16_bandsDataPath, imageFolder);
                   mkdir(hsi_16_bandsDataPath, labelsFolder);
                   
                   bHsi_16_images_labels = true;
                   
                   Hsi_16_bandImageFolder = fullfile(hsi_16_bandsDataPath, imageFolder);
                   Hsi_16_bandLabelsFolder = fullfile(hsi_16_bandsDataPath, labelsFolder);
               end
               
               if bHsi_16_images_labels
                   break;
               end
           end
           
        else
            disp("No data folders for 16 band HSI dataset.")
           
            mkdir(root, Hsi_16_Folder);
            mkdir(hsi_16_bandsDataPath, imageFolder);
            mkdir(hsi_16_bandsDataPath, labelsFolder);
            
            bHsi_16_Folder = true;
            bHsi_16_images_labels = true;
            
            Hsi_16_bandImageFolder = fullfile(hsi_16_bandsDataPath, imageFolder);
            Hsi_16_bandLabelsFolder = fullfile(hsi_16_bandsDataPath, labelsFolder);
        end
        
        %% HSI 25 band images
        
        if (~bHsi_25_Folder && contains(filesList(nFiles).name, Hsi_25_Folder))
           bHsi_25_Folder = true; 
           
           bHsi_25_DirList = dir(hsi_25_bandsDataPath);
           
           for nHsi_25_Folder = 1: length(bHsi_25_DirList)
               if (~contains(nHsi_25_Folder(nHsi_25_Folder).name, imageFolder) || (~bHsi_25_images_labels))
                   mkdir(hsi_25_bandsDataPath, imageFolder);
                   mkdir(hsi_25_bandsDataPath, labelsFolder);
                   
                   bHsi_25_images_labels = true;
                   
                   Hsi_25_bandImageFolder = fullfile(hsi_25_bandsDataPath, imageFolder);
                   Hsi_25_bandLabelsFolder = fullfile(hsi_25_bandsDataPath, labelsFolder);
               end
               
               if bHsi_25_images_labels
                   break;
               end
           end
           
        else
            disp("No data folders for 25 band HSI dataset.")
           
            mkdir(root, Hsi_25_Folder);
            mkdir(hsi_25_bandsDataPath, imageFolder);
            mkdir(hsi_25_bandsDataPath, labelsFolder);
            
            bHsi_25_Folder = true;
            bHsi_25_images_labels = true;
            
            Hsi_25_bandImageFolder = fullfile(hsi_25_bandsDataPath, imageFolder);
            Hsi_25_bandLabelsFolder = fullfile(hsi_25_bandsDataPath, labelsFolder);
        end
        

        
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







