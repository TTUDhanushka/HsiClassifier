% Copy RGB images from datacube folders to the RGB segmentation dataset.
% The RGB files of 625 x 625 resolution and its labels will be used to do
% comparison for the HSI based RGB segmentation. This data need to be
% collected to separate folder

HsiDatasetFolderName = 'HSI Dataset';
RGB_Dataset_specim = 'RGB_625_625';
RGB_640_Dataset = 'RGB_640_640';
RGB_Dataset_Hsi = 'HSI_RGB';

Hsi_9_Folder = 'HSI_9_Bands';
Hsi_16_Folder = 'HSI_16_Bands';
Hsi_25_Folder = 'HSI_25_Bands';

imageFolder = 'images';
labelsFolder = 'labels';

png_ext = '.png';
reflectance_data_ext = '.hdr';

bDatasetFolder = false;
bRGBFolder = false;                         % For 645x645 px RGB images from specim RGB sensor.
bRGB_images_labels = false;
bRgb640_Folder = false;                     % For RGB 640 x 640 px images for UNet
bRgb640_images_labels = false;
bHsiRgbFolder = false;                      % For HSI to RGB conversion and NN training
bHsiRgb_images_labels = false;
bHsi_9_Folder = false;
bHsi_16_Folder = false;
bHsi_25_Folder = false;
bHsi_9_images_labels = false;
bHsi_16_images_labels = false;
bHsi_25_images_labels = false;

bMetaUpdate = false;
bWavelengthUpdate = false;

bMetaUpdate_16 = false;
bWavelengthUpdate_16 = false;

bMetaUpdate_25 = false;
bWavelengthUpdate_25 = false;

root = uigetdir;

rgbImageFolder625_625 = '';
rgbLabelsFolder625_625 = '';

