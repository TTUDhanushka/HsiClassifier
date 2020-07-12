clc;

close all;

% Image source is the camera type.
image_source = 'specim';

% Generate false RGB images from HSI
directory_path = uigetdir;

directory_path = strcat(directory_path,'\');

%% Get the data file paths from the data directory.

% RGB preview file
rgb_file = '';
header_file = '';
hsi_file = '';

[rgb_file, header_file, hsi_file, white_ref_file,...
    white_ref_hdr, dark_ref_file, dark_ref_hdr] = GetDataFiles(directory_path);

% Get the header data
[cols, lines, bands, wave] = ReadHeader(header_file, image_source);

hsi_cube = multibandread(hsi_file, [cols lines bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

white_ref_cube = multibandread(white_ref_file, [cols 1 bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

dark_ref_cube = multibandread(dark_ref_file, [cols 1 bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});


[correctd_hsi_cube, error] = Calibrate_Spectral_Image(hsi_cube, white_ref_cube,...
    dark_ref_cube);


%% XYZ to sRGB conversion

% Call CIE lookup table script
cie_lut;

[lut_len, lut_cols] = size(cie_lut_val);

K = zeros(cols, 1);

output_image = zeros(cols, lines, 3,'uint8');

for i = 1:cols
    sum_Ey = 0;
    
    for j = 1:lut_len
        sum_Ey = sum_Ey + ((white_ref_cube(i,1,j) /4096) * cie_lut_val(j, 3)); %1.12
        
    end
    
    K(i,1) =  100; %sum_Ey;
end

% T = [0.41847 -0.15866 -0.082835;
%     -0.091169 0.25243 0.015708;
%     0.0009209 -0.0025498 0.17860];


T = [3.2406 -1.5372 -0.4986;
    -0.9689 1.8758 0.0415;
    0.0557 -0.2040 1.0570];

for i = 1:cols
    for j = 1:lines
        X_temp = 0.0;
        Y_temp = 0.0;
        Z_temp = 0.0;
        
        for k = 1:lut_len
            X_temp = X_temp + ((correctd_hsi_cube(i,j,k)/4096) * 7.22 * cie_lut_val(k, 2)); %(white_ref_cube(i,1,k) / 4096)
            Y_temp = Y_temp + ((correctd_hsi_cube(i,j,k)/4096) * 6.85 * cie_lut_val(k, 3));
            Z_temp = Z_temp + ((correctd_hsi_cube(i,j,k)/4096) * 7.05 * cie_lut_val(k, 4));
        end
        
        X_lamda = (100 / K(i,1)) * X_temp;
        Y_lamda = (100 / K(i,1)) * Y_temp;
        Z_lamda = (100 / K(i,1)) * Z_temp;
        
        XYZ = [X_lamda Y_lamda Z_lamda];
        
        % RGB = xyz2rgb(XYZ);
        RGB = T * XYZ'
        output_image(i,j,:) = RGB;
        
    end
    current = i
end

output_image = imrotate(output_image, -90);
imshow(output_image)
