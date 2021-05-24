%% Pixel pairs image rotation for thesis

% higResRgbRot = higResRgbRot;
hsiCube = reflectanceCube.DataCube;
pixelListRgb = RGB_selectedpixels;
pixelListHsi = HSI_selectedpixels;

    [h, w, d] = size(hsiCube);

    point = 1;
    
higResRgbRotA = higResRgbRot;
     higResRgbRotA = imrotate(higResRgbRotA, -90);
    
    for n = 1:length(pixelListRgb)
 
%         scaleVal = 1.2598;
        r = 10;
        th = 0:pi/50:2*pi;
        xunit = 645 - round((r * cos(th)) + pixelListRgb(n, 1));
        yunit = round((r * sin(th)) + pixelListRgb(n, 2));


%         
%         for i = 1:length(xunit)
%             higResRgbRotA(yunit(i), xunit(i), :) = [0, 0, 255];
% 
%         end

        higResRgbRotA = insertText(higResRgbRotA, [pixelListRgb(n, 2), pixelListRgb(n, 1)], point);
        point = point + 1;

    end
    

    
    hsiImage = GetTriBandRgbImage(hsiCube);
    
    hsiImageA = hsiImage;
        
    hsiImageA = imrotate(hsiImageA, -90);    
    pointHs = 1;
    
    for n = 1:length(pixelListHsi)
 
        r = 10;
        th = 0:pi/50:2*pi;
        
        xunit = 512 - round((r * cos(th)) + pixelListHsi(n, 1));
        yunit = round((r * sin(th)) + pixelListHsi(n, 2));


%         for i = 1:length(xunit)
%             hsiImageA(yunit(i), xunit(i),  :) = [255, 200, 0];
%         end

        hsiImageA = insertText(hsiImageA, [pixelListHsi(n, 2), pixelListHsi(n, 1)], pointHs);
        pointHs = pointHs + 1;
    end
    
    figure();
    subplot(2,1,1);
    imshow(hsiImageA);
    imwrite(hsiImageA,'hsi_image_pixel_pairs.png');
    
    subplot(2,1,2);

    imshow(higResRgbRotA);
    imwrite(higResRgbRotA,'rgb_image_pixel_pairs.png');

%% Actual RGB image scale for the performance matrix calculations.

rotImgCopy = imrotate(imgCopy, -90);

scaledImgOriginal = imresize(rotImgCopy, (512/645));

figure();
imshow(scaledImgOriginal);

%% Calculate RMSE values

[aa, bb, cc, dd] = RootMeanSquareError(imageGen, scaledImgOriginal)


%% Correlation coefficient for images 

imgSl1 = imageGen;                      % From manifold alignment
imgSl2 = scaledImgOriginal;             % Scaled down RGB 645 x 645


R_coff = corr2(imgSl1(:,:, 1), imgSl2(:,:, 1));

G_coff = corr2(imgSl1(:,:, 2), imgSl2(:,:, 2));

B_coff = corr2(imgSl1(:,:, 3), imgSl2(:,:, 3));

[R_coff, G_coff, B_coff]


%% Graph for bands number selection using manifold alignment

coffs = [0.6603, 0.7326, 0.671,	0.6673,	0.6404,	0.677,	0.509,	-0.0662; 
         0.7756, 0.7848, 0.7343, 0.7288, 0.7003, 0.7116, 0.4667, -0.0613;
         0.8339, 0.8419, 0.8228, 0.8252, 0.8031, 0.7967, 0.4341, -0.0481]
     
noOfBandsHsi = [4, 9, 16, 25, 36, 49, 64, 81];
     

figure()
hold on;

xx = 1:1:81;
coffs_r = spline(noOfBandsHsi, coffs(1,:), xx);
coffs_g = spline(noOfBandsHsi, coffs(2,:), xx);
coffs_b = spline(noOfBandsHsi, coffs(3,:), xx);

plot(noOfBandsHsi, coffs(1,:), 'o', xx, coffs_r, 'Color',[1, 0, 0], 'LineWidth',2);
plot(noOfBandsHsi, coffs(2,:), 'o', xx, coffs_g, 'Color',[0, 1, 0], 'LineWidth',2);
plot(noOfBandsHsi, coffs(3,:), 'o', xx, coffs_b, 'Color',[0, 0, 1], 'LineWidth',2);

xlim([1 100]);
% ylim([-0.5 1]);

grid on;

title('Pearson corelation coefficient for number of HSI bands to form RGB image');
xlabel('Number of selected spectral bands');
ylabel('Correlation coefficient');

line([9, 9], [-0.2, 0.8419]);

legend('Red channel','','Green channel','', 'Blue channel', '')

hold off;