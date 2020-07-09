function [rgb_file, hdr_file, hsi_file, white_ref_cube, white_ref_hdr,...
    dark_ref_cube, dark_ref_hdr, white_dark_cube, white_dark_hdr] = GetDataFiles_V2(directory_path)

    % Specim IQ camera images contain ehite reference and dark reference
    % cube for simulataneos aquisition mode images. In this case, there 
    % should be a calibration pad in the image. For pre-set white reference
    % images, it will create additional file which is "whitedarkref". This
    % function only for the second type images which doesn't contain white
    % reference in the image but there is pre-set white reference.
    
    file_list = dir(directory_path);

    [path, folder_name, ext] = fileparts(directory_path);
    
    hdr_ext = '.hdr'; 
    raw_ext = '.raw';
    
    darkref_name = 'DARKREF_';
    white_dark_ref_name = 'WHITEDARKREF_';
    white_ref_name = 'WHITEREF_';
    
    files = strings(length(file_list),1);

    for i = 1 : length(file_list)
        files(i) = file_list(i).name;

        if contains(file_list(i).name, '.png')
            rgb_file_name = file_list(i).name;
            rgb_file = fullfile (directory_path, rgb_file_name);
        end

        % Specim stores all the captured data in a inner directory called
        % 'capture'

        if contains(file_list(i).name, 'capture')
            str_temp = fullfile(directory_path, file_list(i).name);
            capture_file_struct = dir(str_temp);
            
            capture_file_list = strings(length(capture_file_struct), 1);
             
            for idx = 1:length(capture_file_struct)
                capture_file_list(idx) = capture_file_struct(idx).name;
            end
            
            content_files_list = strings(10, 1);
             
            hdr_file = strcat(str_temp, '\', folder_name, hdr_ext);
            dark_ref_hdr = strcat(str_temp, '\', darkref_name, folder_name, hdr_ext);
            white_dark_hdr = strcat(str_temp, '\', white_dark_ref_name, folder_name, hdr_ext);
            white_ref_hdr = strcat(str_temp, '\', white_ref_name, folder_name, hdr_ext);
            
            hsi_file = strcat(str_temp, '\', folder_name, raw_ext);
            dark_ref_cube = strcat(str_temp, '\', darkref_name, folder_name, raw_ext);
            white_dark_cube = strcat(str_temp, '\', white_dark_ref_name, folder_name, raw_ext);
            white_ref_cube = strcat(str_temp, '\', white_ref_name, folder_name, raw_ext);
                    
            content_files_list(1) = '.';
            content_files_list(2) = '..';
            
            content_files_list(3) = strcat(folder_name, hdr_ext);
            content_files_list(4) = strcat(darkref_name, folder_name, hdr_ext);
            content_files_list(5) = strcat(white_dark_ref_name, folder_name, hdr_ext);
            content_files_list(6) = strcat(white_ref_name, folder_name, hdr_ext);            
            
            content_files_list(7) = strcat(folder_name, raw_ext);
            content_files_list(8) = strcat(darkref_name, folder_name, raw_ext);
            content_files_list(9) = strcat(white_dark_ref_name, folder_name, raw_ext);
            content_files_list(10) = strcat(white_ref_name, folder_name, raw_ext);
            
            files_in_capture = sort(capture_file_list);
            files_should_in = sort(content_files_list);
            
            if ~(isequal(files_in_capture, files_should_in))
                fprintf("Files not in the folder");
            end

        end
    end

end