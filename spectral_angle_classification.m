% Spectral angle based classification. Here it will use all the bands

% calculate average spectra for each class.

no_classes = 16;

class_avg_spectra = zeros(no_classes, bands);

class_ref_cubes= ["undefined_cube_Ref", "grass_cube_Ref", "bush_cube_Ref",...
            "mud_cube_Ref", "concrete_cube_Ref", "asphalt_cube_Ref",... 
            "tree_cube_Ref", "rocks_cube_Ref", "water_cube_Ref", ...
            "sky_cube_Ref", "snow_cube_Ref", "ice_cube_Ref", "dirt_cube_Ref",...
            "gravel_cube_Ref", "objects_cube_Ref", "person_cube_Ref"];
        
% Spectral angles.
spec_angles = zeros(no_classes, cols * lines, 'double');
        
for nClass = 1:no_classes
    class_name = class_ref_cubes(nClass);

    refCube = eval(class_name);

    [h, w, d] = size(refCube);
    
    vec_ref = zeros(h * w, d);
    
    for i = 1:h
        for j = 1:w
            vec_ref(((i - 1) * w) + j, :) = refCube(i, j, :);
        end
    end
    
    class_avg_spectra(nClass, :) = mean(vec_ref, 1);
    
    % Calculate the spectral angle.   
    
    for id_H = 1: cols
        for id_W = 1:lines
            
            inputVec = zeros(1, bands);
                
            inputVec(1, :) = reflectanceCube.DataCube(id_H, id_W,:);
            
            refSq = 0;
            inputSq = 0;
            input_ef_mul = 0;
    
            for n = 1:bands
                refSq =  refSq + (class_avg_spectra(nClass, n) * class_avg_spectra(nClass, n));
                
                inputSq =  inputSq + (inputVec(1, n) * inputVec(1, n));
                
                input_ef_mul = input_ef_mul + (inputVec(1, n) * class_avg_spectra(nClass, n));
            end
            
            sa =  acos(input_ef_mul / (sqrt(refSq) * sqrt(inputSq)));
            
            spec_angles(nClass, ((id_H - 1) * lines) + id_W) = sa;
            
        end
    end
        
end

%% Display classification

classifiedImage = zeros(cols, lines, 3, 'uint8');

for n = 1: length(spec_angles) - 1
    
    row = fix(n/lines) + 1;
    column = mod(n,lines) + 1;
    
    [val, id] = max(spec_angles(:, n));
       
    
    classifiedImage(row, column, :) = Get_Label_Color(id);
    
end

figure();
imshow(classifiedImage)

