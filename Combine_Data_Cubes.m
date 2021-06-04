function combined_cube = Combine_Data_Cubes(hsi_cube1, hsi_cube2)
    % Combine training data cubes to prepare final traing data sets for
    % each class.
    
    [cube_1_h, cube_1_w, cube_1_d] = size(hsi_cube1);
    [cube_2_h, cube_2_w, cube_2_d] = size(hsi_cube2);   

    
    no_of_samples = ((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w)+ (cube_4_h * cube_4_w));
    
    combined_cube = zeros(1, no_of_samples, cube_1_d); 
    
    for i = 1:cube_1_h 
        for j = 1:cube_1_w
            for k = 1:cube_1_d
                combined_cube(1,((i * cube_1_h) + cube_1_w), k) = hsi_cube1(i, j, k);
            end
        end
    end
    
    for i = 1:cube_2_h 
        for j = 1:cube_2_w
            for k = 1:cube_2_d
                combined_cube(1,((cube_1_h * cube_1_w) + (i * cube_2_h) + cube_2_w), k) = hsi_cube2(i, j, k);
            end
        end
    end
    

end