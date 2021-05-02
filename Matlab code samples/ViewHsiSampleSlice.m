
sample_cube = reflectanceCube.DataCube;

[cube_h, cube_w, d] = size(sample_cube);

falseRgbImage = zeros(cube_h, cube_w, 3, 'uint8');
A = zeros(cube_h, cube_w, 1, 'double');
B = zeros(cube_h, cube_w, 1, 'double');

for i = 1:cube_h
    for j = 1: cube_w
        falseRgbImage(i, j, 3) = uint8(sample_cube(i, j, 26) * 255);
        falseRgbImage(i, j, 2) = uint8(sample_cube(i, j, 51) * 255);
        falseRgbImage(i, j, 1) = uint8(sample_cube(i, j, 99) * 255);
        A(i, j) = double(sample_cube(i, j, 26));
        B(i, j) = double(sample_cube(i, j, 51));
    end
end

% mono_image = imrotate(mono_image, -90);
figure();
imshow(falseRgbImage);

%%

sample_cube = reflectanceCube.DataCube;

[cube_h, cube_w, d] = size(sample_cube);

singleBandImage = zeros(cube_h, cube_w, 1, 'uint8');


for i = 1:cube_h
    for j = 1: cube_w
        singleBandImage(i, j) = uint8(sample_cube(i, j, 38) * 255);
    end
end

% mono_image = imrotate(mono_image, -90);
figure();
imshow(singleBandImage);


%% Save image to directory

previewImageName = erase(rgb_file, '.png');
rgbImageName = '_gt.png';
path = strcat(previewImageName, rgbImageName);

imwrite(falseRgbImage, path);