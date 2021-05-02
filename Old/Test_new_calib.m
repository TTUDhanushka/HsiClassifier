

[h, w, d] = size(hsi_cube);
    
    
New_cube = zeros(h, w, d);

for i = 1:h
    for j = 1:w
        for k = 1:d
            New_cube(i,j,k) = ((hsi_cube(i,j,k) - dark_ref_avg(k)) / (Y(k) - dark_ref_avg(k)));
        end
    end
end

new_rgb = Construct_False_Rgb_Image(New_cube, 18, 58,85);

figure();
imshow(new_rgb)
