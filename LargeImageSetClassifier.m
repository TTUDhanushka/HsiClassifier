% Run classification for all the images and store RGB image into RGB image 
% folder and classification outcome into two folders. One of them contain 
% class wise and the other will have the colored classification outcome.

%% hard coded places.

RGB_image_folder = 'G:\3. Hyperspectral\5. Matlab HSI\4. RGB Training Images\';
Gt_from_classification_folder = 'G:\3. Hyperspectral\5. Matlab HSI\5. Ground Truth from classification\';
Image_from_classification_folder = 'G:\3. Hyperspectral\5. Matlab HSI\6. Classification Images ALL BANDS\';


%%

% Get all the folders in the HSI dataset folder.
homeDirectory = uigetdir;
homeDirectory = strcat(homeDirectory,'\');

dataFilesList = dir(homeDirectory);

classifyingLargeDataSet = true;

count = 0;

for nDataSet = 1: length(dataFilesList)
    if ~contains(dataFilesList(nDataSet).name, '.') && ~contains(dataFilesList(nDataSet).name, '..')
        count = count + 1
        hsiImagePath = fullfile(homeDirectory, dataFilesList(nDataSet).name);
        
        % Read all the data files.
        ReadSpecimData;
        
        % Convert RGB images.
        CreateTrueColorImage;
        
        % Save RGB images in RGB image folder. (rot_Image)
        rgbImageFileName = strcat(dataFilesList(nDataSet).name, 'RGB.png');
        generatedRgbPath = fullfile(RGB_image_folder, rgbImageFileName);
        
        imwrite(rot_Image, generatedRgbPath);
        
        % Classification of HSI using 
        HSI_Cnn_1D_Dataset;
        
        % Save ground truth results. 
        gtImageFileName = strcat(dataFilesList(nDataSet).name, '_gt.png');
        generatedGtPath = fullfile(Gt_from_classification_folder, gtImageFileName);
        
        imwrite(rot_groundTruth, generatedGtPath);
        
        % Save classified image results.
        gtImageLabelsFileName = strcat(dataFilesList(nDataSet).name, '_gt_labels.png');
        generatedGtLabelsPath = fullfile(Image_from_classification_folder, gtImageLabelsFileName);
        
        imwrite(rot_ClassifiedImage, generatedGtLabelsPath);

    end
end