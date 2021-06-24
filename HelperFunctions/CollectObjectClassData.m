%% Instructions: 

% Data should be collected from Reflectance data cube in the workspace.
%   1. Therefore ReadSpecimData should be called before this script.
%   2. Clear workspace if the workspace contains any other variables.


function [classDataCube, classLabels] =  CollectObjectClassData(className, dataCube)

    % Select the label class from the class list. and modify
    % class_cube_class_labels variable names accordingly. 

    classList = ["undefined";...        % 1
                "grass"; ...            % 2
                "concrete"; ...         % 3
                "asphalt"; ...          % 4
                "tree"; ...             % 5                 "bush"; ...             % 3
                "rocks"; ...            % 6
                "water"; ...            % 7                 "ice"; ...              % 12
                "sky"; ...              % 8                 "snow"; ...             % 11
                "gravel"; ...           % 9                 
                "objects"; ...          % 10                "person"; ...           % 11
                "dirt"; ...             % 11
                "mud"; ...              % 12
                ];

    for nClass = 1:length(classList)
        if strcmp(classList(nClass), className)
            class = nClass;
        end
    end
    
    rgb_image = GetTriBandRgbImage(dataCube);

    masking_color = Get_Label_Color(class);

    [im, im_x, im_y] = Select_Pixel_Class(rgb_image, false);

    rgb_image = RectangleAreaOverlay(rgb_image, im_x, im_y, masking_color);

    sampleHeight = im_y(1) - im_x(1);
    sampleWidth = im_y(2) - im_x(2);

    % Extract the HSI pixels from calibrated hsi image datacube.
    extractedDataCube = Extract_Training_Pixels(dataCube, im_x, im_y);  % CHANGE

    classDataCube = UnfoldHsiCube(extractedDataCube);
    
    % Total number of pixels extracted from the datacube as samples.
    totalSamples = (sampleWidth + 1) * (sampleHeight + 1);
    
    classLabels = zeros(1, totalSamples, 'uint8');                   

    for idI = 1:totalSamples        
        classLabels(1, idI) = class;        
    end

end

