%% HSI based image labeling pipeline

% Get images scene folder

workingFolder = pwd;

scenePath = uigetdir();
dirList = dir(scenePath);

% Image source is the camera type.
image_source = 'specim';

% Query all the images

for i = 1: length(dirList)
    if (~strcmp(dirList(i).name, '.') && ~strcmp(dirList(i).name, '..'))
        fprintf('Sub folder #%d = %s\n', i, dirList(i).name);

        directory_path = fullfile(scenePath, dirList(3).name);

        % Read the HSI data cube.
        rgb_file = '';
        header_file = '';
        hsi_file = '';

        [rgb_file, header_file, hsi_file, white_ref_file,...
            white_ref_hdr, dark_ref_file, dark_ref_hdr] = GetDataFiles(directory_path);

        % Get the header data
        [cols, lines, bands, wave] = ReadHeader(header_file, image_source);

        
        % 
    end
end

% Get the list of minimum bands

% Create minimum band images

% Call classifier

% Save RGB image

% Save classification result