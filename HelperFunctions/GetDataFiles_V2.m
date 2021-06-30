function [rgb_file, hdr_file, hsi_file, dark_ref_cube, dark_ref_hdr, ...
     white_dark_cube, white_dark_hdr, reflectance_cube, reflectance_hdr,...
     ground_truth_File, simul_white_ref, rgbHighRes] = GetDataFiles_V2(directory_path)

    % Specim IQ camera images contain white reference and dark reference
    % cube for simulataneos aquisition mode images. In this case, there 
    % should be a calibration pad in the image. For pre-set white reference
    % images, it will create additional file which is "whitedarkref". This
    % function only for the second type images which doesn't contain white
    % reference in the image but there is pre-set white reference.
    
    file_list = dir(directory_path);

    [path, folder_name, ext] = fileparts(directory_path);
    
    hdr_ext = '.hdr'; 
    raw_ext = '.raw';
    reflectance_data_ext = '.dat';
    
    darkref_name = 'DARKREF_';
    white_dark_ref_name = 'WHITEDARKREF_';
    white_ref_name = 'WHITEREF_';
    reflectance_cube_name = 'REFLECTANCE_';
    
    ground_truth_File = ' ';
    white_dark_hdr = ' ';
    white_dark_cube = ' ';
    
    files = strings(length(file_list),1);

    for i = 1 : length(file_list)
        files(i) = file_list(i).name;

        if (contains(file_list(i).name, '.png') && not(contains(file_list(i).name, 'gt'))&& not(contains(file_list(i).name, 'GT')))
            rgb_file_name = file_list(i).name;
            rgb_file = fullfile (directory_path, rgb_file_name);
        elseif (contains(file_list(i).name, '.png') && ((contains(file_list(i).name, 'gt')) || (contains(file_list(i).name, 'GT'))))
            ground_truth_File = file_list(i).name;
        end

        % Specim stores all the captured data in a inner directory called
        % 'capture'

        if contains(file_list(i).name, 'capture')
            str_temp = fullfile(directory_path, file_list(i).name);
            capture_data_list = dir(str_temp);
            
            header_files = string(3);
            raw_files = string(3);
            hdr_index = 1;
            raw_index = 1;
            
            if length(capture_data_list) > 8
                simul_white_ref = true;
            else
                simul_white_ref = false;
            end
            
             
            % Search for white reference, dark reference, header, data cube
            for j = 1 : length(capture_data_list)
                if contains(capture_data_list(j).name, hdr_ext)
                    header_files(hdr_index) = capture_data_list(j).name;
                    hdr_index = hdr_index + 1;

                    if (not (contains(capture_data_list(j).name, darkref_name))) && (~contains(capture_data_list(j).name, white_ref_name) && (~contains(capture_data_list(j).name, white_dark_ref_name)))                       
                        hdr_file = strcat(str_temp, '\',capture_data_list(j).name);                         
                    elseif (contains(capture_data_list(j).name, darkref_name) && (~contains(capture_data_list(j).name, white_dark_ref_name)))                        
                        dark_ref_hdr = strcat(str_temp, '\',capture_data_list(j).name);                        
                    elseif (contains(capture_data_list(j).name, white_ref_name))
                        white_dark_hdr = strcat(str_temp, '\',capture_data_list(j).name);
                    end

                elseif contains(capture_data_list(j).name, raw_ext)
                    raw_files(raw_index) = capture_data_list(j).name;
                    raw_index = raw_index + 1;

                    if (not (contains(capture_data_list(j).name, darkref_name))) && (~contains(capture_data_list(j).name, white_ref_name)) && (~contains(capture_data_list(j).name, white_dark_ref_name))
                        hsi_file = strcat(str_temp, '\',capture_data_list(j).name); 
                    elseif (contains(capture_data_list(j).name, darkref_name) && (~contains(capture_data_list(j).name, white_dark_ref_name)))                        
                        dark_ref_cube = strcat(str_temp, '\',capture_data_list(j).name);                        
                    elseif (contains(capture_data_list(j).name, white_ref_name))
                        white_dark_cube = strcat(str_temp, '\',capture_data_list(j).name);
                    end
                end
            end

        end 
        
        % Results folder contains reflectances.
        if contains(file_list(i).name, 'results')
            
            str_temp = fullfile(directory_path, file_list(i).name);
            results_file_struct = dir(str_temp);
            
            results_file_list = strings(length(results_file_struct), 1);
             
            for idx = 1:length(results_file_struct)
                results_file_list(idx) = results_file_struct(idx).name;
                
                if (contains(results_file_struct(idx).name, hdr_ext))
                    reflectance_hdr = strcat(str_temp, '\', results_file_struct(idx).name);
                elseif (contains(results_file_struct(idx).name, reflectance_data_ext))
                    reflectance_cube = strcat(str_temp, '\', results_file_struct(idx).name);
                elseif (contains(results_file_struct(idx).name, 'RGBBACKGROUND') && contains(results_file_struct(idx).name, '.png'))
                    rgbHighRes = strcat(str_temp, '\', results_file_struct(idx).name);
                end
                
            end
            
            if ~isfile(reflectance_hdr)
                fprintf("Header doesn't exist.")
            end
            
            if ~isfile(reflectance_cube)
                fprintf("Reflectance cube doesn't exist.")
            end
                                             
        end
        
        
    end

end