%% HSI based image labeling pipeline

addpath('HelperFunctions')
%% Parameters

% White reference in the image
simultaneousRef = false;


%%
% Get images scene folder

workingFolder = pwd;

scenePath = uigetdir();
dirList = dir(scenePath);

% Image source is the camera type.
image_source = 'specim';

% Query all the images
img_count = 1;

% files.
rgb_file = '';
header_file = '';
hsi_file = '';

for i = 1: length(dirList)
    if (~strcmp(dirList(i).name, '.') && ~strcmp(dirList(i).name, '..'))
        
        directory_path = fullfile(scenePath, dirList(i).name);
        
        % Read the HSI data cube.
        [rgb_file, header_file, hsi_file, white_ref_file,...
            white_ref_hdr, dark_ref_file, dark_ref_hdr,...
            white_dark_file, white_dark_hdr, ...
            reflect_file, reflect_hdr] = GetDataFiles_V2(directory_path);
        
        % Get the header data
        [cols, lines, bands, wave] = ReadHeader(header_file, image_source);
        
        hsi_cube = multibandread(hsi_file, [cols lines bands],...
            'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});
        
        reflect_cube = multibandread(reflect_file, [cols lines bands],...
            'uint8', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});
        
        white_ref_cube = multibandread(white_ref_file, [cols 1 bands],...
            'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});
        
        whitedark_ref_cube = multibandread(white_dark_file, [cols 1 bands],...
            'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});
        
        dark_ref_cube = multibandread(dark_ref_file, [cols 1 bands],...
            'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

        
        if (simultaneousRef)
            % Get white spot from the image and correct the data cube
            
        else
            [correctd_hsi_cube, error] = Calibrate_Spectral_Image(hsi_cube, white_ref_cube,...
                whitedark_ref_cube);
        end
        
                % Reconstruct RGB image from the cube
        dummyRGB = zeros(512, 512, 3, 'uint8');
        br = 30;
        dummyRGB(:,:,1) = uint8(correctd_hsi_cube(:,:,26) / 16) + br;
        dummyRGB(:,:,2) = uint8(correctd_hsi_cube(:,:,53) / 16) + br + 10;
        dummyRGB(:,:,3) = uint8(correctd_hsi_cube(:,:,104) / 16) + br + 15;
        
        figure()
        imshow(dummyRGB)
        
        slice_no = 20;
        
        original_slice = uint8(hsi_cube(:,:, slice_no) / 16);
        corrected_slice = uint8(correctd_hsi_cube(:,:, slice_no) / 16);
        reflect_slice = uint8(reflect_cube(:,:, slice_no));
        
        figure()
        subplot(1,3, 1)
        imshow(original_slice)
        
        subplot(1,3, 2)
        imshow(corrected_slice)
        subplot(1,3, 3)
        imshow(reflect_slice)
        
        
%         %% Plot the spectral distribution for one point in the image
%         [wh_ref_h, wh_ref_w, wh_ref_d] = size(whitedark_ref_cube);
%         
%         X_axis = linspace(1, wh_ref_d, wh_ref_d);
%         Y_WD = zeros(1, wh_ref_d);
%         Y_W = zeros(1, wh_ref_d);
%         Y_D = zeros(1, wh_ref_d);
%         
%         for i = 1:wh_ref_d
%             Y_D(1,i) = mean (dark_ref_cube(:,1,i));
%             Y_WD(1,i) = mean (whitedark_ref_cube(:,1,i));
%             Y_W(1,i) = mean (white_ref_cube(:,1,i));
%         end
%         
%         figure()
%         plot(X_axis, Y_D, 'b', 'LineWidth', 2)
%         hold on
% %         plot(X_axis, Y_WD, 'r', 'LineWidth', 2)
% %         hold on
%         plot(X_axis, Y_W, 'g', 'LineWidth', 2)
%         hold off

        %% Run classification
        % Get the list of minimum bands
        
        % Create minimum band images
        reduced_cube = Create_Min_Band_Image(correctd_hsi_cube, min_max_pool_bands);
        
        % Convert cube to plane
        linear_image = Convert_to_1d_Spectral(reduced_cube);
        [l_h, l_d] = size(linear_image);
        
        NN_result = zeros(l_h, no_of_classes, 'uint8');
        
        test_in = zeros(length(min_max_pool_bands),1);
        
        % Call classifier
        parfor i = 1:l_h
            
            test_in = linear_image(i, :);
            
            NN_result(i, :) = uint8(255 * (sim(two_layer_net, test_in')));
            
        end

        % Save RGB image
        classified_image = zeros(cols, lines, 3, 'uint8');

        
        for i = 1: l_h
            
            [res_val, res_ind] = max(NN_result(i,:));
            
            c_h = floor((i - 1) / cols) + 1;
            c_w = (i-1) - ((c_h - 1) * cols) + 1;
            classified_image(c_h, c_w, :) = Get_Masking_Color(no_of_classes, res_ind);
            
        end


        % Save classification result
        
        figure()
        subplot(1, 2, 1)
        reconstructedImg = ConvertFalseRgb(correctd_hsi_cube, white_ref_cube);
        imshow(reconstructedImg);
        
        subplot(1, 2, 2)
        classified_image = imrotate(classified_image, -90);
        imshow(classified_image);

    end
end







