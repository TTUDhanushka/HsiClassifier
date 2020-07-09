function [rgb_file, hdr_file, hsi_file, white_ref_cube, white_ref_hdr,...
    dark_ref_cube, dark_ref_hdr, white_dark_cube, white_dark_hdr] = GetDataFiles_V2(directory_path, simultaneous)

    file_list = dir(directory_path);

    files = strings(length(file_list),1);

    for i = 1 : length(file_list)
        files(i) = file_list(i).name;

        if contains(file_list(i).name, '.png')
            rgb_file_name = file_list(i).name;
            rgb_file = strcat (directory_path, rgb_file_name);
        end

        % Specim stores all the captured data in a inner directory called
        % 'capture'

        if contains(file_list(i).name, 'capture')
            str_temp = strcat(directory_path, file_list(i).name);
            capture_data_list = dir(str_temp);

            header_files = string(3);
            raw_files = string(3);
            hdr_index = 1;
            raw_index = 1;

            % Search for white reference, dark reference, header, data cube
            for j = 1 : length(capture_data_list)
                if contains(capture_data_list(j).name, '.hdr')
                    header_files(hdr_index) = capture_data_list(j).name;
                    hdr_index = hdr_index + 1;

                    if (not (contains(capture_data_list(j).name,'DARKREF_'))) && (~contains(capture_data_list(j).name,'WHITEREF_'))                       
                        hdr_file = strcat(str_temp, '\',capture_data_list(j).name);                         
                    elseif (contains(capture_data_list(j).name,'DARKREF_'))                        
                        dark_ref_hdr = strcat(str_temp, '\',capture_data_list(j).name);                        
                    elseif (contains(capture_data_list(j).name,'WHITEREF_'))
                        white_ref_hdr = strcat(str_temp, '\',capture_data_list(j).name);
                    end

                elseif contains(capture_data_list(j).name, '.raw')
                    raw_files(raw_index) = capture_data_list(j).name;
                    raw_index = raw_index + 1;

                    if (not (contains(capture_data_list(j).name,'DARKREF_'))) && (~contains(capture_data_list(j).name,'WHITEREF_'))
                        hsi_file = strcat(str_temp, '\',capture_data_list(j).name); 
                    elseif (contains(capture_data_list(j).name,'DARKREF_'))                        
                        dark_ref_cube = strcat(str_temp, '\',capture_data_list(j).name);                        
                    elseif (contains(capture_data_list(j).name,'WHITEREF_'))
                        white_ref_cube = strcat(str_temp, '\',capture_data_list(j).name);
                    end
                end
            end
        end
    end

end