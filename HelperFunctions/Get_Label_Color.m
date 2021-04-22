function label_color = Get_Label_Color(class_id)


colors =   [250 0 0;...           % Black (undefined classes)
            0 102 0; ...        % dark green (Grass)
            255 153 204; ...    % Pink (Bush)
            99 66 34; ...       % Brown (Mud)
            170 170 170; ...    % Grey (concrete)
            64 64 64; ...       % Dark grey (Asphalt) 
            0 255 0; ...        % Green (Trees)
            110 22 138; ...     % Purple (Rocks)
            0 128 255; ...      % Light blue (water)
            0 0 255;...         % Blue (sky)
            51 102 255;...      % French blue (Snow)
            68 187 170;...      % Cyan (Black ice)
            108 64 20;...       % Medium Brown (Dirt)
            187 136 51;...      % Light brown(Gravel)
            102 0 204;...       % Light purple (Objects)
            204 153 255;...     % Very Light purple (Person)
            ];

label_color = colors(class_id, :);

end