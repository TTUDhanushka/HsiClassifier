%% Test neural networks

read_from_file = false;

if read_from_file
    
    % Image source is the camera type.
    image_source = 'specim';
    
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
    
    NN_result = zeros(cols, lines, no_of_classes, 'uint8');
    
    test_in = zeros(hsi_bands,1);
    
    count = 0;
    f = waitbar(0);
    
    for i = 1:cols
        for j = 1:lines
            for x = 1:hsi_bands
                test_in(x,1) = correctd_hsi_cube(i, j, x);
            end
            
            NN_result(i,j,:) = uint8(255 * (sim(net, test_in)));
        end
        
        count = count + 1;
        percentage = (count / 512) * 100;
        
    end
    
else
    cols = 512;
    lines = 512;
    hsi_bands = 25;
    
    hsi_file = 'reduced_hsi_image_min.bil';
    
    hsi_cube = multibandread(hsi_file, [cols lines hsi_bands],...
        'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});
    
    
    % Convert cube to plane
    linear_image = Convert_to_1d_Spectral(hsi_cube);
    [l_h, l_d] = size(linear_image);
    
    NN_result = zeros(l_h, no_of_classes, 'uint8');
        
    test_in = zeros(hsi_bands,1);
    
    parfor i = 1:l_h
        
        test_in = linear_image(i, :);
        
        NN_result(i, :) = uint8(255 * (sim(two_layer_net, test_in')));
        
    end
end
    


%% Display classified output

classified_image = zeros(cols, lines, 3, 'uint8');


for i = 1: l_h

    [res_val, res_ind] = max(NN_result(i,:));
    
    c_h = floor((i - 1) / cols) + 1;
    c_w = (i-1) - ((c_h - 1) * cols) + 1;
    classified_image(c_h, c_w, :) = Get_Masking_Color(no_of_classes, res_ind);

end

%% Results export to separate folder.

currentFolder = pwd;

results_dir_path = strcat(currentFolder,'\', 'Results');

if ~exist(results_dir_path)
   mkdir(results_dir_path)
end

results_file = strcat(results_dir_path, '\', 'class_file', '.png');

figure();
classified_image = imrotate(classified_image,-90);
imshow(classified_image);

% Wrtie the result image to disk
imwrite(classified_image, results_file);