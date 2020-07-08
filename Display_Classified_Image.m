function image = Display_Classified_Image(image, posx, posy, color)
    
    % Image has been captured from left to right.
    y_1 = fix (posx(1,1));
    x_1 = fix (posx(1,2));
    y_2 = fix (posy(1,1));
    x_2 = fix (posy(1,2));
    
    for i = x_1:x_2
        for j = y_1:y_2
            image(i,j,:) = color;
        end
    end
                
end