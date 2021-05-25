% GetReducedBandTrainingData

% Should use augmented training data 
function reducedBandData = GetReducedBandData1D(trainingData, bandsList)

    [~, Samples] = size(trainingData);
    nBands = length(bandsList);
    
    reducedBandData = zeros(nBands, Samples);
    
    for i = 1: nBands
        reducedBandData(i, :) = trainingData(bandsList(i), :);
    end
end