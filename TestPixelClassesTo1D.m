
% Get the datacubes for each class from the workspace. The training data
% cubes for each class including the labels should be on the workspace. The
% training_data.mat file contains all the training data. In this script it
% will convert the HSI data into 4-D array and class labels into
% categorical vector.


%%
% All the datacubes should have same number of bands.

samples = 0;

if exist('undefined_cube_test_Ref','var')
    [undefined_h, undefined_w, d] = size(undefined_cube_test_Ref);
    samples = samples + (undefined_h * undefined_w);
end

if exist('grass_cube_test_Ref','var')
    [grass_h, grass_w, d] = size(grass_cube_test_Ref);
    samples = samples + (grass_h * grass_w);
end

if exist('bush_cube_test_Ref','var')
    [bush_h, bush_w, d] = size(bush_cube_test_Ref);
    samples = samples + (bush_h * bush_w);
end

if exist('mud_cube_test_Ref','var')
    [mud_h, mud_w, d] = size(mud_cube_test_Ref);
    samples = samples + (mud_h * mud_w);
end

if exist('concrete_cube_test_Ref','var')
    [concrete_h, concrete_w, d] = size(concrete_cube_test_Ref);
    samples = samples + (concrete_h * concrete_w);
end

if exist('asphalt_cube_test_Ref','var')
    [asphalt_h, asphalt_w, d] = size(asphalt_cube_test_Ref);
    samples = samples + (asphalt_h * asphalt_w);
end

if exist('tree_cube_test_Ref','var')
    [tree_h, tree_w, d] = size(tree_cube_test_Ref);
    samples = samples + (tree_h * tree_w);
end

if exist('rocks_cube_test_Ref','var')
    [rocks_h, rocks_w, d] = size(rocks_cube_test_Ref);
    samples = samples + (rocks_h * rocks_w);
end

if exist('water_cube_test_Ref','var')
    [water_h, water_w, d] = size(water_cube_test_Ref);
    samples = samples  + (water_h * water_w);
end

if exist('sky_cube_test_Ref','var')
    [sky_h, sky_w, d] = size(sky_cube_test_Ref);
    samples = samples + (sky_h * sky_w);
end

if exist('snow_cube_test_Ref','var')
    [snow_h, snow_w, d] = size(snow_cube_test_Ref);
    samples = samples + (snow_h * snow_w);
end

if exist('ice_cube_test_Ref','var')
    [ice_h, ice_w, d] = size(ice_cube_test_Ref);
    samples = samples + (ice_h * ice_w);
end

if exist('dirt_cube_test_Ref','var')
    [dirt_h, dirt_w, d] = size(dirt_cube_test_Ref);
    samples = samples + (dirt_h * dirt_w);
end

if exist('gravel_cube_test_Ref','var')
    [gravel_h, gravel_w, d] = size(gravel_cube_test_Ref);
    samples = samples + (gravel_h * gravel_w);
end

if exist('objects_cube_test_Ref','var')
    [objects_h, objects_w, d] = size(objects_cube_test_Ref);
    samples = samples + (objects_h * objects_w);
end

if exist('person_cube_test_Ref','var')
    [person_h, person_w, d] = size(person_cube_test_Ref);
    samples = samples + (person_h * person_w);
end

test_Data = zeros(d, samples);
test_Labels = zeros(1, samples);

sample_pos = 0;

% Get the data from undefined class.
if exist('undefined_cube_test_Ref','var')
    for i = 1:undefined_h
        for j = 1: undefined_w
            test_Data(:, sample_pos + ((i - 1) * undefined_w) + j) = undefined_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * undefined_w) + j) = undefined_labels(i, j);
        end
    end
    
    sample_pos = sample_pos + (undefined_h * undefined_w);      
end

% Get the data from grass class.
if exist('grass_cube_test_Ref','var')
    for i = 1:grass_h
        for j = 1: grass_w
            test_Data(:, sample_pos + ((i - 1) * grass_w) + j) = grass_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * grass_w) + j) = grass_labels(i, j);
        end
    end

    sample_pos = sample_pos + (grass_h * grass_w);
end

% Get the data from bush class.
if exist('bush_cube_test_Ref','var')
    for i = 1:bush_h
        for j = 1: bush_w
            test_Data(:, sample_pos + ((i - 1) * bush_w) + j) = bush_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * bush_w) + j) = bush_labels(i, j);
        end
    end

    sample_pos = sample_pos + (bush_h * bush_w);
end

% Get the data from mud class.
if exist('mud_cube_test_Ref','var')
    for i = 1:mud_h
        for j = 1: mud_w
            test_Data(:, sample_pos + ((i - 1) * mud_w) + j) = mud_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * mud_w) + j) = mud_labels(i, j);
        end
    end

    sample_pos = sample_pos + (mud_h * mud_w);
end

