%% Create and Train Feed Forward Neural Network for image classification.

% Uses feed forward neural network.
% Segment hsi data cube based on selected classes.

clc;

%%

no_of_classes = 5;
samples_per_class = 4;

% Read header files
class1 = readmatrix('class1.txt');
class2 = readmatrix('class2.txt');
class3 = readmatrix('class3.txt');
class4 = readmatrix('class4.txt');

class5 = readmatrix('class5.txt');
class6 = readmatrix('class6.txt');
class7 = readmatrix('class7.txt');
class8 = readmatrix('class8.txt');

class9 = readmatrix('class9.txt');
class10 = readmatrix('class10.txt');
class11 = readmatrix('class11.txt');
class12 = readmatrix('class12.txt');

class13 = readmatrix('class13.txt');
class14 = readmatrix('class14.txt');
class15 = readmatrix('class15.txt');
class16 = readmatrix('class16.txt');

class17 = readmatrix('class17.txt');
class18 = readmatrix('class18.txt');
class19 = readmatrix('class19.txt');
class20 = readmatrix('class20.txt');

% class21 = readmatrix('class21.txt');
% class22 = readmatrix('class22.txt');
% class23 = readmatrix('class23.txt');
% class24 = readmatrix('class24.txt');

% Read hyperspectral data classes created using "ReadSpecimData.m" file.

%   class names = [green apple, brown apple, background]

hsi_bands = class1(1, 3);

