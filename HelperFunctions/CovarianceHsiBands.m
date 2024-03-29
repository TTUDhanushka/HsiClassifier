function [cc] = CovarianceHsiBands(bandA, bandB, HSI_Cube)

myCube = double(HSI_Cube);

[cols, lines, ~] = size(HSI_Cube);

totalpixels = cols * lines;

corSlice = zeros(cols, lines, 1);

sumA = 0;
sumB = 0;
sum_line_A = zeros(1, lines);

for i = 1:cols
    sum_line_A(1,i) = sum(myCube(i, :, bandA)) / 512;
    for j = 1:lines
        sumA = sumA + myCube(i, j, bandA);
    end
end

for i = 1:cols
    for j = 1:lines
        sumB = sumB + myCube(i, j, bandB);
    end
end


Ua = (sumA / totalpixels);
Ub = (sumB / totalpixels);


varA = 0;

for i = 1:cols
    for j = 1:lines
        varA = varA + double((myCube(i, j, bandA) - Ua) * (myCube(i, j, bandA) - Ua));
    end
end

covA = double(sqrt(varA));

varB = 0;

for i = 1:cols
    for j = 1:lines
        varB = varB + double((myCube(i, j, bandB) - Ub)^2);
    end
end

covB = double(sqrt(varB));

varAB = 0;
for i = 1:cols
    for j = 1:lines
        varAB = varAB + double(((myCube(i, j, bandA)) - Ua) * ((myCube(i, j, bandB)) - Ub)) ;
    end
end

% covAB = double(sqrt(varA*varB));

cc = double(varAB / (covA * covB));