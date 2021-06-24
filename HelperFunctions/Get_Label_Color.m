function label_color = Get_Label_Color(class_id)


colors =   [0, 0, 0;...           % Black (undefined classes)
            0, 102, 0; ...        % dark green (Grass)
            170, 170, 170; ...    % Grey (concrete)
            64, 64, 64; ...       % Dark grey (Asphalt) 
            0, 255, 0; ...        % Green (Trees)
            110, 22, 138; ...     % Purple (Rocks)
            68, 187, 170; ...     % Light blue (water / ice)
            0, 0, 255;...         % Blue (sky)
            187, 136, 51;...      % Light brown(Gravel)
            192, 6, 64;...        % Light purple (Objects)            204, 153, 255;...     % Very Light purple (Person)
            230, 230, 30;...      % Yellow (Dirt)
            99, 66, 34; ...       % Brown (Mud)
            ];

label_color = colors(class_id, :);

end