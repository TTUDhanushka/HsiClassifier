function label_color = Get_Label_Color(class_id)


colors =   [0, 0, 0;...           % Black (undefined classes)
            0, 102, 0; ...        % dark green (Grass)
            255, 153, 204; ...    % Pink (Bush)
            99, 66, 34; ...       % Brown (Mud)
            170, 170, 170; ...    % Grey (concrete)
            64, 64, 64; ...       % Dark grey (Asphalt) 
            0, 255, 0; ...        % Green (Trees)
            110, 22, 138; ...     % Purple (Rocks)
            68, 187, 170; ...      % Light blue (water / ice)            68, 187, 170;...      % Cyan (Black ice)
            0, 0, 255;...         % Blue (sky)
            240, 240, 240;...     % White with little gray (Snow)
            230, 230, 30;...      % Yellow (Dirt)
            187, 136, 51;...      % Light brown(Gravel)
            192, 6, 64;...        % Light purple (Objects)
            204, 153, 255;...     % Very Light purple (Person)
            ];

label_color = colors(class_id, :);

end