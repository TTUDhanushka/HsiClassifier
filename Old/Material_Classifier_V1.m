clc;
close All;

% Read hyperspectral images of earth minerals. And classify according to
% the material content. Plot material graphs.

%% Import data

% Image source is the camera type.
image_source = 'specim';
uiwait(msgbox('Select hyperspectral image'));

directory_path = uigetdir;

directory_path = strcat(directory_path,'\');

materialID = 0;
%% Get the data file paths from the data directory.

% RGB preview file
rgb_file = '';
header_file = '';
hsi_file = '';

[rgb_file, header_file, hsi_file, white_ref_file,...
    white_ref_hdr, dark_ref_file, dark_ref_hdr] = GetDataFiles(directory_path);

% Get the header data
[cols, lines, bands, wave] = ReadHeader(header_file, image_source);


%% Image aquisition and correction

hsi_cube = multibandread(hsi_file, [cols lines bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

% white_ref_cube = multibandread(white_ref_file, [cols 1 bands],...
%     'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

dark_ref_cube = multibandread(dark_ref_file, [cols 1 bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});


% Select white reference area
[wh_ref_im, wh_ref_im_x, wh_ref_im_y] = Select_Pixel_Class(rgb_file, true);

white_ref_cube = Extract_Training_Pixels(hsi_cube, wh_ref_im_x, wh_ref_im_y);
   
[wh_ref_h, wh_ref_w, wh_ref_d] = size(white_ref_cube);

X_axis = linspace(1, wh_ref_d, wh_ref_d);
Y_axis = zeros(wh_ref_h *  wh_ref_w, wh_ref_d);

for i = 1:wh_ref_h
    
    for j = 1:wh_ref_w
        
        Y_axis(((i - 1) * wh_ref_w) + j, :) = white_ref_cube(i, j, :);
        hold on
        
        plot(X_axis, Y_axis(((i - 1) * wh_ref_w) + j, :));
    end
end

white_ref_avg = zeros(1, wh_ref_d);
dark_ref_avg = zeros(1, wh_ref_d);

for i = 1:wh_ref_d
     dark_ref_avg(1,i) = mean (dark_ref_cube(:,1,i));   
     white_ref_avg(1,i) = mean (Y_axis(:,i));
end

figure()
plot(X_axis, white_ref_avg, 'b', 'LineWidth', 2)
plot(X_axis, dark_ref_avg, 'r', 'LineWidth', 2)
hold off
    
correctd_hsi_cube = zeros(cols, lines, bands);


    for i = 1:cols
        for j = 1:lines
            for k = 1:bands

                correctd_hsi_cube(i,j,k) = (4096 * (hsi_cube(i,j,k) - dark_ref_avg(k)) / (white_ref_avg(k) - dark_ref_avg(k)));
            end
        end
    end
    
    %% Get spectral samples and plot the spectral signature
    
    materialID = materialID + 1;
    materialName = num2str(materialID); % cell2str(input( 'Name of the material?'));
    
    % Create RGB reconstruction
    
    dummyRGB = zeros(512, 512, 3, 'uint8');
    br = 30;
    dummyRGB(:,:,1) = uint8(hsi_cube(:,:,26) / 16) + br;
    dummyRGB(:,:,2) = uint8(hsi_cube(:,:,53) / 16) + br +10;
    dummyRGB(:,:,3) = uint8(hsi_cube(:,:,104) / 16) + br+15;
    
        
    [im, im_x, im_y] = Select_Pixel_Class(dummyRGB, false);
    
    class_cube = Extract_Training_Pixels(correctd_hsi_cube, im_x, im_y);
    imageName = strcat(materialName, '_location.png');
    
    saveas(gcf, imageName);
    
    [cl_h, cl_w, cl_d] = size(class_cube);
    
    wavelength_range = [397, 1004];

    X_axis = linspace(wavelength_range(1), wavelength_range(2), cl_d);
    Y_axis_cl = linspace((cl_h * cl_w),cl_d,cl_d);
    
    for i = 1:cl_h
        for j = 1:cl_w
            for k = 1:cl_d
                Y_axis_cl(((i - 1 ) * cl_w) + j, k) = class_cube(i,j,k) / 4096;
            end
        end
    end
    
    [len, wid] = size(Y_axis_cl);
    
    % Calculate the mean spectra of the sample
    spec_avg = zeros(1, cl_d);
    for i = 1:wh_ref_d
         spec_avg(1,i) = mean (Y_axis_cl(:,i));
    end
    
    lightBlue = [208 208 208] ./ 255;
    darkBlue = [71 71 71] ./ 255;
    
    plotColorMain = darkBlue; 
    plotColorSub = lightBlue;
    
    figure('Renderer', 'painters', 'Position', [10 10 600 600])
    for id = 1: len
        hold on
        plot(X_axis, Y_axis_cl(id, :), 'Color', plotColorSub);
    end
    
    plot(X_axis, spec_avg, 'Color', plotColorMain , 'LineWidth', 2)
    
    xlim(wavelength_range)
    xlabel('Wavelength range in nm')
    ylim([0 1])
    ylabel('Normalized reflectance')
    hold off

    figureName = strcat(materialName, '.png');
    
    saveas(gcf, figureName);
    %% Display the sampled region 
    
    v_1  = im_x(2);
    l_1  = im_x(1);
    v_2 = im_y(2);
    l_2  = im_y(1);
    
    for q = 1: (v_2 - v_1)
        for r = 1: (l_2 - l_1)
            dummyRGB(v_1+q, l_1+r, 1) = 255;
            dummyRGB(v_1+q, l_1+r, 2) = 0;
            dummyRGB(v_1+q, l_1+r, 3) = 0;
        end
    end
    
    figure();
    imshow(dummyRGB)
    