% Manifold alignment method for HSI image visualization in RGB.

% LPP - Locality Preserving Projections

%% Create input data vector
hsiCube = reflectanceCube.DataCube;
[h, w, d] = size(hsiCube);

vectorizedInput = zeros(h * w, d);

for i = 1:h
    for j = 1: w
        vectorizedInput((i * w) + j, :) = hsiCube(i, j, :);
    end
end


%% K- nearest neighbour

X = zeros(bands, samples);

weights = zeros(bands);

% for i = 1:bands
%     for j = 1: bands
%         weights(i,j) = 
%     end
% end

pointA = [10, 10];
pointB = [12, 12];

dist = sqrt((pointA(1, 1) - pointB(1, 1))^2 + (pointA(1, 2) - pointB(1, 2))^2);






