%% HSI based image labeling pipeline

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
        
        directory_path = fullfile(scenePath, dirList(3).name);
        
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
            'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});
        
        white_ref_cube = multibandread(white_ref_file, [cols 1 bands],...
            'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});
        
        whitedark_ref_cube = multibandread(white_dark_file, [cols 1 bands],...
            'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});
        
        dark_ref_cube = multibandread(dark_ref_file, [cols 1 bands],...
            'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

        % Reconstruct RGB image from the cube
        dummyRGB = zeros(512, 512, 3, 'uint8');
        br = 30;
        dummyRGB(:,:,1) = uint8(hsi_cube(:,:,26) / 16) + br;
        dummyRGB(:,:,2) = uint8(hsi_cube(:,:,53) / 16) + br + 10;
        dummyRGB(:,:,3) = uint8(hsi_cube(:,:,104) / 16) + br + 15;
        
        if (simultaneousRef)
            % Get white spot from the image and correct the data cube
            
        else
            [correctd_hsi_cube, error] = Calibrate_Spectral_Image(hsi_cube, whitedark_ref_cube,...
                dark_ref_cube);
        end
        
        % Plot the spectral distribution for one point in the image
        [wh_ref_h, wh_ref_w, wh_ref_d] = size(whitedark_ref_cube);
        
        X_axis = linspace(1, wh_ref_d, wh_ref_d);
        Y_WD = zeros(1, wh_ref_d);
        Y_W = zeros(1, wh_ref_d);
        Y_D = zeros(1, wh_ref_d);
                
        for i = 1:wh_ref_d
            Y_D(1,i) = mean (dark_ref_cube(:,1,i));
            Y_WD(1,i) = mean (whitedark_ref_cube(:,1,i));
            Y_W(1,i) = mean (white_ref_cube(:,1,i));
        end
        
        figure()
        plot(X_axis, Y_D, 'b', 'LineWidth', 2)
        hold on
%         plot(X_axis, Y_WD, 'r', 'LineWidth', 2)
%         hold on
        plot(X_axis, Y_W, 'g', 'LineWidth', 2)
        hold off

        
%         if (img_count == 1)
%             % 
%         end

       
        % 
    end
end

% Get the list of minimum bands

% Create minimum band images

% Call classifier

% Save RGB image

% Save classification result