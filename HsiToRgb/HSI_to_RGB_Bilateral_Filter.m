% Bands range as follows for specim camera.

redWavelengthRange = [560, 680];
greenWavelengthRange = [450, 630];
blueWavelengthRange = [420, 500];

redBandRange = [67, 97];
greenBandRange = [37, 68];
blueBandRange = [9, 36];

alpha = 0.02;                   % As a constant
sigmaR = zeros(1, bands);

sample_cube = reflectanceCube.DataCube;

[cube_h, cube_w, d] = size(sample_cube);

I = zeros(cube_h, cube_w, 1, 'double');

%% For the red group

for bandR = redBandRange(1):redBandRange(2)
    for i = 1:cube_h
        for j = 1: cube_w
            I(i, j) = double(sample_cube(i, j, bandR) * 255);
        end
    end
    
    Ibf_red(:,:,bandR - redBandRange(1) + 1) = imbilatfilt(I);
end

nR = redBandRange(2) - redBandRange(1);

weightsAvgR = zeros(cube_h, cube_w, 1, 'double');
weightsR = zeros(cube_h, cube_w, nR, 'double');

Kr = 50;

for bandR = redBandRange(1):redBandRange(2)
    for i = 1:cube_h
        for j = 1: cube_w
            weightsAvgR(i, j) = weightsAvgR(i, j) + double(abs(uint8(sample_cube(i, j, bandR) * 255) - Ibf_red(i,j,bandR - redBandRange(1) + 1)) + Kr);
        end
    end
    
end

If_red = zeros(cube_h, cube_w, 1, 'double');

% for bandR = redBandRange(1):redBandRange(2)
%     for i = 1:cube_h
%         for j = 1: cube_w
%             weightsR(i, j, bandR - redBandRange(1) + 1) = double(abs(uint8(sample_cube(i, j, bandR) * 255) - Ibf_red(i,j,bandR - redBandRange(1) + 1)) + Kr) / weightsAvgR(i, j);
%             If_red(i,j) = weightsR(i, j, bandR - redBandRange(1) + 1) * (sample_cube(i, j, bandR) * 255);
%         end
%     end
% end

%% For the green group

for bandG = greenBandRange(1):greenBandRange(2)
    for i = 1:cube_h
        for j = 1: cube_w
            I(i, j) = uint8(sample_cube(i, j, bandG) * 255);
        end
    end
    
    Ibf_green(:,:,bandG - greenBandRange(1) + 1) = imbilatfilt(I);
end

nG = greenBandRange(2) - greenBandRange(1);

weightsAvgG = zeros(cube_h, cube_w, 1, 'double');
weightsG = zeros(cube_h, cube_w, nG, 'double');

Kg = 50;

for bandG = greenBandRange(1):greenBandRange(2)
    for i = 1:cube_h
        for j = 1: cube_w
            weightsAvgG(i, j) = weightsAvgG(i, j) + double(abs(uint8(sample_cube(i, j, bandG) * 255) - Ibf_green(i,j,bandG - greenBandRange(1) + 1)) + Kg);
        end
    end
    
end

If_green = zeros(cube_h, cube_w, 1, 'double');

% for bandG = greenBandRange(1):greenBandRange(2)
%     for i = 1:cube_h
%         for j = 1: cube_w
%             weightsG(i, j, bandG - greenBandRange(1) + 1) = double(abs(uint8(sample_cube(i, j, bandG) * 255) - Ibf_green(i,j,bandG - greenBandRange(1) + 1)) + Kg) / weightsAvgG(i, j);
%             If_green(i,j) = weightsG(i, j, bandG - greenBandRange(1) + 1) * (sample_cube(i, j, bandG) * 255);
%         end
%     end 
% end

%% Blue wavelength group

