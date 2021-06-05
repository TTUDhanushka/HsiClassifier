
% Get the datacubes for each class from the workspace. The training data
% cubes for each class including the labels should be on the workspace. The
% training_data.mat file contains all the training data. In this script it
% will convert the HSI data into 4-D array and class labels into
% categorical vector.


%%
% All the datacubes should have same number of bands.

samples = 0;

if exist('undefined_cube_Ref','var')
    [d, undefined_h] = size(undefined_cube_Ref);
    samples = samples + (undefined_h);
end

if exist('grass_cube_Ref','var')
    [d, grass_h] = size(grass_cube_Ref);
    samples = samples + (grass_h);
end

% if exist('bush_cube_Ref','var')
%     [d, bush_h] = size(bush_cube_Ref);
%     samples = samples + (bush_h);
% end

if exist('mud_cube_Ref','var')
    [d, mud_h] = size(mud_cube_Ref);
    samples = samples + (mud_h);
end

if exist('concrete_cube_Ref','var')
    [d, concrete_h] = size(concrete_cube_Ref);
    samples = samples + (concrete_h);
end

if exist('asphalt_cube_Ref','var')
    [d, asphalt_h] = size(asphalt_cube_Ref);
    samples = samples + (asphalt_h);
end

if exist('tree_cube_Ref','var')
    [d, tree_h] = size(tree_cube_Ref);
    samples = samples + (tree_h);
end

if exist('rocks_cube_Ref','var')
    [d, rocks_h] = size(rocks_cube_Ref);
    samples = samples + (rocks_h);
end

if exist('water_cube_Ref','var')
    [d, water_h] = size(water_cube_Ref);
    samples = samples  + (water_h);
end

if exist('sky_cube_Ref','var')
    [d, sky_h] = size(sky_cube_Ref);
    samples = samples + (sky_h);
end

% if exist('snow_cube_Ref','var')
%     [snow_h, snow_w, d] = size(snow_cube_Ref);
%     samples = samples + (snow_h * snow_w);
% end

% if exist('ice_cube_Ref','var')
%     [ice_h, ice_w, d] = size(ice_cube_Ref);
%     samples = samples + (ice_h * ice_w);
% end

if exist('dirt_cube_Ref','var')
    [d, dirt_h] = size(dirt_cube_Ref);
    samples = samples + (dirt_h);
end

if exist('gravel_cube_Ref','var')
    [d, gravel_h] = size(gravel_cube_Ref);
    samples = samples + (gravel_h);
end

if exist('objects_cube_Ref','var')
    [d, objects_h] = size(objects_cube_Ref);
    samples = samples + (objects_h);
end

if exist('person_cube_Ref','var')
    [d, person_h] = size(person_cube_Ref);
    samples = samples + (person_h);
end

training_Data = zeros(d, samples);
training_Labels = zeros(1, samples);

sample_pos = 0;

% Get the data from undefined class.
if exist('undefined_cube_Ref','var')
    for i = 1:undefined_h        
        training_Data(:, sample_pos + i) = undefined_cube_Ref(:, i);
        training_Labels(1, sample_pos + i) = undefined_labels(1, i);       
    end
    
    sample_pos = sample_pos + (undefined_h);      
end

% Get the data from grass class.
if exist('grass_cube_Ref','var')
    for i = 1:grass_h      
        training_Data(:, sample_pos + i) = grass_cube_Ref(:, i);
        training_Labels(1, sample_pos + i) = grass_labels(1, i);        
    end

    sample_pos = sample_pos + (grass_h);
end

% % Get the data from bush class.
% if exist('bush_cube_Ref','var')
%     for i = 1:bush_h
%         training_Data(:, sample_pos + i) = bush_cube_Ref(:, i);
%         training_Labels(1, sample_pos + i) = bush_labels(1, i);
%     end
%     
%     sample_pos = sample_pos + (bush_h);
% end

% Get the data from mud class.
if exist('mud_cube_Ref','var')
    for i = 1:mud_h
        training_Data(:, sample_pos + i) = mud_cube_Ref(:, i);
        training_Labels(1, sample_pos + i) = mud_labels(1, i);
    end

    sample_pos = sample_pos + (mud_h);
end

