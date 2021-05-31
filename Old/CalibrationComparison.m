% Image correction methods

% Call read specim daa if the data not in workspace.

%% Declare variables

[w, h, d] = size(hsi_cube);

calib_cube_1 = zeros(w, h, d);
calib_cube_2 = zeros(w, h, d);

% White/Dark reference average
white_ref_avg = zeros(1, d);
dark_ref_avg = zeros(1, d);

%% Method 1:

% Use pixel values to correct the image
for i = 1:d
    for j=1:h
        for k = 1:w
             calib_cube_1(k, j, i) = ((hsi_cube(k, j, i) - dark_ref_cube(k, 1, i)) / (white_ref_cube(k, 1, i) - dark_ref_cube(k, 1, i))) * 255;
        end
    end
end

%% Method 2:

for i = 1:d
    dark_ref_avg(1,i) = mean (dark_ref_cube(:,1,i));
    white_ref_avg(1,i) = mean (white_ref_cube(:,1,i));
end

% Use pixel values to correct the image
for i = 1:d
    for j=1:h
        for k = 1:w
             calib_cube_2(k, j, i) = ((hsi_cube(k, j, i) - dark_ref_avg(1,i)) / (white_ref_avg(1,i) - dark_ref_avg(1,i))) * 255;
        end
    end
end

%% Plot the calibration image slices.

% Method 1 with each pixel element calibration.
slice = uint8(calib_cube_1(:,:,150));

slice_2 = uint8(calib_cube_2(:,:,150));

figure()
subplot(1,2,1), imshow(slice)
subplot(1,2,2), imshow(slice_2)
