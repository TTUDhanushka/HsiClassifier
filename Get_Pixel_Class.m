function class_color = Get_Pixel_Class(rgb_image)
       
    % Get the dimensions of the image.  numberOfColorBands should be = 1.
    [rows columns numberOfColorBands] = size(rgb_image(:,:,1));

    % Display the original gray scale image.
    subplot(1, 2, 1);
    imshow(rgb_image, []);
    title('Original color Image');

    % Enlarge figure to full screen.
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    set(gcf,'name','Image Analysis Demo','numbertitle','off') 

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
    croppedImage = rgb_image(y(1):y(3), x(1):x(2), :);
    
    % Display the cropped gray scale image.
    subplot(1, 2, 2);
    imshow(croppedImage);
    title('Picked color Image');


    class_color = croppedImage(1,1,:);
   
end