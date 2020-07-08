function [cols, lines, bands, wave] = ReadHeader(file_name, image_source)
    
    file_ID = fopen(file_name, 'r');
    read_wavelengths = false;
    str_lines = [];
    wave = [];
    bands = 1;
    
    switch image_source
        case 'specim'
            data = fgetl(file_ID);
            
            while ischar(data)
                data = fgetl(file_ID);
                
                str_lines = [str_lines {data}];                                  
            end
            
            data_lines = length(str_lines);
            read_count = 0;
            
            for c = 1 : (data_lines - 1)
                tline = str_lines(1,c);
                
                if contains(tline, 'samples')
                    str_bands = split(tline, '=');
                    temp = cell2mat(strtrim(str_bands(2,:)));
                    
                    cols = str2num(temp);
                end
                
                if contains(tline, 'lines')
                    str_bands = split(tline, '=');
                    temp = cell2mat(strtrim(str_bands(2,:)));
                    
                    lines = str2num(temp);
                end
                
                % Check for the bands count                
                if ((contains(tline, 'bands')) && (~contains(tline, 'default bands')))
                    str_bands = split(tline, '=');
                    temp = cell2mat(strtrim(str_bands(2,:)));

                    bands = str2num(temp);   
                    
                    % Declare a vector for all the wavelength bands
                    wave = zeros(bands,1);
                end

                
                if read_wavelengths
                    
                    temp_str = split(tline, '{');
                    l = char(temp_str);
                    B = convertCharsToStrings(l);
                    
                    match = ["'", ","];
                    
                    m = erase(B, match);
                    
                    % Avoid reading non-numeric characters which comes at
                    % the end of the strem.
                    if read_count < (bands + 1)
                        wave(read_count,1) = str2num(m);
                    end

                    read_count = read_count + 1;
                end
                
                % Get all the wavelength bands
                if (contains(tline, 'wavelength'))
                    read_wavelengths = true;
                    read_count = 1;
                  
                end
            end
                       
        case 'resonon'
        case 'ximea'
    end
     
    
    fclose(file_ID);
    
end