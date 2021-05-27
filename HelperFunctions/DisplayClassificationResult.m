function imageResult = DisplayClassificationResult(resultsVector, colsRgb, linesRgb)

    imageResult = zeros(colsRgb, linesRgb, 3, 'uint8');

    for n = 1: length(resultsVector) - 1

        row = fix(n/linesRgb) + 1;
        column = mod(n,linesRgb) + 1;

        [val, id] = max(resultsVector(:, n));


        imageResult(row, column, :) = Get_Label_Color(id);

    end

end