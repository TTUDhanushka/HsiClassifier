%% Train neural network using spectral data library.

% Use BuildSpectralLibrary to collect training data to the library.
% This classier can contain several number of classes.

clc;
close All;

%% Get training data class names and data from the library

% Get the library folder.
currentFolder = pwd;
library_path = strcat(currentFolder,'\', 'SpectralLibrary');

files_list = dir(library_path);
items_in_dir = size(files_list);

no_of_classes = 0;
cnt_bil_files = 0;

fileNames = string(no_of_classes);
bilFileNames = string(no_of_classes);

for n = 1:items_in_dir(1)
    
    txt_file = contains(files_list(n).name, '.txt','IgnoreCase',true);
    
    if (txt_file)
        no_of_classes = no_of_classes + 1;
        fileNames(no_of_classes) = files_list(n).name;
    end
    
    bil_file = contains(files_list(n).name, '.bil','IgnoreCase',true);
    
    if (bil_file)
        cnt_bil_files = cnt_bil_files + 1;
        bilFileNames(cnt_bil_files) = files_list(n).name;
    end
end



P_temp = zeros(1,1);
T_temp = zeros(1,1);


for m = 1:no_of_classes
    
    targets = zeros(no_of_classes, 1);
    
    hdr_path = fullfile(library_path, fileNames(m));
    bil_path = fullfile(library_path, bilFileNames(m));
    
    classHdr = readmatrix(hdr_path);
    
    tempCube = multibandread(bil_path, [classHdr(1,1) classHdr(1,2) classHdr(1,3)],...
        'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 classHdr(1,3)]});
    
    classData = zeros(1,classHdr(1,3));
    trainData = zeros(1,no_of_classes);
    
    for i = 1:classHdr(1,1)
        classData(i,:) = tempCube(i,1,:);
    end
    
    targets(m) = 1;
    
    for i = 1:classHdr(1,1)
        trainData(i,:) = targets;
    end
    
    if ~(m == 1)
        P_temp = [P_temp; classData];
        T_temp = [T_temp; trainData];
    else
        P_temp = classData;
        T_temp = trainData;
    end
end

dataLen = size(P_temp);

P = zeros(dataLen(1,1), dataLen(1,2));
T = zeros(dataLen(1,1), no_of_classes);

rand_index = randperm(dataLen(1,1));

for m = 1:dataLen(1,1)
    for n = 1:dataLen(1,2)
        P(m,n) = P_temp(rand_index(m), n);
    end
end

for m = 1:dataLen(1,1) % No of classes
    for n = 1:no_of_classes
        T(m,n) = T_temp(rand_index(m), n);
    end
end

%% Neural Network Creation

%net = feedforwardnet([25 50 25 9], 'trainlm');
net = feedforwardnet([25 50 20 8], 'trainlm');

% net = patternnet(20,'trainlm','mse');

net.performFcn = 'crossentropy';
% net.performFcn = 'mse';

net.trainParam.epochs = 5000;

% net.output = softmaxLayer();
net.layers{4}.transferFcn  = 'softmax'; %3Layer net   4 

[net, tr] = train(net, P', T', 'useGPU','yes');

%% Classification

read_from_file = false;

if read_from_file
    
    % Image source is the camera type.
    image_source = 'specim';
    
    directory_path = uigetdir;
    
    directory_path = strcat(directory_path,'\');
    
    %% Get the data file paths from the data directory.
    
    % RGB preview file
    rgb_file = '';
    header_file = '';
    hsi_file = '';
    
    [rgb_file, header_file, hsi_file, white_ref_file,...
        white_ref_hdr, dark_ref_file, dark_ref_hdr] = GetDataFiles(directory_path);
    
    % Get the header data
    [cols, lines, bands, wave] = ReadHeader(header_file, image_source);
    
    % cols = 512;
    % lines = 512;
    % hsi_bands = 204;
    %
    % hsi_file = 'G:\3. Hyperspectral\2. Data taken for articles\2019-11-18_018\capture\2019-11-18_018.raw';
    %
    % hsi_cube = multibandread(hsi_file, [cols lines hsi_bands],...
    %     'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});
    
    hsi_cube = multibandread(hsi_file, [cols lines bands],...
        'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});
    
    white_ref_cube = multibandread(white_ref_file, [cols 1 bands],...
        'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});
    
    dark_ref_cube = multibandread(dark_ref_file, [cols 1 bands],...
        'uint16', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 bands]});
    
    
    [correctd_hsi_cube, error] = Calibrate_Spectral_Image(hsi_cube, white_ref_cube,...
        dark_ref_cube);
    
    NN_result = zeros(cols, lines, no_of_classes, 'uint8');
    
    test_in = zeros(hsi_bands,1);
    
    count = 0;
    f = waitbar(0);
    
    for i = 1:cols
        for j = 1:lines
            for x = 1:hsi_bands
                test_in(x,1) = correctd_hsi_cube(i, j, x);
            end
            
            NN_result(i,j,:) = uint8(255 * (sim(net, test_in)));
        end
        
        count = count + 1;
        percentage = (count / 512) * 100;
        
        % Update waitbar and message
        waitbar(count/512,f,sprintf('Classification progress: %4.1f %%', percentage))
    end
    
else
    cols = 512;
    lines = 512;
    hsi_bands = 25;
    
    hsi_file = 'reduced_hsi_image_min.bil';
    
    hsi_cube = multibandread(hsi_file, [cols lines hsi_bands],...
        'double', 0, 'bil', 'ieee-le', {'Band', 'Range', [1 1 hsi_bands]});
    
    
    % Convert cube to plane
    linear_image = Convert_to_1d_Spectral(hsi_cube);
    [l_h, l_d] = size(linear_image);
    
    
%     NN_result = zeros(cols, lines, no_of_classes, 'uint8');
    NN_result = zeros(l_h, no_of_classes, 'uint8');
        
    test_in = zeros(hsi_bands,1);
    
    count = 0;
    f = waitbar(0);
    
    parfor i = 1:l_h
        
        test_in = linear_image(i, :);
        
        NN_result(i, :) = uint8(255 * (sim(net, test_in')));
        
    end
end
    
%     for i = 1:cols
%         for j = 1:lines
%             for x = 1:hsi_bands
%                 test_in(x,1) = hsi_cube(i, j, x);
%             end
%             
%             NN_result(i,j,:) = uint8(255 * (sim(net, test_in)));
%         end
%         
%         count = count + 1;
%         percentage = (count / 512) * 100;
%         
%         % Update waitbar and message
%         waitbar(count/512,f,sprintf('Classification progress: %4.1f %%', percentage))
%     end
% end


%% Display classified output

classified_image = zeros(cols, lines, 3, 'uint8');


for i = 1: l_h

    [res_val, res_ind] = max(NN_result(i,:));
    
    c_h = floor((i - 1) / cols) + 1;
    c_w = (i-1) - ((c_h - 1) * cols) + 1;
    classified_image(c_h, c_w, :) = Get_Masking_Color(no_of_classes, res_ind);

end

% for i = 1: cols
%     for j = 1:lines
%         [res_val, res_ind] = max(NN_result(i,j,:));
%         classified_image(i,j,:) = Get_Masking_Color(no_of_classes, res_ind);
%     end
% end

figure();
classified_image = imrotate(classified_image,-90);
imshow(classified_image);

% Wrtie the result image to disk
imwrite(classified_image, 'result.png');

%% Network configuration

view(net);

