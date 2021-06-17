% This is only for the PixelLabelData created using ImageLabeller.

% The ImageLabeller generated gTruth variable in the workspace


labelImg = imread(string(gTruth.LabelData{:,:}));

[h,w] = size(labelImg);

rgbImageVis = zeros(h, w, 3,'uint8');

for i = 1:h
    for j = 1:w
        id = 1;
        
        if (labelImg(i, j) == 0)
            id = 1;
        else
            id = Get_Label_Color(labelImg(i, j));
        end
        
        rgbImageVis(i,j, :) = id;
    end
end

figure();
imshow(rgbImageVis);
