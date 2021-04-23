
sample_cube = sky_cube;
bandNumber = 10;

[cube_h, cube_w, d] = size(sample_cube);

mono_image = zeros(cube_h, cube_w, 3, 'uint8');


for i = 1:cube_h
    for j = 1: cube_w
        mono_image(i, j, 1) = uint8(sample_cube(i, j, 18) * 255);
        mono_image(i, j, 2) = uint8(sample_cube(i, j, 58) * 255);
        mono_image(i, j, 3) = uint8(sample_cube(i, j, 85) * 255);
    end
end

% mono_image = imrotate(mono_image, -90);
figure();
imshow(mono_image);