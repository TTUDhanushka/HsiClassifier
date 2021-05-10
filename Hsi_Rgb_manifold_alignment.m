%%  Taking portion of both HSI and RGB images to make manifold alignment. Manifold 
%   alignment method for HSI image visualization in RGB.

% take top left quarter of the image

% LPP - Locality Preserving Projections

%% Create input data vector of quarter of the image



HSI_selectedpixels = [25, 25;
                      46, 76;
                      118, 118;
                      220, 260;
                      307, 420;
                      405, 150;
                      175, 156;
                      80, 400;
                      120, 285;
                      126, 326;
                      240, 300;
                      346, 310;
                      442, 80;
                      378, 285;
                      450, 450;
                      476, 189;
                      388, 364;
                      224, 486];
                  

total_Pixels = length(HSI_selectedpixels);
no_Of_Pixel_Pairs = total_Pixels / 2;

hsiCube = reflectanceCube.DataCube;


vectorizedInputHsi = zeros(total_Pixels, bands);

for i = 1:total_Pixels
    
    vectorizedInputHsi(i, :) = hsiCube(HSI_selectedpixels(i, 1), HSI_selectedpixels(i, 2), :) * 255;
    
end

meanHsiVec = mean(vectorizedInputHsi);

sqSumHsi = 0;

for i = 1: bands
    sqSumHsi = sqSumHsi + (meanHsiVec(i) * meanHsiVec(i));
end

sigmaHsi = sqrt(sqSumHsi);


%% RGB image details

scaleVal = 645 / 512;

rgb_size = [645, 645];
clrChannels = 3;

rgb_selectedpixels = zeros(total_Pixels, 2);

for n = 1:length(HSI_selectedpixels)
     rgb_selectedpixels(n,:) = round(HSI_selectedpixels(n, :) * scaleVal);
end

higResRgb = imread(highResRgbPath);

% Because hyperspectral image is rotated.
higResRgbRot = imrotate(higResRgb, 90);
 
vectorizedInputRgb = zeros(total_Pixels, clrChannels);

for i = 1:total_Pixels
    
    vectorizedInputRgb(i, :) = double(higResRgbRot(rgb_selectedpixels(i, 1), rgb_selectedpixels(i, 2), :));
    
end

meanRgbVec = mean(vectorizedInputRgb);

sqSumRgb = 0;

for i = 1: clrChannels
    sqSumRgb = sqSumRgb + ((meanRgbVec(i) * meanRgbVec(i)));
end

sigmaRgb = sqrt(sqSumRgb);


%% Spectral angle calculation

% Distance matrixa as spectral angles.
dist_w_s = zeros(total_Pixels, total_Pixels);
w_s = zeros(total_Pixels, total_Pixels);
adj_w_s = zeros(total_Pixels, total_Pixels);

for pixelPosA = 1:total_Pixels
    for pixelPosB = 1:total_Pixels
        
        refSq = 0;
        inputSq = 0;
        input_ef_mul = 0;
        
        for n = 1:bands
            refSq =  refSq + (vectorizedInputHsi(pixelPosA, n) * vectorizedInputHsi(pixelPosA, n));
            
            inputSq =  inputSq + (vectorizedInputHsi(pixelPosB, n) * vectorizedInputHsi(pixelPosB, n));
            
            input_ef_mul = input_ef_mul + (vectorizedInputHsi(pixelPosA, n) * vectorizedInputHsi(pixelPosB, n));
        end
        
        sa =  real(acos(input_ef_mul / (sqrt(refSq) * sqrt(inputSq))));
        
        dist_w_s(pixelPosA, pixelPosB) = real(sa);
        
        if (pixelPosA == pixelPosB)
            w_s(pixelPosA, pixelPosB) = 0;
        else
            w_s(pixelPosA, pixelPosB) = real(exp(-sa / sigmaHsi));
        end
    end
end

% This should be n x n matrix. Need correction.
[val, id] = max(w_s,[], 1);

for pixelPosA = 1:total_Pixels
        
    adj_w_s(pixelPosA, id(pixelPosA)) = 1;
    adj_w_s( id(pixelPosA), pixelPosA) = 1;
    
end

G_w_s = graph(adj_w_s);

% Three color bands distace calculation.

dist_w_t = zeros(total_Pixels, total_Pixels);
w_t = zeros(total_Pixels, total_Pixels);
adj_w_t = zeros(total_Pixels, total_Pixels);

for pixelPosA = 1:total_Pixels
    for pixelPosB = 1:total_Pixels
%         sqrt
        eucDist = (((vectorizedInputRgb(pixelPosA, 1) - vectorizedInputRgb(pixelPosB, 1))^2) + ...
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

G_w_t = graph(adj_w_t);

%%
al_1 = 1;
al_2 = 900;

% w_s_t = zeros(total_Pixels, total_Pixels, 'double');
% 
% for i = 1:total_Pixels
%     for j = 1: total_Pixels
%         if i == j
%             w_s_t = 1;
%         else
%             w_s_t = 0;
%         end
%     end
% end

w_s_t = eye(total_Pixels);

W = [al_1 * adj_w_s, al_2 * w_s_t; al_2 * w_s_t', al_1 * adj_w_t];
% W = [al_1 * w_s, al_2 * w_s_t; al_2 * w_s_t', al_1 * w_t];


W_graph = graph(W);
% L = laplacian(W_graph);

%% 
dummyHsi = zeros(size(vectorizedInputHsi));
dummyRgb = zeros(size(vectorizedInputRgb));

%%
D = zeros(size(W));

for i = 1: length(W)
    D(i, i) = sum(W(i, :), 2);
end

L = D - W;

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

% for n = 1:3
%     selectedEigenVal(n) = q(n);  
% end

selectedEigenVal = [2 1 41];

selectedEigenVectors =  zeros(207, 3);

for n = 1:3
    selectedEigenVectors(:, n) = real(Eigens * Vec(: , selectedEigenVal(n)));
end

%%
F_s = selectedEigenVectors(1:204, :);
F_t = selectedEigenVectors(205:207, :);

inv_F_t = inv(F_t);

%%

linePx = zeros(bands, 1);
imageGen = zeros(cols, lines, 3, 'uint8');

for i = 1: cols
    for j = 1:lines
        linePx(:, 1) = hsiCube(i, j, :);
        Srgb = inv_F_t' * F_s' * linePx;
        colorValue = uint8(Srgb * 255);
        
        imageGen(i, j, 1) = colorValue(1);
        imageGen(i, j, 2) = colorValue(2);
        imageGen(i, j, 3) = colorValue(3);
    end
end

figure();
imshow(imageGen)

Evaluation = selectedEigenVectors' * left * selectedEigenVectors