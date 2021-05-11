% Minimum band image construction

function reducedCube = ReducedBandImage(hsiCube, bandsList)

    [h, w, d] = size(hsiCube);

    nBands = length(bandsList);

    reducedCube = zeros(h, w, nBands);

    for k = 1:nBands
        reducedCube(:, :, k) = hsiCube(:, :, bandsList(k));
    end

end