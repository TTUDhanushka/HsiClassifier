% Multi-graph manifold alignment for RGB image visualization.

% Neighbourhood preserving projections
% Sparcity preserving projections
% Locality  preserving projections

%%
bandsList = [10, 18, 26, 35, 51, 56,70, 75, 87, 99];
% bandsList = [120, 126, 135, 151, 156, 170, 175, 187, 199];

reduceImage = ReducedBandImage(reflectanceCube.DataCube, bandsList);

%% Neighbourhood Preserving Embedding

% Use the direct graph method.

if ~exist('total_Pixels')
    [RGB_selectedpixels, HSI_selectedpixels] = ManifoldAlignmentPixelPairs();
       
    OverlayPoints(higResRgbRot, reflectanceCube.DataCube, RGB_selectedpixels, HSI_selectedpixels);
    
    total_Pixels = length(HSI_selectedpixels);
end

%% Create graph using kNN
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

% Distance matrixa as spectral angles.
dist_w_s = zeros(total_Pixels, total_Pixels);
w_s = zeros(total_Pixels, total_Pixels);
adj_w_s = zeros(total_Pixels, total_Pixels);

for pixelPosA = 1:total_Pixels
    for pixelPosB = 1:total_Pixels
        
        refSq = 0;
        inputSq = 0;
        input_ef_mul = 0;
        
        for n = 1:hs_D
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
    adj_w_s(id(pixelPosA), pixelPosA) = 1;
    
end


%% Optimization

npw_W = ones(total_Pixels, total_Pixels);