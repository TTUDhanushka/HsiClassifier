%%  Taking portion of both HSI and RGB images to make manifold alignment. Manifold 
%   alignment method for HSI image visualization in RGB.

% Mahalanobis distance as the du=istance matrice for HSI graph
% construction.

%%
bandsList = [10, 18, 26, 35, 51, 56,70, 75, 87, 99];
% bandsList = [120, 126, 135, 151, 156, 170, 175, 187, 199];

reduceImage = ReducedBandImage(reflectanceCube.DataCube, bandsList);


%% Create input data vector of quarter of the image



[RGB_selectedpixels, HSI_selectedpixels] = ManifoldAlignmentPixelPairs();
       

OverlayPoints(higResRgbRot, reflectanceCube.DataCube, RGB_selectedpixels, HSI_selectedpixels);

total_Pixels = length(HSI_selectedpixels);


%%

% hsiCube = reflectanceCube.DataCube;
hsiCube = reduceImage;
[hs_H, hs_W, hs_D] = size(hsiCube);


vectorizedInputHsi = zeros(total_Pixels, hs_D);

for i = 1:total_Pixels   
    vectorizedInputHsi(i, :) = hsiCube(HSI_selectedpixels(i, 1), HSI_selectedpixels(i, 2), :);    
end

meanHsiVec = mean(vectorizedInputHsi);

sqSumHsi = 0;


for i = 1: total_Pixels
    sqSumHsi = sqSumHsi + (vectorizedInputHsi(i, :) - meanHsiVec).^2;
end

kHsi = mean2(sqSumHsi / total_Pixels);
sigmaHsi = sqrt(kHsi);

clear meanHsiVec kHsi sqSumHsi;

%% RGB image details
rgb_size = size(higResRgbRot);

clrChannels = rgb_size(3);

higResRgb = imread(highResRgbPath);

% Because hyperspectral image is rotated.
higResRgbRot = imrotate(higResRgb, 90);
 
vectorizedInputRgb = zeros(total_Pixels, clrChannels);

for i = 1:total_Pixels
    
    vectorizedInputRgb(i, :) = double(higResRgbRot(RGB_selectedpixels(i, 1), RGB_selectedpixels(i, 2), :));
    
end

meanRgbVec = mean(vectorizedInputRgb);

sqSumRgb = 0;


for i = 1: total_Pixels
    sqSumRgb = sqSumRgb + ((vectorizedInputRgb(i, :) - meanRgbVec).^2);
end

kRgb = mean2(sqSumRgb / total_Pixels);
sigmaRgb = sqrt(kRgb);



%% Spectral angle calculation

% % Distance matrixa as spectral angles.
% dist_w_s = zeros(total_Pixels, total_Pixels);
% w_s = zeros(total_Pixels, total_Pixels);
 
adj_w_s = zeros(total_Pixels, total_Pixels);


covar = cov(vectorizedInputHsi);

cov_identity = eye(hs_D);
corr_Dist = zeros(total_Pixels, total_Pixels);

for pixelPosA = 1:total_Pixels
    for pixelPosB = 1:total_Pixels
        correlationR =  corrcoef(vectorizedInputHsi(pixelPosA, :), vectorizedInputHsi(pixelPosB, :));
        corr_Dist(pixelPosA, pixelPosB) = correlationR(1, 2);
    end
end

% This should be n x n matrix. Need correction.
[val, id] = max(corr_Dist,[], 1);
% [val, id] = max(w_s,[], 1);

for pixelPosA = 1:total_Pixels
        
    adj_w_s(pixelPosA, id(pixelPosA)) = 1;
    adj_w_s(id(pixelPosA), pixelPosA) = 1;
    
end


% Three color bands distace calculation.

dist_w_t = zeros(total_Pixels, total_Pixels);
w_t = zeros(total_Pixels, total_Pixels);
adj_w_t = zeros(total_Pixels, total_Pixels);

for pixelPosA = 1:total_Pixels
    for pixelPosB = 1:total_Pixels
        
        eucDist = sqrt(((vectorizedInputRgb(pixelPosA, 1) - vectorizedInputRgb(pixelPosB, 1))^2) + ...
            ((vectorizedInputRgb(pixelPosA, 2) - vectorizedInputRgb(pixelPosB, 2))^2) + ...
            ((vectorizedInputRgb(pixelPosA, 3) - vectorizedInputRgb(pixelPosB, 3))^2));
        dist_w_t(pixelPosA, pixelPosB) = eucDist;
        
        if (pixelPosA == pixelPosB)
            w_t(pixelPosA, pixelPosB) = 0;
        else
            w_t(pixelPosA, pixelPosB) = real(exp(-eucDist / sigmaRgb));
        end
    end
end

% This should be n x n matrix. Need correction.
[val, id] = max(w_t,[], 1);

for pixelPosA = 1:total_Pixels
        
    adj_w_t(pixelPosA, id(pixelPosA)) = 1;
    adj_w_t( id(pixelPosA), pixelPosA) = 1;
    
end


%%
al_1 = 2;
al_2 = 200;
al_3 = 5;

w_s_t = eye(total_Pixels);

W = [al_1 * adj_w_s, al_2 * w_s_t; al_2 * w_s_t', al_3 * adj_w_t];



%% Prepare L, D, X matrices.

D = zeros(size(W));

for i = 1: length(W)
    D(i, i) = sum(W(i, :), 2);
end

L = D - W;

dummyHsi = zeros(size(vectorizedInputHsi));
dummyRgb = zeros(size(vectorizedInputRgb));


X = [vectorizedInputHsi', dummyHsi';
    dummyRgb', vectorizedInputRgb'];


left = X * L * X';
right = X * D * X';

[Eigens, Vec] = eig(left, right);


%% Eigen values list

eigenValues = zeros(1, length(Vec));

for i = 1:length(Vec)
    eigenValues(i) = real(Vec(i, i));
end

[p, q] = sort(eigenValues, 'ascend');

selectedEigenVal = zeros(1, 3);

for n = 1:3
    selectedEigenVal(n) = q(n);  
end


%% Optimization 

Evaluation = 0;
% iteration = 1;
% 
% Optimum = zeros(4, hs_D^3);
% 
% for n1 = 1: hs_D
%     for n2 = 1:hs_D
%         for n3 = 1:hs_D
%             selectedEigenVal = [q(n1), q(n2), q(n3)]


            %  selectedEigenVal = [5 197 6];

            selectedEigenVectors =  zeros(hs_D + clrChannels, 3);

            for n = 1:3
                selectedEigenVectors(:, n) = Eigens * Vec(: , selectedEigenVal(n));
            end

            % Projection functions.
            F_s = selectedEigenVectors(1:hs_D, :);
            F_t = selectedEigenVectors(hs_D + 1:hs_D + clrChannels, :);

            inv_F_t = inv(F_t);

            % Image generation
            linePx = zeros(hs_D, 1);
            imageGen = zeros(cols, lines, 3, 'uint8');

            for i = 1: cols
                for j = 1:lines
                    linePx(:, 1) = hsiCube(i, j, :);
                    Srgb = inv_F_t' * F_s' * linePx;
                    
                    colorValue = uint8(Srgb);
                    imageGen(i, j, :) = colorValue;
                end
            end

            figure();
            imageGen = imrotate(imageGen, -90);
            imshow(imageGen)

            Evaluation = trace(selectedEigenVectors' * left * selectedEigenVectors);
%             Optimum(:, iteration) = [q(n1), q(n2), q(n3), Evaluation];
%             iteration = iteration + 1;
%         end
%     end
% end