class_1_cols = class1(1, 1);
class_1_row = class1(1, 2);
class_1_class = multibandread('class1.bil', [class_1_cols class_1_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_2_cols = class2(1, 1);
class_2_row = class2(1, 2);
class_2_class = multibandread('class2.bil', [class_2_cols class_2_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_3_cols = class3(1, 1);
class_3_row = class3(1, 2);
class_3_class = multibandread('class3.bil', [class_3_cols class_3_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_4_cols = class4(1, 1);
class_4_row = class4(1, 2);
class_4_class = multibandread('class4.bil', [class_4_cols class_4_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_5_cols = class5(1, 1);
class_5_row = class5(1, 2);
class_5_class = multibandread('class5.bil', [class_5_cols class_5_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_6_cols = class6(1, 1);
class_6_row = class6(1, 2);
class_6_class = multibandread('class6.bil', [class_6_cols class_6_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_7_cols = class7(1, 1);
class_7_row = class7(1, 2);
class_7_class = multibandread('class7.bil', [class_7_cols class_7_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_8_cols = class8(1, 1);
class_8_row = class8(1, 2);
class_8_class = multibandread('class8.bil', [class_8_cols class_8_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_9_cols = class9(1, 1);
class_9_row = class9(1, 2);
class_9_class = multibandread('class9.bil', [class_9_cols class_9_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_10_cols = class10(1, 1);
class_10_row = class10(1, 2);
class_10_class = multibandread('class10.bil', [class_10_cols class_10_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_11_cols = class11(1, 1);
class_11_row = class11(1, 2);
class_11_class = multibandread('class11.bil', [class_11_cols class_11_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_12_cols = class12(1, 1);
class_12_row = class12(1, 2);
class_12_class = multibandread('class12.bil', [class_12_cols class_12_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_13_cols = class13(1, 1);
class_13_row = class13(1, 2);
class_13_class = multibandread('class13.bil', [class_13_cols class_13_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_14_cols = class14(1, 1);
class_14_row = class14(1, 2);
class_14_class = multibandread('class14.bil', [class_14_cols class_14_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_15_cols = class15(1, 1);
class_15_row = class15(1, 2);
class_15_class = multibandread('class15.bil', [class_15_cols class_15_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_16_cols = class16(1, 1);
class_16_row = class16(1, 2);
class_16_class = multibandread('class16.bil', [class_16_cols class_16_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_17_cols = class17(1, 1);
class_17_row = class17(1, 2);
class_17_class = multibandread('class17.bil', [class_17_cols class_17_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_18_cols = class18(1, 1);
class_18_row = class18(1, 2);
class_18_class = multibandread('class18.bil', [class_18_cols class_18_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_19_cols = class19(1, 1);
class_19_row = class19(1, 2);
class_19_class = multibandread('class19.bil', [class_19_cols class_19_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_20_cols = class20(1, 1);
class_20_row = class20(1, 2);
class_20_class = multibandread('class20.bil', [class_20_cols class_20_row hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

% class_21_cols = class21(1, 1);
% class_21_row = class21(1, 2);
% class_21_class = multibandread('class21.bil', [class_21_cols class_21_row hsi_bands],...
%     'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});
% 
% class_22_cols = class22(1, 1);
% class_22_row = class22(1, 2);
% class_22_class = multibandread('class22.bil', [class_22_cols class_22_row hsi_bands],...
%     'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});
% 
% class_23_cols = class23(1, 1);
% class_23_row = class23(1, 2);
% class_23_class = multibandread('class23.bil', [class_23_cols class_23_row hsi_bands],...
%     'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});
% 
% class_24_cols = class24(1, 1);
% class_24_row = class24(1, 2);
% class_24_class = multibandread('class24.bil', [class_24_cols class_24_row hsi_bands],...
%     'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});

class_1_comb = Combine_Data_Cubes(class_1_class, class_2_class, class_3_class, class_4_class);
class_2_comb = Combine_Data_Cubes(class_5_class, class_6_class, class_7_class, class_8_class);
class_3_comb = Combine_Data_Cubes(class_9_class, class_10_class, class_11_class, class_12_class);
class_4_comb = Combine_Data_Cubes(class_13_class, class_14_class, class_15_class, class_16_class);
class_5_comb = Combine_Data_Cubes(class_17_class, class_18_class, class_19_class, class_20_class);
% class_6_comb = Combine_Data_Cubes(class_21_class, class_22_class, class_23_class, class_24_class);

[P, T] = Prepare_Inputs(class_1_comb, class_2_comb , class_3_comb, class_4_comb, class_5_comb ); %class_6_comb


%% Plot training data
X_axis = linspace(0, hsi_bands, hsi_bands);
Y_axis = P;

for i = 1:1000 %(green_cols * green_row)
    hold on
    plot(X_axis, Y_axis(:, i));
end

hold off

%% Neural Network Creation

net = feedforwardnet([25 50 25 5], 'trainlm');
 
% net = patternnet(20,'trainlm','mse');

% net.performFcn = 'crossentropy';
net.performFcn = 'mse'; 

net.trainParam.epochs = 1000;

% net.output = softmaxLayer();
net.layers{4}.transferFcn  = 'softmax'; %, 'useGPU','yes'

[net, tr] = train(net, P, T);
 
 %% Classification
 
cols = 512;
lines = 512;
 
hsi_cube = multibandread('reduced_hsi_image_min.bil', [cols lines hsi_bands],...
    'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});


NN_result = zeros(cols, lines, no_of_classes, 'uint8');

test_in = zeros(hsi_bands,1);

count = 0;
f = waitbar(0);

for i = 1:cols
    for j = 1:lines
        for x = 1:hsi_bands
            test_in(x,1) = hsi_cube(i, j, x);
        end
        
        NN_result(i,j,:) = uint8(255 * (sim(net, test_in)));
    end
    
    count = count + 1;
    percentage = (count / 512) * 100;
    
    % Update waitbar and message
    waitbar(count/512,f,sprintf('Classification progress: %4.1f %%', percentage))
end

%% Display classified output

classified_image = zeros(cols, lines, 3, 'uint8');

for i = 1: cols
    for j = 1:lines
        [res_val, res_ind] = max(NN_result(i,j,:));
        classified_image(i,j,:) = Get_Masking_Color(no_of_classes, res_ind);
    end
end

figure();
imshow(classified_image);

% Wrtie the result image to disk
imwrite(classified_image, 'result.png');
% %%
% figure();
% slice = brown_apple_class(:,:,6);
% imshow(uint8(slice / 16));

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
