function masking_color = Get_Masking_Color(no_of_classes, class_id)

%     class = class_id - 1;
%
% 	intensity_max = 1;
% 	half_range = int16 (round(no_of_classes / 2));
%
% 	red = (intensity_max - ((intensity_max / (no_of_classes - 1)) * class)) * 255;
%
% 	if (class < half_range)
% 		green = ((intensity_max / half_range) * class) * 255;
%     else
% 		green = (((intensity_max / half_range) - intensity_max) * class) * 255;
% 	end
%
% 	blue = ((intensity_max / (no_of_classes - 1)) * class) * 255;

colors =   [65 117 5; ...       % dark green (Asphalt, gravel)
            74 144 226; ...     % blue (object)
            0 0 0; ...          % black (sky)
            126 211 33; ...     % light green (mud / soil)
            255 240 53; ...     % yellow (trees) 
            45 216 199; ...     % cyan/blue (vehicle)
            255 255 255; ...    % white (water)
            74 144 226; ...      % blue (calibration white ref)
            ];

masking_color = colors(class_id, :);


end