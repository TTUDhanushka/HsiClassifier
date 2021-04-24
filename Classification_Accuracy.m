clc;

%% Read result image and ground truth image

% These files are aken from the workspace.
[h, w, d] = size(groundTruthImage);
[h_r, w_r, d_r] = size(classifiedImage);

compare_image = zeros(h, w, 3, 'uint8');

if ((h ~= h_r) || (w ~= w_r) || (d ~= d_r))
    message = sprintf('Image dimensions are not equal');
end


%% Compare overall accuracy

success = 0;
totalPixels = h * w;

for idx = 1:h
    for idy = 1: w
        if(groundTruthImage(idx, idy,:) == classifiedImage(idx, idy,:))
            success = success + 1;
        end
    end
end

accuracy = (success / totalPixels) * 100

% color = zeros(no_of_classes,3);
% color_res = zeros(no_of_classes,3);
% 
% % Get the colors from ground_truth image
% for class = 1:no_of_classes
%     color(class, :) = Get_Pixel_Class(ground_truth);
% end
% 
% close all;
% 
% % Masked colors in the result image
% for class = 1:no_of_classes
%     color_res(class, :) = Get_Masking_Color(no_of_classes, class);
% end

