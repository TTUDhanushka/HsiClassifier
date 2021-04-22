
% Get the datacubes for each class from the workspace. The training data
% cubes for each class including the labels should be on the workspace. The
% training_data.mat file contains all the training data. In this script it
% will convert the HSI data into 4-D array and class labels into
% categorical vector.

% All the datacubes should have same number of bands.

[undefined_h, undefined_w, d] = size(undefined_cube);
[grass_h, grass_w, ~] = size(grass_cube);
[tree_h, tree_w, ~] = size(tree_cube);
[water_h, water_w,~] = size(water_cube);
[sky_h, sky_w, ~] = size(sky_cube);

samples = (undefined_h * undefined_w) + (grass_h * grass_w)...
    + (tree_h * tree_w) + (water_h * water_w) + (sky_h * sky_w);

training_Data = zeros(d, samples);
training_Labels = zeros(1, samples);

sample_pos = 0;

% Get the data from undefined class.
for i = 1:undefined_h
    for j = 1: undefined_w
        training_Data(:, sample_pos + ((i - 1) * undefined_w) + j) = undefined_cube(i, j, :);
        training_Labels(1, sample_pos + ((i - 1) * undefined_w) + j) = undefined_labels(i, j);
    end
end

sample_pos = sample_pos + (undefined_h * undefined_w);

% Get the data from grass class.
for i = 1:grass_h
    for j = 1: grass_w
        training_Data(:, sample_pos + ((i - 1) * grass_w) + j) = grass_cube(i, j, :);
        training_Labels(1, sample_pos + ((i - 1) * grass_w) + j) = grass_labels(i, j);
    end
end

sample_pos = sample_pos + (grass_h * grass_w);

% Get the data from tree class.
for i = 1:tree_h
    for j = 1: tree_w
        training_Data(:, sample_pos + ((i - 1) * tree_w) + j) = tree_cube(i, j, :);
        training_Labels(1, sample_pos + ((i - 1) * tree_w) + j) = tree_labels(i, j);
    end
end

sample_pos = sample_pos + (tree_h * tree_w);

% Get the data from water class.
for i = 1:water_h
    for j = 1: water_w
        training_Data(:, sample_pos + ((i - 1) * water_w) + j) = water_cube(i, j, :);
        training_Labels(1, sample_pos + ((i - 1) * water_w) + j) = water_labels(i, j);
    end
end

sample_pos = sample_pos + (water_h * water_w);

% Get the data from water class.
for i = 1:sky_h
    for j = 1: sky_w
        training_Data(:, sample_pos + ((i - 1) * sky_w) + j) = sky_cube(i, j, :);
        training_Labels(1, sample_pos + ((i - 1) * sky_w) + j) = sky_labels(i, j);
    end
end

%% This sample_pos should be as same as sample number.
sample_pos = sample_pos + (sky_h * sky_w);

if ~(sample_pos == samples)
    errordlg("Error in the sample count");
end

%% Data augmentation

rand_idx = randperm(samples, samples);

training_Data_Aug = zeros(d, samples);
training_Labels_Aug = zeros(1, samples);

for n = 1: samples
    training_Data_Aug(:, n) = training_Data(:, rand_idx(n));
    training_Labels_Aug(:, n) = training_Labels(:, rand_idx(n));
end

%% Data for CNN training

trainingDataCnn = reshape(training_Data_Aug,[1, d, 1, samples]);

trainingLabelCnn = categorical(training_Labels_Aug);

