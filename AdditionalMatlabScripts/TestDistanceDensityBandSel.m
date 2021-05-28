% Test script for distance density band selection method.

partitions = 4;  
bandsPerPartition = 50; 

selected_bands_DD = DistanceDensityBandSelection(indian_pines_corrected, 4, 50);

%% Only for Indian Pines

selectedPixels =   [[9, 2]; [70, 101]; [20, 7]; [1, 1]; [36, 9 ]; [83, 12];...
                    [68, 36]; [77, 111]; [46, 126]; [66, 24]; [13, 31];...
                    [12, 103]; [19, 69]; [121, 44]; [129, 120]; [9, 94]; [17, 51]];
                    

%% plot the radiance for the first pixel

% This graph used for Indian Pines dataset which shows same plot in the paper.

figure()
hold on;

for cnt_Px = 1: length(selectedPixels)
    radiance(1, :) = DdCube(selectedPixels(cnt_Px, 1), selectedPixels(cnt_Px, 2), :);
    plot(radiance(1, :));
end


for kk = 1: partitions - 1
    line([(kk * bandsPerPartition) (kk * bandsPerPartition)], [0 7000], 'Color', [0.5, 0.5, 0.5])
end
hold off;