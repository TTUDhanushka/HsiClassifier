%% Savitsky-Golay filering.


%% Filter parameters
    order = 2;
    frameLen = 5;
    
    sgFilteredCube = zeros(cols, lines, bands);
    spectra = zeros(1, bands);
    
    for i = 1: cols 
        for j = 1: lines
            for k = 1: bands
                spectra(1, k) = correctd_hsi_cube(i, j, k);
            end

            sgFilteredPixel(1, :) = sgolayfilt( spectra(1, :),order, frameLen);

            sgFilteredCube(i, j, :) = sgFilteredPixel(1, :);
        end
    end
    
    
    %% Parameters experiment
    
    for k = 1: bands
        spectra(1, k) = correctd_hsi_cube(10, 10, k);
    end
    
    figure()
    plot(spectra(1, :), 'Color', 'b')
    hold on
    sgFilteredPixel(1, :) = sgolayfilt( spectra(1, :), 2, 5);
    plot(sgFilteredPixel(1, :), 'Color', [0.5, 0, 0])
    
    sgFilteredPixel(1, :) = sgolayfilt( spectra(1, :), 2, 9);
    plot(sgFilteredPixel(1, :), 'Color', [0, 0.5, 0])
    
    sgFilteredPixel(1, :) = sgolayfilt( spectra(1, :), 2, 11);
    plot(sgFilteredPixel(1, :), 'Color', [0, 0, 0.5])
    hold off