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

png_ext = '.png';
reflectance_data_ext = '.dat';

bDatasetFolder = false;
bRGBFolder = false;
bRGB_images_labels = false;

root = uigetdir;

rgbImageFolder625_625 = '';
rgbLabelsFolder625_625 = '';

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
                    
                    rgbImageFolder625_625 = fullfile(rgbDataPath, imageFolder);
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
            
            bRGBFolder = true;
            bRGB_images_labels = true;
            break;
        end
      
        % Go into the datacube folder and pick the dataCubes.
        
        for cubeId = 1 : length(dataCubesList)
            
%             % get the ground truth of RGB scene
%             if (contains(file_list(i).name, '.png') && ~(contains(file_list(i).name, 'gt'))&& ~(contains(file_list(i).name, 'GT')))
%                 rgb_file_name = file_list(i).name;
%                 rgb_file = fullfile (directory_path, rgb_file_name);
%             elseif (contains(file_list(i).name, '.png') && ((contains(file_list(i).name, 'gt')) || (contains(file_list(i).name, 'GT'))))
%                 ground_truth_File = file_list(i).name;
%             end
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

                        if (contains(results_file_struct(idx).name, png_ext) && contains(results_file_struct(idx).name, 'gt'))

                            hsi_labels = strcat(str_temp, '\', results_file_struct(idx).name);

                        elseif (contains(results_file_struct(idx).name, 'RGBBACKGROUND') && (contains(results_file_struct(idx).name, 'GT') || contains(results_file_struct(idx).name, 'gt')))

                            rgbLabels = strcat(str_temp, '\', results_file_struct(idx).name);
                            copyfile (rgbLabels, rgbLabelsFolder625_625, 'f');
                            
                        elseif (contains(results_file_struct(idx).name, 'RGBBACKGROUND') && (~contains(results_file_struct(idx).name, 'GT') || ~contains(results_file_struct(idx).name, 'gt')))

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







