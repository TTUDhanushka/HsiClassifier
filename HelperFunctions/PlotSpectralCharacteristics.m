function fig = PlotSpectralCharacteristics(classCube, className, bSet)

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
    if exist('bSet')

        % Cube with selected bands
        class_temp_cube_FewBands = zeros(totalSamples, length(bSet));
        class_avg_FewBands = zeros(1, length(bSet));

        for i = 1: sam_h
            for j = 1:sam_w
                for bandId = 1:length(bSet)
                    class_temp_cube_FewBands((i-1) * sam_h + j, bandId) = classCube(i,j,bSet(bandId));
                end
            end
        end

        class_avg_FewBands(1, :) = mean(class_temp_cube_FewBands, 1);
    end

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
    if exist('bSet')
        plot( bSet, class_avg_FewBands, 'LineWidth', 2, 'Color', [0, 0, 1]);
    end

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


