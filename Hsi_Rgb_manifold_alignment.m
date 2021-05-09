%%  Taking portion of both HSI and RGB images to make manifold alignment. Manifold 
%   alignment method for HSI image visualization in RGB.

% take top left quarter of the image

% LPP - Locality Preserving Projections

%% Create input data vector of quarter of the image



HSI_selectedpixels = [10, 10;
                      16, 16;
                      18, 18;
                      22, 20;
                      37, 40;
                      45, 50;
                      75, 15;
                      80, 20;
                      120, 25;
                      126, 30;
                      140, 100;
                      146, 110];
                  

total_Pixels = length(HSI_selectedpixels);
no_Of_Pixel_Pairs = total_Pixels / 2;

hsiCube = reflectanceCube.DataCube;


vectorizedInputHsi = zeros(total_Pixels, d);

for i = 1:total_Pixels
    
    vectorizedInputHsi(i, :) = hsiCube(HSI_selectedpixels(i, 1), HSI_selectedpixels(i, 2), :);
    
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
     rgb_selectedpixels(n,:) = uint8(HSI_selectedpixels(n, :) * scaleVal);
end

higResRgb = imread(highResRgbPath);

% Because hyperspectral image is rotated.
higResRgbRot = imrotate(higResRgb, 90);
 
vectorizedInputRgb = zeros(total_Pixels, clrChannels);

for i = 1:total_Pixels
    
    vectorizedInputRgb(i, :) = higResRgbRot(HSI_selectedpixels(i, 1), HSI_selectedpixels(i, 2), :);
    
end

meanRgbVec = mean(vectorizedInputRgb);

sqSumRgb = 0;

for i = 1: clrChannels
    sqSumRgb = sqSumRgb + (meanRgbVec(i) * meanRgbVec(i));
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
        
        sa =  acos(input_ef_mul / (sqrt(refSq) * sqrt(inputSq)));
        
        dist_w_s(pixelPosA, pixelPosB) = real(sa);
        
        if (pixelPosA == pixelPosB)
            w_s(pixelPosA, pixelPosB) = 0;
        else
            w_s(pixelPosA, pixelPosB) = exp(-sa / sigmaHsi);
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
        
        eucDist = sqrt(((vectorizedInputRgb(pixelPosA, 1) - vectorizedInputRgb(pixelPosB, 1))^2) + ...
            ((vectorizedInputRgb(pixelPosA, 2) - vectorizedInputRgb(pixelPosB, 2))^2) + ...
            ((vectorizedInputRgb(pixelPosA, 3) - vectorizedInputRgb(pixelPosB, 3))^2));
        dist_w_t(pixelPosA, pixelPosB) = eucDist;
        
        if (pixelPosA == pixelPosB)
            w_t(pixelPosA, pixelPosB) = 0;
        else
            w_t(pixelPosA, pixelPosB) = exp(-eucDist / sigmaRgb);
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
al_2 = 100;


w_s_t = zeros(total_Pixels, total_Pixels, 'double');

for i = 1:total_Pixels
    for j = 1: total_Pixels
        if i == j
            w_s_t = 1;
        else
            w_s_t = 0;
        end
    end
end

w_s_t = eye(total_Pixels);

W = [al_1 * adj_w_s, al_2 * w_s_t; al_2 * w_s_t', al_1 * adj_w_t];

W_graph = graph(W);
L = laplacian(W_graph);

%% 
dummyHsi = zeros(size(vectorizedInputHsi));
dummyRgb = zeros(size(vectorizedInputRgb));

Eigens = eig(left);