rgbImageFolder640_640 = '';
rgbLabelsFolder640_640 = '';

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
        
        rgbDataPath = fullfile(root, RGB_Dataset_specim);                   % For RGB original images of 645 x 645 px resolution.
        rgb640_DataPath = fullfile(root, RGB_640_Dataset);                  % For UNet classifier.
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
        
        %% RGB 640 x 640 px Folders with training images / labels
        
        if (~bRgb640_Folder && contains(filesList(nFiles).name, RGB_640_Dataset))
            bRgb640_Folder = true;
            rgb_640_DataList = dir(rgb640_DataPath);
            
            for rgb640_Folders = 1:length(rgb_640_DataList)
                if (~contains(rgb_640_DataList(rgb640_Folders).name, imageFolder) || (~bRgb640_images_labels))
                    mkdir(rgb640_DataPath, imageFolder);
                    mkdir(rgb640_DataPath, labelsFolder);
                    
                    bRgb640_images_labels = true;
                    
                    rgbImageFolder640_640 = fullfile(rgb640_DataPath, imageFolder);
                    rgbLabelsFolder640_640 = fullfile(rgb640_DataPath, labelsFolder);
                end
                
                if bRgb640_images_labels
                    break;
                end
            end
            
        else
            disp("No RGB 640 x 640 px dataset folder");
            
            % Create directory if it doesnt exist.
            mkdir(root, RGB_640_Dataset);
            mkdir(rgb640_DataPath, imageFolder);
            mkdir(rgb640_DataPath, labelsFolder);
            
            rgbImageFolder640_640 = fullfile(rgb640_DataPath, imageFolder);
            rgbLabelsFolder640_640 = fullfile(rgb640_DataPath, labelsFolder);
            
            bRgb640_Folder = true;
            bRgb640_images_labels = true;

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
        

        
        %% Data copying
        
        % Go into the datacube folder and pick the dataCubes.
        
        for cubeId = 1 : length(dataCubesList)
            
            datacubePath = fullfile(dataSetPath, dataCubesList(cubeId).name);
            resultsList = dir(datacubePath);
            
            label640 = zeros(640, 640, 3, 'uint8');
            images640 = zeros(640, 640, 3, 'uint8');
            
            for nResultsFile = 1: length(resultsList)
                % Results folder contains reflectances.
                if contains(resultsList(nResultsFile).name, 'results')

                    str_temp = fullfile(datacubePath, resultsList(nResultsFile).name);
                    results_file_struct = dir(str_temp);

                    results_file_list = strings(length(results_file_struct), 1);

                    for idx = 1:length(results_file_struct)
                        results_file_list(idx) = results_file_struct(idx).name;

                        % RGB Images copying.
                        if (contains(results_file_struct(idx).name, 'RGBBACKGROUND') && ...
                                contains(results_file_struct(idx).name, png_ext) && ...
                                (contains(results_file_struct(idx).name, 'GT') || contains(results_file_struct(idx).name, 'gt')))

                            rgbLabels = strcat(str_temp, '\', results_file_struct(idx).name);
                            copyfile (rgbLabels, rgbLabelsFolder625_625, 'f');
                            
                            labelRGB = imread(rgbLabels);
                            
                            for iL = 1: 640
                                for jL = 1:640
                                    label640(iL,jL,:) = labelRGB(iL,jL,:);
                                end
                            end
                            
                            labelPath_640 = strcat(rgbLabelsFolder640_640, '\', results_file_struct(idx).name);
                            
                            imwrite (label640, labelPath_640);
                            
                        elseif (contains(results_file_struct(idx).name, 'RGBBACKGROUND') && ...
                                contains(results_file_struct(idx).name, png_ext) && ...
                                (~contains(results_file_struct(idx).name, 'GT') || ~contains(results_file_struct(idx).name, 'gt')))

                            rgbHighRes = strcat(str_temp, '\', results_file_struct(idx).name);
                            
                            copyfile (rgbHighRes, rgbImageFolder625_625, 'f');
                            
                            imageRGB = imread(rgbHighRes);
                            
                            for iR = 1: 640
                                for jR = 1:640
                                    images640(iR,jR,:) = imageRGB(iR,jR,:);
                                end
                            end
                            
                            rgbPath_640 = strcat(rgbImageFolder640_640, '\', results_file_struct(idx).name);
                            imwrite (images640, rgbPath_640);
                        end
                        
                        % HSI to RGB Images copying.
                        if (contains(results_file_struct(idx).name, 'REFLECTANCE') && ...
                                contains(results_file_struct(idx).name, png_ext) && ...
                                (contains(results_file_struct(idx).name, 'GT') || contains(results_file_struct(idx).name, 'gt')))
                            
                            hsiToRgbLabels = strcat(str_temp, '\', results_file_struct(idx).name);
                            copyfile (hsiToRgbLabels, hsiToRgbLabelsFolder512_512, 'f');
                            
                            % Copy labels to HSI folders.
                            copyfile (hsiToRgbLabels, Hsi_9_bandLabelsFolder, 'f');
                            copyfile (hsiToRgbLabels, Hsi_16_bandLabelsFolder, 'f');
                            copyfile (hsiToRgbLabels, Hsi_25_bandLabelsFolder, 'f');
                            
                        elseif (contains(results_file_struct(idx).name, 'REFLECTANCE') && ...
                                contains(results_file_struct(idx).name, png_ext) && ...
                                (~contains(results_file_struct(idx).name, 'GT') || ~contains(results_file_struct(idx).name, 'gt')))
                            
%                             This should be coming from manifold alignment
%                             method which used to generate RGB images from
%                             HSI.
                        end
                        
                        % Copy the reduced HSI datacube in ENVI format.
                        if exist('bSet_9', 'var')
                            bandCount = 9;
                            
                            if (contains(results_file_struct(idx).name, 'REFLECTANCE') && ...
                                    contains(results_file_struct(idx).name, reflectance_data_ext))
                                
                                hsiFileFullPath = strcat(str_temp, '\', results_file_struct(idx).name);
                                
                                hsiData = hypercube(hsiFileFullPath);
                                reducedCube = ReducedBandImage(hsiData.DataCube, bSet_9);
                                
                                if ~bMetaUpdate
                                    meta = hsiData.Metadata;
                                    meta.Bands = bandCount;
                                    bMetaUpdate = true;
                                end
                                
                                if ~bWavelengthUpdate
                                    
                                    waveSet = zeros(bandCount, 1, 'double');
                                    
                                    for nWave = 1:bandCount                                        
                                        waveSet(nWave, 1) = hsiData.Wavelength(bSet_9(nWave));
                                    end
                                    
                                    bWavelengthUpdate = true;
                                end
                                
                                filename = fullfile(Hsi_9_bandImageFolder,results_file_struct(idx).name); 
                                
                                reducedHyperCube = hypercube (reducedCube, waveSet, meta);
                                
                                enviwrite(reducedHyperCube, filename);
                                
                                clear hsiData reducedCube filename hsiFileFullPath;
                            end

                        else
                            disp("Band list isn't available in the workspace.");
                        end
                        
                        % HSI 16 bands datacube in ENVI format.
                        if exist('bSet_16', 'var')
                            bandCount_16 = 16;
                            
                            if (contains(results_file_struct(idx).name, 'REFLECTANCE') && ...
                                    contains(results_file_struct(idx).name, reflectance_data_ext))
                                
                                hsiFileFullPath = strcat(str_temp, '\', results_file_struct(idx).name);
                                
                                hsiData = hypercube(hsiFileFullPath);
                                reducedCube_16 = ReducedBandImage(hsiData.DataCube, bSet_16);
                                
                                if ~bMetaUpdate_16
                                    meta = hsiData.Metadata;
                                    meta.Bands = bandCount_16;
                                    bMetaUpdate_16 = true;
                                end
                                
                                if ~bWavelengthUpdate_16
                                    
                                    waveSet_16 = zeros(bandCount_16, 1, 'double');
                                    
                                    for nWaveBand16 = 1:bandCount_16                                        
                                        waveSet_16(nWaveBand16, 1) = hsiData.Wavelength(bSet_16(nWaveBand16));
                                    end
                                    
                                    bWavelengthUpdate_16 = true;
                                end
                                
                                filename = fullfile(Hsi_16_bandImageFolder,results_file_struct(idx).name); 
                                
                                reducedHyperCube_16 = hypercube (reducedCube_16, waveSet_16, meta);
                                
                                enviwrite(reducedHyperCube_16, filename);
                                
                                clear hsiData reducedCube_16 filename hsiFileFullPath;
                            end

                        else
                            disp("Band list isn't available in the workspace.");
                        end
                        
                        % HSI 16 bands datacube in ENVI format.
                        if exist('bSet_25', 'var')
                            bandCount_25 = 25;
                            
                            if (contains(results_file_struct(idx).name, 'REFLECTANCE') && ...
                                    contains(results_file_struct(idx).name, reflectance_data_ext))
                                
                                hsiFileFullPath = strcat(str_temp, '\', results_file_struct(idx).name);
                                
                                hsiData = hypercube(hsiFileFullPath);
                                reducedCube_25 = ReducedBandImage(hsiData.DataCube, bSet_25);
                                
                                if ~bMetaUpdate_25
                                    meta = hsiData.Metadata;
                                    meta.Bands = bandCount_25;
                                    bMetaUpdate_25 = true;
                                end
                                
                                if ~bWavelengthUpdate_25
                                    
                                    waveSet_25 = zeros(bandCount_25, 1, 'double');
                                    
                                    for nWaveBand25 = 1:bandCount_25                                        
                                        waveSet_25(nWaveBand25, 1) = hsiData.Wavelength(bSet_25(nWaveBand25));
                                    end
                                    
                                    bWavelengthUpdate_25 = true;
                                end
                                
                                filename = fullfile(Hsi_25_bandImageFolder,results_file_struct(idx).name); 
                                
                                reducedHyperCube_25 = hypercube (reducedCube_25, waveSet_25, meta);
                                
                                enviwrite(reducedHyperCube_25, filename);
                                
                                clear hsiData reducedCube_16 filename hsiFileFullPath;
                            end

                        else
                            disp("Band list isn't available in the workspace.");
                        end
                    end
                    
                else
                    disp("No results folder.");
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







