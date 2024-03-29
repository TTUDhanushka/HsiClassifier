function RgbImage = RGB_From_CIE_V2(correctd_hsi_cube, white_ref_cube)

    % XYZ to sRGB conversion

    % Call CIE lookup table script
    cie_lut;
    [lines, cols, bands] = size(correctd_hsi_cube);
    [lut_len, lut_cols] = size(cie_lut_val);

    K = zeros(cols, 1);

    output_image = zeros(cols, lines, 3,'uint8');

    for i = 1:cols
        sum_Ey = 0;

        for j = 1:lut_len
            sum_Ey = sum_Ey + ((white_ref_cube(i,1,j) /4096) * cie_lut_val(j, 3)); %1.12

        end

        K(i,1) =  100; %sum_Ey;
    end

    % T = [0.41847 -0.15866 -0.082835;
    %     -0.091169 0.25243 0.015708;
    %     0.0009209 -0.0025498 0.17860];


    T = [3.2406 -1.5372 -0.4986;
        -0.9689 1.8758 0.0415;
        0.0557 -0.2040 1.0570];

    for i = 1:cols
        for j = 1:lines
            X_temp = 0.0;
            Y_temp = 0.0;
            Z_temp = 0.0;

            for k = 1:lut_len
                X_temp = X_temp + ((correctd_hsi_cube(i,j,k)/4096) * 7.02 * cie_lut_val(k, 2)); %(white_ref_cube(i,1,k) / 4096)
                Y_temp = Y_temp + ((correctd_hsi_cube(i,j,k)/4096) * 6.99 * cie_lut_val(k, 3));
                Z_temp = Z_temp + ((correctd_hsi_cube(i,j,k)/4096) * 7.01 * cie_lut_val(k, 4));
            end

            X_lamda = (100 / K(i,1)) * X_temp;
            Y_lamda = (100 / K(i,1)) * Y_temp;
            Z_lamda = (100 / K(i,1)) * Z_temp;

            XYZ = [X_lamda Y_lamda Z_lamda];

            % RGB = xyz2rgb(XYZ);
            RGB = T * XYZ';
            output_image(i,j,:) = RGB;

        end
        current = i;
    end

    output_image = imrotate(output_image, -90);
    RgbImage = output_image;
end
