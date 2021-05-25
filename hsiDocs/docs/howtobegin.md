## Running Scripts


Run ***MainProgram.m*** MATLAB script section by section.
 
![stepbystep script execution](..\imagesForDocs\stepbystep.PNG) 

Below script adds the necessary sub folder to the path.

```matlab
    addpath HelperFunctions ClassificationMethods BandSelectionMethods 
    addpath HsiToRgb ImageQualityMatrices
```

Read the specim hyperspectral images using below section in the script.

```matlab
    classifyingLargeDataSet = false;        % This is only applicable for classyfing full image folder contain more than 1 image.
    ReadSpecimData();                       % Reads all the files into workspace.
```

## Create Training Data

Running below script from the source is the most appropriate. 

```matlab
    % Run the script directly from source.
    CollectTrainingData();

    % Save data using UtilityFunctions.m
```

By using ***UtilityFunctions.m***, some of the unwanted variables can be removed from workspace. 
And save the training data into Matlab workspaces using the second section of the script for future use. 

Combined workspaces can be used to prepare the NN training inputs with below script.
```matlab
    trainingDataFolder = 'G:\3. Hyperspectral\5. Matlab HSI\3. TrainingData Mat Files\'; 
    matFilesList = dir(trainingDataFolder);

    for nFile = 1:length(matFilesList)
        if contains(matFilesList(nFile).name, '.mat')
            path = fullfile(trainingDataFolder, matFilesList(nFile).name);
            load (path);
        end
    end


    % Convert training data into 1-D array with n-samples.

    TrainingPixelClassesTo1D();

```
