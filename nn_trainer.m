%% Train neural network from spectral data library.
% Call NN list and train them all at once.

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

%% Call neural networks *.m file and load all the networks to workspace

perceptron_nets;


