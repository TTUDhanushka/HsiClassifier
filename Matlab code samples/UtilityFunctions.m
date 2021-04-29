%% Some snippets to run / save various operations.

clear;


%% Delete unwanted variables from the workspace when creating training data.

vars = {'bands','classList','cols', 'corrected_hsi_cube',...
    'dark_ref_cube', 'dark_ref_file', 'dark_ref_hdr',...
    'directory_path', 'fileId', 'fileList', 'ground_truth_File',...
    'groundTruthExist', 'header_file', 'hsi_cube', 'hsi_file',...
    'idI', 'idJ', 'im', 'im_x', 'im_y', 'image_source', 'lines',...
    'masking_color', 'pointsInSample', 'reflectance_cube', ...
    'reflectance_hdr', 'rgb_file', 'sampleHeight', 'sampleWidth',...
    'simul_white_ref', 'wave', 'white_ref_cube', 'white_ref_file',...
    'white_ref_hdr', 'correctd_hsi_cube', 'reflectanceCube', 'rgb_image',...
    'rgb_from_corrected','rgb_from_ref'};
clear(vars{:})

clear vars
%% Save workspace to mat file.

% Rename the mat file according to the class name to avoid conflicts.

className = 'rocks.mat';                % CHANGE THIS
trainingDataFolder = 'G:\3. Hyperspectral\5. Matlab HSI\3. TrainingData Mat Files\';
trainingDataPath = fullfile(trainingDataFolder, className);

save(trainingDataPath)

