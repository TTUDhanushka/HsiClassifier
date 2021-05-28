function outputVectors = UnfoldHsiCube(dataCube)

    [data_h, data_w, data_d] = size(dataCube);

    % Unfold the datacube and get spectral data into rows
    outputVectors = zeros(data_d, data_h * data_w);

    for a = 1:data_h
        for b = 1:data_w
            outputVectors(:, ((a-1) * data_h) + b) = dataCube(a, b, :);
        end
    end
end