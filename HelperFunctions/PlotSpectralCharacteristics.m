function fig = PlotSpectralCharacteristics(classCube, className, bandsList)

    [sam_h, sam_w, sam_d] = size(classCube);

    totalSamples = sam_h * sam_w;
    
    class_avg = zeros(1, sam_d);
    class_temp_cube = zeros(totalSamples, sam_d);

    for i = 1: sam_h
        for j = 1:sam_w
            class_temp_cube((i-1) * sam_h + j, :) = classCube(i,j,:);
        end
    end

    % Create a temprary datacube using selected bands
    class_temp_cube_FewBands = zeros(totalSamples, length(bandsList));
    class_avg_FewBands = zeros(1, length(bandsList));
    
    for i = 1: sam_h
        for j = 1:sam_w
            for bandId = 1:length(bandsList)
                class_temp_cube_FewBands((i-1) * sam_h + j, bandId) = classCube(i,j,bandsList(bandId));
            end
        end
    end
    
    class_avg_FewBands(1, :) = mean(class_temp_cube_FewBands, 1);


    % Select 25 random samples
    randomSamples = 25;
    randPixels = randperm(totalSamples);
    
    rndTempCube = zeros(randomSamples,sam_d);
    
    for nPx = 1: randomSamples
        rndTempCube(nPx,:) = class_temp_cube(randPixels(nPx),:) ;    
    end
    

    figure()
    hold on

    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [4 2]);

    % Plot 25 sample characteristic curves on the same plot.
    for n = 1: randomSamples
        plot(rndTempCube(n,:),'Color',[0.8,0.8,0.8]);
    end

    % Plot the average curve with selected bands.
    
    plot( bandsList, class_avg_FewBands, 'LineWidth', 2, 'Color', [0, 0, 0]);
    

    strTitle = "Reflectance characteristics of ";
    strTitle = strcat(strTitle, className, " class");
    
    title(strTitle);    
    xlabel('Bands');
    xlim([0 204]);
    ylim([0 1]);
    ylabel('Reflectance');
    hold off

    fig = gcf;
end


