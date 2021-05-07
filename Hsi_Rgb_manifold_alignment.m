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

%%

% take top left quarter of the image

n_s = 128 * 128;          % spectral image
p_s = 204;

n_t = 156 * 156;        % RGB image
p_t = 3;

% Weights matrix.
w_s = zeros(n_s, n_s, 'uint8');
w_t = zeros(n_t , n_t);

for i = 1:length(w_s)
    for j = 1:length(w_s)
        w_s = 1;
    end
end










