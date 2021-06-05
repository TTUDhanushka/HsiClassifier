function [classCube, classLabels] = UpdateClassSampleCubes(className, dataCubeSample, dataLabels, existOnWs)
    % Combine training data cubes to prepare final traing data sets for
    % each class.
    
    dataCubeName = strcat(className, '_cube_Ref');
    labelCubeName = strcat(className, '_labels');
    
    [sample_d, sample_h] = size(dataCubeSample);
    
    if (existOnWs==0)
        disp('Not exist');
        classCube = dataCubeSample;
        
    else
        classCube = evalin('base', dataCubeName);
        
        [cube_d, cube_h] = size(classCube);
        
        if ~(cube_d == sample_d)
            disp('Error: Data cubes contain different number of bands.');
            return;
        else
            classCube = [classCube, dataCubeSample];            
        end
    end
    
    if (existOnWs==0)
        disp('Not exist');
        classLabels = dataLabels;
        
    else
        classLabels = evalin('base', labelCubeName);
        
        classLabels = [classLabels, dataLabels];               
    end
    
    
    % Write to the base workspace
    assignin('base', dataCubeName, classCube);
    assignin('base', labelCubeName, classLabels);
    
end