% Get the data from concrete class.
if exist('concrete_cube_test_Ref','var')
    for i = 1:concrete_h
        for j = 1: concrete_w
            test_Data(:, sample_pos + ((i - 1) * concrete_w) + j) = concrete_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * concrete_w) + j) = concrete_labels(i, j);
        end
    end

    sample_pos = sample_pos + (concrete_h * concrete_w);
end

% Get the data from asphalt class.
if exist('asphalt_cube_test_Ref','var')
    for i = 1:asphalt_h
        for j = 1: asphalt_w
            test_Data(:, sample_pos + ((i - 1) * asphalt_w) + j) = asphalt_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * asphalt_w) + j) = asphalt_labels(i, j);
        end
    end

    sample_pos = sample_pos + (asphalt_h * asphalt_w);
end

% Get the data from tree class.
if exist('tree_cube_test_Ref','var')
    for i = 1:tree_h
        for j = 1: tree_w
            test_Data(:, sample_pos + ((i - 1) * tree_w) + j) = tree_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * tree_w) + j) = tree_labels(i, j);
        end
    end

    sample_pos = sample_pos + (tree_h * tree_w);
end

% Get the data from rocks class.
if exist('rocks_cube_test_Ref','var')
    for i = 1:rocks_h
        for j = 1: rocks_w
            test_Data(:, sample_pos + ((i - 1) * rocks_w) + j) = rocks_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * rocks_w) + j) = rocks_labels(i, j);
        end
    end

    sample_pos = sample_pos + (rocks_h * rocks_w);
end

% Get the data from water class.
if exist('water_cube_test_Ref','var')
    for i = 1:water_h
        for j = 1: water_w
            test_Data(:, sample_pos + ((i - 1) * water_w) + j) = water_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * water_w) + j) = water_labels(i, j);
        end
    end

    sample_pos = sample_pos + (water_h * water_w);
end

% Get the data from sky class.
if exist('sky_cube_test_Ref','var')
    for i = 1:sky_h
        for j = 1: sky_w
            test_Data(:, sample_pos + ((i - 1) * sky_w) + j) = sky_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * sky_w) + j) = sky_labels(i, j);
        end
    end

    sample_pos = sample_pos + (sky_h * sky_w);
end

% Get the data from snow class.
if exist('snow_cube_test_Ref','var')
    for i = 1:snow_h
        for j = 1: snow_w
            test_Data(:, sample_pos + ((i - 1) * snow_w) + j) = snow_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * snow_w) + j) = snow_labels(i, j);
        end
    end

    sample_pos = sample_pos + (snow_h * snow_w);
end

% Get the data from ice class.
if exist('ice_cube_test_Ref','var')
    for i = 1:ice_h
        for j = 1: ice_w
            test_Data(:, sample_pos + ((i - 1) * ice_w) + j) = ice_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * ice_w) + j) = ice_labels(i, j);
        end
    end

    sample_pos = sample_pos + (ice_h * ice_w);
end

% Get the data from dirt class.
if exist('dirt_cube_test_Ref','var')
    for i = 1:dirt_h
        for j = 1: dirt_w
            test_Data(:, sample_pos + ((i - 1) * dirt_w) + j) = dirt_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * dirt_w) + j) = dirt_labels(i, j);
        end
    end

    sample_pos = sample_pos + (dirt_h * dirt_w);
end

% Get the data from gravel class.
if exist('gravel_cube_test_Ref','var')
    for i = 1:gravel_h
        for j = 1: gravel_w
            test_Data(:, sample_pos + ((i - 1) * gravel_w) + j) = gravel_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * gravel_w) + j) = gravel_labels(i, j);
        end
    end

    sample_pos = sample_pos + (gravel_h * gravel_w);
end

% Get the data from objects class.
if exist('objects_cube_test_Ref','var')
    for i = 1:objects_h
        for j = 1: objects_w
            test_Data(:, sample_pos + ((i - 1) * objects_w) + j) = objects_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * objects_w) + j) = objects_labels(i, j);
        end
    end

    sample_pos = sample_pos + (objects_h * objects_w);
end

% Get the data from person class.
if exist('person_cube_test_Ref','var')
    for i = 1:person_h
        for j = 1: person_w
            test_Data(:, sample_pos + ((i - 1) * person_w) + j) = person_cube_Ref(i, j, :);
            test_Labels(1, sample_pos + ((i - 1) * person_w) + j) = person_labels(i, j);
        end
    end

    sample_pos = sample_pos + (person_h * person_w);
end


%% This sample_pos should be as same as sample number.

if ~(sample_pos == samples)
    errordlg("Error in the sample count");
end


%% Data augmentation

rand_idx = randperm(samples, samples);

test_Data_Aug = zeros(d, samples);
test_Labels_Aug = zeros(1, samples);

for n = 1: samples
    test_Data_Aug(:, n) = test_Data(:, rand_idx(n));
    test_Labels_Aug(:, n) = test_Labels(:, rand_idx(n));
end

%% Data for CNN training

testDataCnn = reshape(test_Data_Aug,[1, d, 1, samples]);

testLabelCnn = categorical(test_Labels_Aug);

