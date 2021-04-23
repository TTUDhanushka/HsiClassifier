
% Get the datacubes for each class from the workspace. The training data
% cubes for each class including the labels should be on the workspace. The
% training_data.mat file contains all the training data. In this script it
% will convert the HSI data into 4-D array and class labels into
% categorical vector.

% All the datacubes should have same number of bands.

samples = 0;

if exist('undefined_cube','var')
    [undefined_h, undefined_w, d] = size(undefined_cube);
    samples = samples + (undefined_h * undefined_w);
end

if exist('grass_cube','var')
    [grass_h, grass_w, d] = size(grass_cube);
    samples = samples + (grass_h * grass_w);
end

if exist('tree_cube','var')
    [tree_h, tree_w, d] = size(tree_cube);
    samples = samples + (tree_h * tree_w);
end

if exist('asphalt_cube','var')
    [asphalt_h, asphalt_w, d] = size(asphalt_cube);
    samples = samples + (asphalt_h * asphalt_w);
end

if exist('water_cube','var')
    [water_h, water_w, d] = size(water_cube);
    samples = samples  + (water_h * water_w);
end

if exist('sky_cube','var')
    [sky_h, sky_w, d] = size(sky_cube);
    samples = samples + (sky_h * sky_w);
end

if exist('dirt_cube','var')
    [dirt_h, dirt_w, d] = size(dirt_cube);
    samples = samples + (dirt_h * dirt_w);
end

training_Data = zeros(d, samples);
training_Labels = zeros(1, samples);

sample_pos = 0;

% Get the data from undefined class.
if exist('undefined_cube','var')
    for i = 1:undefined_h
        for j = 1: undefined_w
            training_Data(:, sample_pos + ((i - 1) * undefined_w) + j) = undefined_cube(i, j, :);
            training_Labels(1, sample_pos + ((i - 1) * undefined_w) + j) = undefined_labels(i, j);
        end
    end
    
    sample_pos = sample_pos + (undefined_h * undefined_w);      
end

% Get the data from grass class.
if exist('grass_cube','var')
    for i = 1:grass_h
        for j = 1: grass_w
            training_Data(:, sample_pos + ((i - 1) * grass_w) + j) = grass_cube(i, j, :);
            training_Labels(1, sample_pos + ((i - 1) * grass_w) + j) = grass_labels(i, j);
        end
    end

    sample_pos = sample_pos + (grass_h * grass_w);
end

% Get the data from asphalt class.
if exist('asphalt_cube','var')
    for i = 1:asphalt_h
        for j = 1: asphalt_w
            training_Data(:, sample_pos + ((i - 1) * asphalt_w) + j) = asphalt_cube(i, j, :);
            training_Labels(1, sample_pos + ((i - 1) * asphalt_w) + j) = asphalt_labels(i, j);
        end
    end

    sample_pos = sample_pos + (asphalt_h * asphalt_w);
end

% Get the data from tree class.
if exist('tree_cube','var')
    for i = 1:tree_h
        for j = 1: tree_w
            training_Data(:, sample_pos + ((i - 1) * tree_w) + j) = tree_cube(i, j, :);
            training_Labels(1, sample_pos + ((i - 1) * tree_w) + j) = tree_labels(i, j);
        end
    end

    sample_pos = sample_pos + (tree_h * tree_w);
end

% Get the data from water class.
if exist('water_cube','var')
    for i = 1:water_h
        for j = 1: water_w
            training_Data(:, sample_pos + ((i - 1) * water_w) + j) = water_cube(i, j, :);
            training_Labels(1, sample_pos + ((i - 1) * water_w) + j) = water_labels(i, j);
        end
    end

    sample_pos = sample_pos + (water_h * water_w);
end

% Get the data from sky class.
if exist('sky_cube','var')
    for i = 1:sky_h
        for j = 1: sky_w
            training_Data(:, sample_pos + ((i - 1) * sky_w) + j) = sky_cube(i, j, :);
            training_Labels(1, sample_pos + ((i - 1) * sky_w) + j) = sky_labels(i, j);
        end
    end

    sample_pos = sample_pos + (sky_h * sky_w);
end

% Get the data from dirt class.
if exist('dirt_cube','var')
    for i = 1:dirt_h
        for j = 1: dirt_w
            training_Data(:, sample_pos + ((i - 1) * dirt_w) + j) = dirt_cube(i, j, :);
            training_Labels(1, sample_pos + ((i - 1) * dirt_w) + j) = dirt_labels(i, j);
        end
    end

    sample_pos = sample_pos + (dirt_h * dirt_w);
end


%% This sample_pos should be as same as sample number.

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
