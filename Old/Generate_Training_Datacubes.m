function Generate_Training_Datacubes(class_name, selected_datacube)

    fileFormat = 'bil';
    fileName = strcat(class_name, '.',  fileFormat);
    
    hdrFormat = 'txt';
    hdrName = strcat(class_name, '.',  hdrFormat);
    
    header_data = size(selected_datacube);
    
    % Write data file as a class
    % multibandwrite(hhh_2,'background.bil','bil');
    
    writematrix(header_data, hdrName, 'Delimiter', ',');
    
    multibandwrite(selected_datacube, fileName, fileFormat);
end