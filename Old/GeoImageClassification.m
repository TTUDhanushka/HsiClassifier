%% Create and Train Feed Forward Neural Network for geo image classification.

% Uses feed forward neural network.
% Segment hsi data cube based on selected classes.

clc;

%%

% Read hyperspectral data classes created using "ReadSpecimData.m" file.

%   class names = [water, salt marsh, scrub]

hsi_bands = 17;

% green_cols = 64;
% green_row = 41;
% green_apple_class = multibandread('green_apple.bil', [green_cols green_row hsi_bands],...
%     'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});
% 
% brown_cols = 52;
% brown_row = 48;
% brown_apple_class = multibandread('brown_apple.bil', [brown_cols brown_row hsi_bands],...
%     'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});
% 
% bg_cols = 47;
% bg_row = 29;
% backgound_class = multibandread('background.bil', [bg_cols bg_row hsi_bands],...
%     'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});


[P, T] = PrepareInputs(water, salt_marsh, scrub);

%% Plot training data
X_axis = linspace(0, hsi_bands, hsi_bands);
Y_axis = P;

for i = 1:1000 %(green_cols * green_row)
    hold on
    plot(X_axis, Y_axis(:, i));
end

hold off

%% Neural Network Creation

net = feedforwardnet([20 50 25 4], 'trainlm');
 
% net = patternnet(20,'trainlm','mse');
 
net.performFcn = 'mse';   
net.trainParam.epochs = 1000;

[net, tr] = train(net, P, T);
 
 %% Classification
 
 cols = 512;
 lines = 614;
 
 hsi_cube = multibandread('reduced_hsi_image.bil', [cols lines hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

 classified_image = zeros(cols, lines,3);
%classified_image = zeros(brown_cols, brown_row, 3);

test_in = zeros(hsi_bands,1);

count = 0;

for i = 1:cols
    for j = 1:lines
        for x = 1:hsi_bands
            test_in(x,1) = hsi_cube(i, j, x);
        end
        
        output = uint8(200 * (sim(net, test_in)));
        
        for k = 1:3
            classified_image(i,j, k) = output(k);
        end

    end
    
    count = count + 1
end

figure();
imshow(classified_image);

%%
figure();
slice = brown_apple_class(:,:,6);
imshow(uint8(slice / 16));

%% Network configuration

view(net);

%%
% figure();
% 
% % plot original data
% 
% X_axis = linspace(0,20,20);
% Y_axis = linspace(0,20,20);
% 
% for i = 235:289
%     for j = 28:101
%         for k = 1:20
%             Y_axis(1,k) = hsi_cube(i,j,k);
%         end
%         hold on
%         plot(X_axis, Y_axis);
%     end
% 
% end
% 
% hold off
