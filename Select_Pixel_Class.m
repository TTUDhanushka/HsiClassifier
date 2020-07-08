function [training_pixels, p_1, p_2] = Select_Pixel_Class(rgb_image, file)
      
    if file == true
        grayImage = imread(rgb_image);
        grayImage = RotateRgbImage(grayImage, 90);
    else
        grayImage = rgb_image;
    end

   
    % Get the dimensions of the image.  numberOfColorBands should be = 1.
    [rows columns numberOfColorBands] = size(grayImage(:,:,1));

    % Display the original gray scale image.
    subplot(1, 2, 1);
    imshow(grayImage, []);
    title('Original Grayscale Image');

    % Enlarge figure to full screen.
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    set(gcf,'name','Extract samples','numbertitle','off') 

    message = sprintf('Draw a box');
    uiwait(msgbox(message));

    k = waitforbuttonpress;
    point1 = get(gca,'CurrentPoint');    % button down detected
    finalRect = rbbox;                   % return figure units
    point2 = get(gca,'CurrentPoint');    % button up detected
    point1 = point1(1,1:2);              % extract x and y
    point2 = point2(1,1:2);
    p1 = min(point1,point2);             % calculate locations
    offset = abs(point1-point2);         % and dimensions
    
    x = round([p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)]);
    y = round([p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)]);
    
    hold on
    axis manual
    plot(x,y)   
    croppedImage = grayImage(y(1):y(3), x(1):x(2));
    % Display the cropped gray scale image.
    
%     subplot(2, 2, 2);
%     imshow(croppedImage, []);
%     title('Cropped Image');

    % Make them color images.
    % Use the jet colormap
    training_pixels = uint8(255 * ind2rgb(croppedImage, jet));
    % Display the colorized cropped gray scale image.
    
%     subplot(2, 2, 3);
%     imshow(training_pixels, []);
%     title('Colorized Cropped Image');

    % Make the original image color.
    rgbImage = cat(3, grayImage(:,:,1), grayImage(:,:,2), grayImage(:,:,3));
    
    % Insert the colored portion:
    rgbImage(y(1):y(3), x(1):x(2), :) = training_pixels;
    
    % Display the colored gray scale image.
    subplot(1, 2, 2);
    imshow(rgbImage, []);
    title('Colorized Cropped Image Inserted');
    
    p_1 = fix(point1);
    p_2 = fix(point2);
end