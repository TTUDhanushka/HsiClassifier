%% Instructions: 

% Data should be collected from Reflectance data cube in the workspace.
%   1. Therefore ReadSpecimData should be called before this script.
%   2. Clear workspace if the workspace contains any other variables.


%%

% Select the label class from the class list. and modify
% class_cube_class_labels variable names accordingly.

class = 1;          % CHANGE

classList = ["undefined";...
            "Grass"; ...
            "Bush"; ...
            "Mud"; ...
            "concrete"; ...
            "Asphalt"; ...
            "Trees"; ...
            "Rocks"; ...
            "water"; ...
            "sky"; ...
            "Snow"; ...
            "Black_ice"; ...
            "Dirt"; ...
            "Gravel"; ...
            "Objects"; ...
            "Person"; ...
            ];

rgb_image = rgb_from_ref;
        
masking_color = Get_Label_Color( class);

[im, im_x, im_y] = Select_Pixel_Class(rgb_image, false);

rgb_image = Display_Classified_Image(rgb_image, im_x, im_y, masking_color);

sampleHeight = im_y(1) - im_x(1);
sampleWidth = im_y(2) - im_x(2);

pointsInSample = sampleWidth * sampleHeight;

% Extract the HSI pixels from calibrated hsi image datacube.
undefined_cube = Extract_Training_Pixels(reflectanceCube.DataCube, im_x, im_y); % CHANGE
%tree_cube = Extract_Training_Pixels(correctd_hsi_cube, im_x, im_y); % CHANGE

undefined_labels = zeros(sampleWidth, sampleHeight, 'uint8');                   % CHANGE

for idI = 1: sampleWidth + 1
    for idJ = 1:sampleHeight + 1
       undefined_labels(idI, idJ) = class - 1;
    end
end

% Training data save as workspace
% save('training_data.mat')