for bandB = blueBandRange(1):blueBandRange(2)
    for i = 1:cube_h
        for j = 1: cube_w
            I(i, j) = uint8(sample_cube(i, j, bandB) * 255);
        end
    end
    
    Ibf_blue(:,:,bandB - blueBandRange(1) + 1) = imbilatfilt(I);
end

nB = blueBandRange(2) - blueBandRange(1);

weightsAvgB = zeros(cube_h, cube_w, 1, 'double');
weightsB = zeros(cube_h, cube_w, nB, 'double');

Kb = 50;

for bandB = blueBandRange(1):blueBandRange(2)
    for i = 1:cube_h
        for j = 1: cube_w
            weightsAvgB(i, j) = weightsAvgB(i, j) + double(abs(uint8(sample_cube(i, j, bandB) * 255) - Ibf_blue(i,j,bandB - blueBandRange(1) + 1)) + Kb);
        end
    end
    
end

If_blue = zeros(cube_h, cube_w, 1, 'double');

% for bandB = blueBandRange(1):blueBandRange(2)
%     for i = 1:cube_h
%         for j = 1: cube_w
%             weightsB(i, j, bandB - blueBandRange(1) + 1) = double(abs(uint8(sample_cube(i, j, bandB) * 255) - Ibf_blue(i,j,bandB - blueBandRange(1) + 1)) + Kb) / weightsAvgB(i, j);
%             If_blue(i,j) = weightsB(i, j, bandB - blueBandRange(1) + 1) * (sample_cube(i, j, bandB) * 255);
%         end
%     end
% end
%% Added

weightsAvgOverall = zeros(cube_h, cube_w, 1, 'double');

for i = 1:cube_h
    for j = 1: cube_w
        weightsAvgOverall(i, j) = (weightsAvgR(i, j) + weightsAvgG(i, j) + weightsAvgB(i, j)) / 3;
    end
end
    

for bandR = redBandRange(1):redBandRange(2)
    for i = 1:cube_h
        for j = 1: cube_w
            weightsR(i, j, bandR - redBandRange(1) + 1) = double(abs(uint8(sample_cube(i, j, bandR) * 255) - Ibf_red(i,j,bandR - redBandRange(1) + 1)) + Kr) / weightsAvgOverall(i, j);
            If_red(i,j) = If_red(i,j) + weightsR(i, j, bandR - redBandRange(1) + 1) * (sample_cube(i, j, bandR) * 255);
        end
    end
end

for bandG = greenBandRange(1):greenBandRange(2)
    for i = 1:cube_h
        for j = 1: cube_w
            weightsG(i, j, bandG - greenBandRange(1) + 1) = double(abs(uint8(sample_cube(i, j, bandG) * 255) - Ibf_green(i,j,bandG - greenBandRange(1) + 1)) + Kg) / weightsAvgOverall(i, j);
            If_green(i,j) = If_green(i,j) + weightsG(i, j, bandG - greenBandRange(1) + 1) * (sample_cube(i, j, bandG) * 255);
        end
    end 
end

for bandB = blueBandRange(1):blueBandRange(2)
    for i = 1:cube_h
        for j = 1: cube_w
            weightsB(i, j, bandB - blueBandRange(1) + 1) = double(abs(uint8(sample_cube(i, j, bandB) * 255) - Ibf_blue(i,j,bandB - blueBandRange(1) + 1)) + Kb) / weightsAvgOverall(i, j);
            If_blue(i,j) = If_blue(i,j) + weightsB(i, j, bandB - blueBandRange(1) + 1) * (sample_cube(i, j, bandB) * 255);
        end
    end
end



%%

Img_Bil_Fil = zeros(cols, lines, 3, 'uint8');
Img_Bil_Fil(:,:,1) = uint8(If_red(:,:));
Img_Bil_Fil(:,:,2) = uint8(If_green(:,:));
Img_Bil_Fil(:,:,3) = uint8(If_blue(:,:));

figure()
Img_Bil_Fil = imrotate(Img_Bil_Fil, -90);
imshow(Img_Bil_Fil);

