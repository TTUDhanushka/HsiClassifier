%% View HSI image slices

%% Import data
image_source = 'specim';
WavelengthNeeded = 705;         % Wavelength in nm
wavelengthRange = [400 1000];

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

rgb_image = imread(rgb_file);

%% Image correction

% image = multibandread('tst0012.fits', [31 73 5], ...
%                     'int16', 74880, 'bil', 'ieee-be', ...
%                     {'Band', 'Range', [1 3]} );

hsi_cube = multibandread(hsi_file, [cols lines bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

white_ref_cube = multibandread(white_ref_file, [cols 1 bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});

dark_ref_cube = multibandread(dark_ref_file, [cols 1 bands],...
    'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});


[correctd_hsi_cube, error] = Calibrate_Spectral_Image(hsi_cube, white_ref_cube,...
    dark_ref_cube);

% Show slice from corrected RGB image

mono_image = zeros(cols, lines, 1, 'uint8');


bandNumber = uint8((bands/(wavelengthRange(2) - wavelengthRange(1))) * (WavelengthNeeded - wavelengthRange(1)));

for i = 1:cols
    for j = 1: lines
        mono_image(i, j) = uint8(correctd_hsi_cube(i, j, bandNumber));
    end
end

imshow(rgb_image);

mono_image = imrotate(mono_image, -90);
figure();
imshow(mono_image);