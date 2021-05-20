function [topLeft, btmRight] = PickUpPixelArea(image) 
    
    figure;
    imshow(image, []);
    title('Select pixels');

    % Draw a box to select pixels.
    message = sprintf('Draw a box to define the area');
    uiwait(msgbox(message));
    
    % Mouse button press    
    k = waitforbuttonpress;
    point1 = get(gca,'CurrentPoint');    % button down detected
    finalRect = rbbox;                   % return figure units
    point2 = get(gca,'CurrentPoint');    % button up detected
    
    topLeft = int16([point1(1, 2), point1(1, 1)]);
    btmRight = int16([point2(1, 2), point2(1, 1)]);
    
    for x = 1:finalRect(4)
        for y = 1:finalRect(3)
            image(topLeft(1) + x, topLeft(2) + y, :) = [0, 0, 255];
        end
    end
    
    imshow(image, []);
end