% Get the data from concrete class.
if exist('concrete_cube_Ref','var')
    for i = 1:concrete_h
        training_Data(:, sample_pos + i) = concrete_cube_Ref(:, i);
        training_Labels(1, sample_pos + i) = concrete_labels(1, i);
    end

    sample_pos = sample_pos + (concrete_h);
end

% Get the data from asphalt class.
if exist('asphalt_cube_Ref','var')
    for i = 1:asphalt_h
        training_Data(:, sample_pos + i) = asphalt_cube_Ref(:, i);
        training_Labels(1, sample_pos + i) = asphalt_labels(1, i);
    end

    sample_pos = sample_pos + (asphalt_h);
end

% Get the data from tree class.
if exist('tree_cube_Ref','var')
    for i = 1:tree_h
        training_Data(:, sample_pos + i) = tree_cube_Ref(:, i);
        training_Labels(1, sample_pos + i) = tree_labels(1, i);
    end

    sample_pos = sample_pos + (tree_h);
end

% Get the data from rocks class.
if exist('rocks_cube_Ref','var')
    for i = 1:rocks_h
        training_Data(:, sample_pos + i) = rocks_cube_Ref(:, i);
        training_Labels(1, sample_pos + i) = rocks_labels(1, i);
    end
    
    sample_pos = sample_pos + (rocks_h);
end

% Get the data from water class.
if exist('water_cube_Ref','var')
    for i = 1:water_h
        training_Data(:, sample_pos + i) = water_cube_Ref(:, i);
        training_Labels(1, sample_pos + i) = water_labels(1, i);
    end
    
    sample_pos = sample_pos + (water_h);
end

% Get the data from sky class.
if exist('sky_cube_Ref','var')
    for i = 1:sky_h
        training_Data(:, sample_pos + i) = sky_cube_Ref(:, i);
        training_Labels(1, sample_pos + i) = sky_labels(1, i);
    end
    
    sample_pos = sample_pos + (sky_h);
end

% % Get the data from snow class.
% if exist('snow_cube_Ref','var')
%     for i = 1:snow_h
%         for j = 1: snow_w
%             training_Data(:, sample_pos + ((i - 1) * snow_w) + j) = snow_cube_Ref(i, j, :);
%             training_Labels(1, sample_pos + ((i - 1) * snow_w) + j) = snow_labels(i, j);
%         end
%     end
% 
%     sample_pos = sample_pos + (snow_h * snow_w);
% end

% % Get the data from ice class.
% if exist('ice_cube_Ref','var')
%     for i = 1:ice_h
%         for j = 1: ice_w
%             training_Data(:, sample_pos + ((i - 1) * ice_w) + j) = ice_cube_Ref(i, j, :);
%             training_Labels(1, sample_pos + ((i - 1) * ice_w) + j) = ice_labels(i, j);
%         end
%     end
% 
%     sample_pos = sample_pos + (ice_h * ice_w);
% end

% Get the data from dirt class.
if exist('dirt_cube_Ref','var')
    for i = 1:dirt_h        
        training_Data(:, sample_pos + i) = dirt_cube_Ref(:, i);
        training_Labels(1, sample_pos + i) = dirt_labels(1, i);        
    end
    
    sample_pos = sample_pos + (dirt_h);
end

% Get the data from gravel class.
if exist('gravel_cube_Ref','var')
    for i = 1:gravel_h
        training_Data(:, sample_pos + i) = gravel_cube_Ref(:, i);
        training_Labels(1, sample_pos + i) = gravel_labels(1, i);
    end
    
    sample_pos = sample_pos + (gravel_h);
end

% Get the data from objects class.
if exist('objects_cube_Ref','var')
    for i = 1:objects_h
        training_Data(:, sample_pos + i) = objects_cube_Ref(:, i);
        training_Labels(1, sample_pos + i) = objects_labels(1, i);
    end
    
    sample_pos = sample_pos + (objects_h);
end

% Get the data from person class.
if exist('person_cube_Ref','var')
    for i = 1:person_h
            training_Data(:, sample_pos + i) = person_cube_Ref(:, i);
            training_Labels(1, sample_pos + i) = person_labels(1, i);
    end

    sample_pos = sample_pos + (person_h);
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

