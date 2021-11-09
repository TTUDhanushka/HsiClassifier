revisedColorMap = [ 0 0 0;
                    0 0 255;
                    127 0 255;
                    65 127 127;
                    127 65 0;
                    255 180 180;
                    201 201 65;
                    158 196 113;
                    127 127 127;
                    180 255 255];
                
       height = 280;
       width = 200;
                
legend = zeros(height, width, 3, 'uint8');
legendUpdated = zeros(height, width, 3, 'uint8');

listOfClassesIp_Original =["Background";
                            "Alfalfa";
                            "Corn-notill";
                            "Corn-mintill";
                            "Corn";
                            "Grass-pasture";
                            "Grass-trees";
                            "Grass-pasture-mowed";
                            "Hay-windrowed";
                            "Oats";
                            "Soybean-notill";
                            "Soybean-mintill";
                            "Soybean-clean";
                            "Wheat";
                            "Woods";
                            "Buildings-Grass-Trees-Drives";
                            "Stone-Steel-Towers"]; 

listOfClassesIp_Updated =["Background";
                            "Corn-notill";
                            "Corn-mintill";
                            "Grass-pasture";
                            "Grass-trees";
                            "Hay-windrowed";
                            "Soybean-notill";
                            "Soybean-mintill";
                            "Soybean-clean";
                            "Woods"];
                        
for i = 1:height
    for j = 1:width
        legend(i,j,:) = [255, 255, 255];
        legendUpdated(i,j,:) = [255, 255, 255];
    end
end

n = 0;

for nCmapColor = 1:length(colorMap)
    for lx = 1:8
        for ly = 1:12
            legend(lx + (nCmapColor - 1) * 6 + 5 + n, ly + 8, :) = colorMap(nCmapColor, :);

        end
    end
    pos = [32, 3+(nCmapColor - 1) * 6 + n, ];
    
    legend = insertText(legend, pos, listOfClassesIp_Original(nCmapColor), 'FontSize', 10, ...
        'BoxColor', [255 255 255]);
    
    n = n + 10;
end

n = 0;

for nCmapColor = 1:length(revisedColorMap)
    for lx = 1:8
        for ly = 1:12
            legendUpdated(lx + (nCmapColor - 1) * 6 + 5 + n, ly + 8, :) = revisedColorMap(nCmapColor, :);

        end
    end
    pos = [32, 3+(nCmapColor - 1) * 6 + n, ];
    
    legendUpdated = insertText(legendUpdated, pos, listOfClassesIp_Updated(nCmapColor), 'FontSize', 10, ...
        'BoxColor', [255 255 255]);
    
    n = n + 10;
end

%% RGB of Indian Pines Dataset

figure();
imshow(indianPinesRGB);

%%
figure()

subplot(1, 2, 1);
imshow(indian_pines_gt_vis);
mt(1) = title('a. Ground truth of all the classes');

subplot(1, 2, 2);
imshow(indian_pines_gt_few_cls_vis);
mt(2) = title('b. With selected classes');
set(mt,'Position',[80 150],'VerticalAlignment','top','Color',[0 0 0])

%%
figure()
subplot(1, 2, 1);
imshow(legend, 'Interpolation',"bilinear")
mt(1) = title('a. All the classes');

subplot(1, 2, 2);
imshow(legendUpdated, 'Interpolation',"bilinear")
mt(2) = title('b. Selected classes');
set(mt,'Position',[70 280],'VerticalAlignment','top','Color',[0 0 0])