function rmse = RootMeanSquareError(image1, image2)
    [h1, w1, d1] = size(image1);
    [h2, w2, d2] = size(image2);
    
    image1 = double(image1);
    image2 = double(image2);
    
    if d1 ~= d2
        sprintf("Error: Image color channels are not equal.");
        rmse = 0;
    end
    
    if (h1 == h2) && (w1 == w2)
        for i = 1:h1
            for j = 1:w1
                rmse = sqrt((((image1(i, j, 1) - image2(i, j, 1))^2) +...
                    ((image1(i,j, 2) - image2(i,j, 2))^2) +...
                    ((image1(i,j, 3) - image2(i,j, 3))^2)) / (h1 * w1));
            end
        end
    else
        sprintf("Error: Scale the image.");
    end
    
end

