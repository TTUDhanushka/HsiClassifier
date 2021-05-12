%%  Taking portion of both HSI and RGB images to make manifold alignment. Manifold 
%   alignment method for HSI image visualization in RGB.

% LPP - Locality Preserving Projections

%% Create input data vector of quarter of the image


HSI_selectedpixels = [25, 25;           % 1
                      150, 30;
                      30, 480;
                      35, 270;
                      160, 270;         % 5
                      165, 185;
                      160, 370;
                      180, 480;
                      220, 240;
                      320, 240;         % 10
                      100, 115;
                      495, 300;
                      495, 495;
                      332, 380;
                      130, 430;         % 15
                      336, 145;
                      336, 115;
                      120, 30;
                      500, 12;
                      30, 400;          % 20
%                       45, 170;
%                       90, 95;
%                       55, 85;
                      75, 215];                 

RGB_selectedpixels = [35, 35;           % 1
                      180, 35;
                      35, 620;
                      35, 292;
                      180, 292;         % 5
                      180, 180;
                      180, 392;
                      210, 620;
                      230, 250;
                      390, 250;         % 10
                      140, 95;
                      630, 330;
                      630, 630;
                      400, 430;
                      170, 520;         % 15
                      410, 150;
                      410, 110;
                      150, 30;
                      635, 15;
                      35, 450;          % 20
%                       35, 145;
%                       120, 85;
%                       80, 80;
                      80, 210];         

OverlayPoints(higResRgbRot, reflectanceCube.DataCube, RGB_selectedpixels, HSI_selectedpixels);

total_Pixels = length(HSI_selectedpixels);
no_Of_Pixel_Pairs = total_Pixels / 2;

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

% for i = 1: bands
%     sqSumHsi = sqSumHsi + (meanHsiVec(i) * meanHsiVec(i));
% end

for i = 1: total_Pixels
    sqSumHsi = sqSumHsi + (vectorizedInputHsi(i, :) - meanHsiVec).^2;
end

kHsi = mean2(sqSumHsi / total_Pixels);
sigmaHsi = sqrt(kHsi);

%% RGB image details
rgb_size = size(higResRgbRot);

clrChannels = rgb_size(3);

% rgb_selectedpixels = zeros(total_Pixels, 2);
% 
% for n = 1:length(HSI_selectedpixels)
%      rgb_selectedpixels(n,:) = round(RGB_selectedpixels(n, :));
% end

higResRgb = imread(highResRgbPath);

% Because hyperspectral image is rotated.
higResRgbRot = imrotate(higResRgb, 90);
 
vectorizedInputRgb = zeros(total_Pixels, clrChannels);

for i = 1:total_Pixels
    
    vectorizedInputRgb(i, :) = double(higResRgbRot(RGB_selectedpixels(i, 1), RGB_selectedpixels(i, 2), :));
    
end

meanRgbVec = mean(vectorizedInputRgb);

sqSumRgb = 0;

% for i = 1: clrChannels
%     sqSumRgb = sqSumRgb + ((meanRgbVec(i) * meanRgbVec(i)));
% end


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
al_1 = 0.5;
al_2 = 200;


w_s_t = eye(total_Pixels);

W = [al_1 * adj_w_s, al_2 * w_s_t; al_2 * w_s_t', al_1 * adj_w_t];

W_graph = graph(W);


%% 
dummyHsi = zeros(size(vectorizedInputHsi));
dummyRgb = zeros(size(vectorizedInputRgb));


%% Prepare L, D, X matrices.

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
                selectedEigenVectors(:, n) = real(Eigens * Vec(: , selectedEigenVal(n)));
            end

            %
            F_s = selectedEigenVectors(1:hs_D, :);
            F_t = selectedEigenVectors(hs_D + 1:hs_D + clrChannels, :);

            inv_F_t = inv(F_t);

            %

            linePx = zeros(hs_D, 1);
            imageGen = zeros(cols, lines, 3, 'uint8');

            for i = 1: cols
                for j = 1:lines
                    linePx(:, 1) = hsiCube(i, j, :);
                    Srgb = inv_F_t' * F_s' * linePx;
                    colorValue = uint8(Srgb);

                    imageGen(i, j, 1) = colorValue(1);
                    imageGen(i, j, 2) = colorValue(2);
                    imageGen(i, j, 3) = colorValue(3);
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