%% Some snippets to run / save various operations.

clear;


%% Delete unwanted variables from the workspace


%% Save workspace to mat file.

% Rename the mat file according to the class name to avoid conflicts.

className = 'water.mat';                % CHANGE THIS
trainingDataFolder = 'G:\3. Hyperspectral\5. Matlab HSI\3. TrainingData Mat Files\';
trainingDataPath = fullfile(trainingDataFolder, className);

save(trainingDataPath)

