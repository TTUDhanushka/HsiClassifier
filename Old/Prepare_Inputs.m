function [inputs, targets] = Prepare_Inputs(hsi_cube1, hsi_cube2, hsi_cube3, hsi_cube4, hsi_cube5)

    no_of_classes = 5;

    [cube_1_h, cube_1_w, cube_1_d] = size(hsi_cube1);
    [cube_2_h, cube_2_w, cube_2_d] = size(hsi_cube2);   
    [cube_3_h, cube_3_w, cube_3_d] = size(hsi_cube3);
    [cube_4_h, cube_4_w, cube_4_d] = size(hsi_cube4);
    [cube_5_h, cube_5_w, cube_5_d] = size(hsi_cube5); 
%     [cube_6_h, cube_6_w, cube_6_d] = size(hsi_cube6); 
    
    no_of_samples = ((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w) + (cube_5_h * cube_5_w) ); % + (cube_6_h * cube_6_w)
    
    inputs_temp = zeros(cube_1_d, no_of_samples);
    targets_temp = zeros(no_of_classes, no_of_samples);
    
    inputs = zeros(cube_1_d, no_of_samples);
    targets = zeros(no_of_classes, no_of_samples);
    
    for i = 1:cube_1_h
        for j = 1:cube_1_w
            for k = 1:cube_1_d
                inputs_temp(k, ((i - 1) * cube_1_h) + j) = hsi_cube1(i, j, k);
            end
            targets_temp(1, ((i - 1) * cube_1_h) + j) = 1;
            targets_temp(2, ((i - 1) * cube_1_h) + j) = 0;
            targets_temp(3, ((i - 1) * cube_1_h) + j) = 0;
            targets_temp(4, ((i - 1) * cube_1_h) + j) = 0;
            targets_temp(5, ((i - 1) * cube_1_h) + j) = 0;
%             targets_temp(6, ((i - 1) * cube_1_h) + j) = 0;
        end
    end

    for i = 1:cube_2_h
        for j = 1:cube_2_w
            for k = 1:cube_1_d
                inputs_temp(k, ((cube_1_h * cube_1_w) + (i - 1) * cube_2_h) + j) = hsi_cube2(i, j, k);
            end
            targets_temp(1, ((cube_1_h * cube_1_w) + (i - 1) * cube_2_h) + j) = 0;
            targets_temp(2, ((cube_1_h * cube_1_w) + (i - 1) * cube_2_h) + j) = 1;
            targets_temp(3, ((cube_1_h * cube_1_w) + (i - 1) * cube_2_h) + j) = 0;
            targets_temp(4, ((cube_1_h * cube_1_w) + (i - 1) * cube_2_h) + j) = 0;
            targets_temp(5, ((cube_1_h * cube_1_w) + (i - 1) * cube_2_h) + j) = 0;
%             targets_temp(6, ((cube_1_h * cube_1_w) + (i - 1) * cube_2_h) + j) = 0;
        end
    end
    
    for i = 1:cube_3_h
        for j = 1:cube_3_w
            for k = 1:cube_1_d
                inputs_temp(k, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w)) + (i - 1) * cube_3_h) + j) = hsi_cube3(i, j, k);
            end
            targets_temp(1, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w)) + (i - 1) * cube_3_h) + j) = 0;
            targets_temp(2, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w)) + (i - 1) * cube_3_h) + j) = 0;
            targets_temp(3, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w)) + (i - 1) * cube_3_h) + j) = 1;
            targets_temp(4, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w)) + (i - 1) * cube_3_h) + j) = 0;
            targets_temp(5, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w)) + (i - 1) * cube_3_h) + j) = 0;
%             targets_temp(6, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w)) + (i - 1) * cube_3_h) + j) = 0;
        end
    end
    
    for i = 1:cube_4_h
        for j = 1:cube_4_w
            for k = 1:cube_1_d
                inputs_temp(k, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w)) + (i - 1) * cube_4_h) + j) = hsi_cube4(i, j, k);
            end
            targets_temp(1, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w)) + (i - 1) * cube_4_h) + j) = 0;
            targets_temp(2, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w)) + (i - 1) * cube_4_h) + j) = 0;
            targets_temp(3, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w)) + (i - 1) * cube_4_h) + j) = 0;
            targets_temp(4, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w)) + (i - 1) * cube_4_h) + j) = 1;
            targets_temp(5, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w)) + (i - 1) * cube_4_h) + j) = 0;
%             targets_temp(6, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w)) + (i - 1) * cube_4_h) + j) = 0;
        end
    end
    
    for i = 1:cube_5_h
        for j = 1:cube_5_w
            for k = 1:cube_1_d
                inputs_temp(k, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w)) + (i - 1) * cube_5_h) + j) = hsi_cube5(i, j, k);
            end
            targets_temp(1, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w)) + (i - 1) * cube_5_h) + j) = 0;
            targets_temp(2, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w)) + (i - 1) * cube_5_h) + j) = 0;
            targets_temp(3, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w)) + (i - 1) * cube_5_h) + j) = 0;
            targets_temp(4, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w)) + (i - 1) * cube_5_h) + j) = 0;
            targets_temp(5, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w)) + (i - 1) * cube_5_h) + j) = 1;
%             targets_temp(6, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w)) + (i - 1) * cube_5_h) + j) = 0;
        end
        
    end
    
%     for i = 1:cube_6_h
%         for j = 1:cube_6_w
%             for k = 1:cube_1_d
%                 inputs_temp(k, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w) + (cube_5_h * cube_5_w)) + (i - 1) * cube_6_h) + j) = hsi_cube6(i, j, k);
%             end
%             targets_temp(1, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w) + (cube_5_h * cube_5_w)) + (i - 1) * cube_6_h) + j) = 0;
%             targets_temp(2, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w) + (cube_5_h * cube_5_w)) + (i - 1) * cube_6_h) + j) = 0;
%             targets_temp(3, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w) + (cube_5_h * cube_5_w)) + (i - 1) * cube_6_h) + j) = 0;
%             targets_temp(4, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w) + (cube_5_h * cube_5_w)) + (i - 1) * cube_6_h) + j) = 0;
%             targets_temp(5, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w) + (cube_5_h * cube_5_w)) + (i - 1) * cube_6_h) + j) = 0;
%             targets_temp(6, (((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w) + (cube_5_h * cube_5_w)) + (i - 1) * cube_6_h) + j) = 1;
%         end
%         
%     end
    
    % shuffle the data before sending to NN
    rand_index = randperm((cube_1_h * cube_1_w) + (cube_2_h * cube_2_w) + (cube_3_h * cube_3_w) + (cube_4_h * cube_4_w) + (cube_5_h * cube_5_w)); % + (cube_6_h * cube_6_w)
    
    for m = 1:cube_1_d
        for n = 1:no_of_samples
            inputs(m,n) = inputs_temp(m, rand_index(n)); 
        end
    end

    for m = 1:no_of_classes % No of classes
        for n = 1:no_of_samples
            targets(m,n) = targets_temp(m, rand_index(n));
        end
    end
end