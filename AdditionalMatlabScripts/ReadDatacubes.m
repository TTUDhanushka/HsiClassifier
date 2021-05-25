%

clc;
clear;

%%
% Reflectance 
reflectanceCube = hypercube("G:\3. Hyperspectral\1. Data cubes\2. Specim camera\2020-03-10_008\results\REFLECTANCE_2020-03-10_008.dat");

%captureCube = hypercube("G:\3. Hyperspectral\1. Data cubes\2. Specim camera\2020-03-10_008\capture\2020-03-10_008.raw");
%%
mono_image = zeros(512, 512, 1, 'uint8');


for i = 1:512
    for j = 1: 512
        mono_image(i, j) = uint8(reflectanceCube.DataCube(i, j, 18)*255);
    end
end

mono_image = imrotate(mono_image, -90);
figure();
imshow(mono_image);