%% Geo HSI image analysis

% Use NASA and Botswana images in mat format.
% Reduce number of bands

clc;

%% Display slice of the image

[h, w, d] = size(KSC);

im_slice = KSC(:,:,10);     % Display 10th band of the image
subplot(1,2,1);
imshow(uint8(im_slice));    % Convert to uint8 as double type can't be used for images
title('KSC image slice 10');

%% Band reduction with pooling

linear_image = UnfoldHsiCube(KSC);

pool_layers = Max_Pooling(linear_image, 10);

[samples, band_count] = size(pool_layers);
selected_bands = zeros(1,band_count);

for k = 1:band_count
    column_id = round(mean(pool_layers(:,k))); 
    selected_bands(1,k) = column_id;
end

%% Band reduced image

reduced_hsi_image = ReducedBandImage(KSC, selected_bands);

reduced_slice = reduced_hsi_image(:,:,6);

%% Generate RGB image from original HSI image.

% This image contains 400 - 2500 nm wavelengths across 176 bands
% Pick the image bands correcponds to 460, 560, 670

rgb_image = uint8(zeros(h,w,3));

rgb_image(:,:,1) = uint8(KSC(:,:,5));
rgb_image(:,:,2) = uint8(KSC(:,:,13));
rgb_image(:,:,3) = uint8(KSC(:,:,22));

subplot(1,2,2);
imshow(rgb_image);
title('Reconstructed image from selected bands');

%% Choosing pixel classes

figure();

[im, im_x, im_y] = Select_Pixel_Class(KSC, rgb_image, false); 

%% Display segmented image according to the classes

seg_image = RectangleAreaOverlay(h, w, im_x, im_y);

figure();
imshow(seg_image);
title('Segmented image');

%% Extract the HSI pixels from reconstructued image

extracted_pixels = Extract_Training_Pixels(reduced_hsi_image, im_x, im_y); 

X_axis = linspace(0,band_count,band_count);
Y_axis = linspace(0,band_count,band_count);

figure();

for i = 1:2 %(green_cols * green_row)
    hold on
    for j = 1:10
        for k = 1: band_count
            Y_axis(1,k) = extracted_pixels(i,j,k);
        end
        plot(X_axis, Y_axis);
    end


end

hold off

%% Write data file as a class
% water = extracted_pixels;
% salt_marsh = extracted_pixels;
scrub = extracted_pixels;

% multibandwrite(extracted_pixels,'water.bil','bil');
% multibandwrite(extracted_pixels,'brown_apple.bil','bil');
% multibandwrite(extracted_pixels,'green_apple.bil','bil');

% multibandwrite(reduced_hsi_image,'reduced_hsi_image.bil','bil');