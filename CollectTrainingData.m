%% Instructions: 

% Data should be collected from Reflectance data cube in the workspace.
%   1. Therefore ReadSpecimData should be called before this script.
%   2. Clear workspace if the workspace contains any other variables.


%%

% Select the label class from the class list. and modify
% class_cube_class_labels variable names accordingly.

class = 7;          % CHANGE 

classList = ["undefined";...        % 1
            "grass"; ...            % 2
            "bush"; ...             % 3
            "mud"; ...              % 4
            "concrete"; ...         % 5
            "asphalt"; ...          % 6
            "tree"; ...             % 7
            "rocks"; ...            % 8
            "water"; ...            % 9
            "sky"; ...              % 10
            "snow"; ...             % 11
            "ice"; ...              % 12
            "dirt"; ...             % 13
            "gravel"; ...           % 14    
            "objects"; ...          % 15
            "person"; ...           % 16
            ];

rgb_image = rgb_from_ref;
        
masking_color = Get_Label_Color( class);

rgb_image = imrotate(rgb_image, 90);

[im, im_x, im_y] = Select_Pixel_Class(rgb_image, false);

rgb_image = RectangleAreaOverlay(rgb_image, im_x, im_y, masking_color);

sampleHeight = im_y(1) - im_x(1);
sampleWidth = im_y(2) - im_x(2);

pointsInSample = sampleWidth * sampleHeight;

% Extract the HSI pixels from calibrated hsi image datacube.
tree_cube_Ref = Extract_Training_Pixels(reflectanceCube.DataCube, im_x, im_y);  % CHANGE
tree_cube_Calib = Extract_Training_Pixels(correctd_hsi_cube, im_x, im_y);         % CHANGE

tree_labels = zeros(sampleWidth, sampleHeight, 'uint8');                    % CHANGE

for idI = 1: sampleWidth + 1
    for idJ = 1:sampleHeight + 1
       tree_labels(idI, idJ) = class;
    end
end


