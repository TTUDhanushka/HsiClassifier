clc;

%% Read result image and ground truth image
no_of_classes = 6;

tru_pxl_cls_1 = 0;
tru_pxl_cls_2 = 0;
tru_pxl_cls_3 = 0;
tru_pxl_cls_4 = 0;
tru_pxl_cls_5 = 0;
tru_pxl_cls_6 = 0;

res_pxl_cls_1 = 0;
res_pxl_cls_2 = 0;
res_pxl_cls_3 = 0;
res_pxl_cls_4 = 0;
res_pxl_cls_5 = 0;
res_pxl_cls_6 = 0;

result = imread('G:\3. Hyperspectral\5. Matlab HSI\20200420\result_v3.png');
ground_truth = imread('G:\3. Hyperspectral\5. Matlab HSI\20200420\REFLECTANCE_2019-11-18_021_gt.png');

result = imrotate(result, 0);

[h w d] = size(ground_truth);
[h_r w_r d_r] = size(result);

compare_image = zeros(h, w, 3, 'uint8');

if ((h ~= h_r) || (w ~= w_r) || (d ~= d_r))
    message = sprintf('Image dimensions are not equal');
end


%% Recolor the ground truth to match the result colors

color = zeros(no_of_classes,3);
color_res = zeros(no_of_classes,3);

% Get the colors from ground_truth image
for class = 1:no_of_classes
    color(class, :) = Get_Pixel_Class(ground_truth);
end

close all;

% Masked colors in the result image
for class = 1:no_of_classes
    color_res(class, :) = Get_Masking_Color(no_of_classes, class);
end

point_color = zeros(1,3);
temp_color = zeros(1,3);



% Recolor the ground truth
for i = 1:h
    for j = 1:w
        
        point_color = ground_truth(i,j,:);
        
        for f = 1:3
            temp_color(1,f) = point_color(1,1,f);
        end
        
        if (isequal(color(1,:), temp_color(1,:)))
            compare_image(i,j,:) = color_res(1,:);
            tru_pxl_cls_1 = tru_pxl_cls_1 + 1;
            
        elseif(isequal(color(2,:), temp_color(1,:)))
            compare_image(i,j,:) = color_res(2,:);
            tru_pxl_cls_2 = tru_pxl_cls_2 + 1;
            
        elseif (isequal(color(3,:), temp_color(1,:)))
            compare_image(i,j,:) = color_res(3,:);
            tru_pxl_cls_3 = tru_pxl_cls_3 + 1;
                       
        elseif (isequal(color(4,:), temp_color(1,:)))
            compare_image(i,j,:) = color_res(4,:);
            tru_pxl_cls_4 = tru_pxl_cls_4 + 1;
            
        elseif (isequal(color(5,:), temp_color(1,:)))
            compare_image(i,j,:) = color_res(5,:);
            tru_pxl_cls_5 = tru_pxl_cls_5 + 1;
            
        elseif (isequal(color(6,:), temp_color(1,:)))
            compare_image(i,j,:) = color_res(6,:);
            tru_pxl_cls_6 = tru_pxl_cls_6 + 1;
        end
    end
end

figure()
subplot(1,2,1);
imshow(result);

subplot(1,2,2);
imshow(compare_image);

true_pixel_count = [tru_pxl_cls_1, tru_pxl_cls_2, tru_pxl_cls_3, tru_pxl_cls_4, tru_pxl_cls_5, tru_pxl_cls_6]


% Check the classification accuracy 
temp_2_color = zeros(1,3);

for i = 1:h
    for j = 1:w
        
        point_res = result(i,j,:);
        
        for f = 1:3
            temp_2_color(1,f) = point_res(1,1,f);
        end
        
        if (isequal(result(i,j,:), compare_image(i,j,:)))
            
            if (isequal(color_res(1,:), temp_2_color(1,:)))
                res_pxl_cls_1 = res_pxl_cls_1 + 1;
                
            elseif(isequal(color_res(2,:), temp_2_color(1,:)))
                res_pxl_cls_2 = res_pxl_cls_2 + 1;
                
            elseif (isequal(color_res(3,:), temp_2_color(1,:)))
                res_pxl_cls_3 = res_pxl_cls_3 + 1;
                
            elseif (isequal(color_res(4,:), temp_2_color(1,:)))
                res_pxl_cls_4 = res_pxl_cls_4 + 1;
                
            elseif (isequal(color_res(5,:), temp_2_color(1,:)))
                res_pxl_cls_5 = res_pxl_cls_5 + 1;
                
            elseif (isequal(color_res(6,:), temp_2_color(1,:)))
                res_pxl_cls_6 = res_pxl_cls_6 + 1;
            end
            
        end
    end
end

result_pixel_count = [res_pxl_cls_1, res_pxl_cls_2, res_pxl_cls_3, res_pxl_cls_4, res_pxl_cls_5, res_pxl_cls_6]
 
percent_accuracy = zeros (1, no_of_classes);
total_correct_pixels = 0;
total_pixels = h * w;

for i = 1:no_of_classes
    
    percent_accuracy(1, i) = (result_pixel_count(1,i) / true_pixel_count(1, i)) * 100;
    total_correct_pixels = total_correct_pixels + result_pixel_count(1,i);
end

overall = (total_correct_pixels / total_pixels) * 100

a = percent_accuracy

imwrite(result, 'G:\3. Hyperspectral\5. Matlab HSI\20200420\result_v3_colored.png');
imwrite(compare_image, 'G:\3. Hyperspectral\5. Matlab HSI\20200420\result_v3_accuracy.png');