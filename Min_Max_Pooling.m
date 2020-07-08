function selected_bands = Min_Max_Pooling(vec_hsi, reduced_bands_count)
    % Preserve key characteristics in the spectral graph with
    % min max pooling

    % Find the maximum value by pooling

    [len,d] = size(vec_hsi);

    filter_size = floor(d / reduced_bands_count);

    % Square filter without overlaps. Stride same as filter size.
    stride = filter_size;

    row_count = 1;
    filter = zeros(filter_size);

    selected_ids = zeros(fix(len /filter_size), reduced_bands_count);

    layer_ids = zeros(2, fix(d / filter_size));
    layer_data = zeros(2, fix(d / filter_size));

    layer_y = 1;

    for row_count = 1:stride: len - filter_size

        layer_x = 1;

        cur_cell_id_max = 1;
        cur_cell_id_min = 1;

        for i = 1:stride:d - filter_size

            current_pxl_refl_max = 0;
            current_pxl_refl_min = 0;

            initialized = false;

            % Copy the maximum values to filter
            for n = 0:filter_size - 1
                for m = 0:filter_size - 1

                    current_pxl_refl = vec_hsi(row_count + n, i + m);
                    filter(n + 1, m + 1) = current_pxl_refl;

                    % Get the indexes of maximum value out of filter.
                    if current_pxl_refl_max < current_pxl_refl
                        current_pxl_refl_max = current_pxl_refl;
                        cur_cell_id_max = i + m;
                    end

                    % Get the indexes of minimum value out of filter.
                    if current_pxl_refl_min > current_pxl_refl
                        current_pxl_refl_min = current_pxl_refl;
                        cur_cell_id_min = i + m;
                    end

                    if ~initialized
                        current_pxl_refl_min = current_pxl_refl;
                        cur_cell_id_max = i;
                        cur_cell_id_min = i;
                        initialized = true;
                    end

                    layer_ids(1, layer_x) = cur_cell_id_min;
                    layer_ids(2, layer_x) = cur_cell_id_max;

                    layer_data(1, layer_x) = current_pxl_refl_min;
                    layer_data(2, layer_x) = current_pxl_refl_max;

                end
            end

            layer_x = layer_x + 1;
        end

        % Skip pooling operation in certain cases. Two nearby points show
        % distinct characteristics,.etc
        skip_next = false;
        
        % Create temporary arrays of 4 elements
        ids_temp = zeros(1,4);
        values_temp = zeros(1,4);

        % Copy four consecutive cell index to new array
        for p = 1:reduced_bands_count - 1

            ids_temp(1, 1) = layer_ids(1, p);           % First band
            ids_temp(1, 2) = layer_ids(2, p);           % First band
            ids_temp(1, 3) = layer_ids(1, p + 1);       % Second band
            ids_temp(1, 4) = layer_ids(2, p + 1);       % Second band

            values_temp(1, 1) = layer_data(1, p);           % First band
            values_temp(1, 2) = layer_data(2, p);           % First band
            values_temp(1, 3) = layer_data(1, p + 1);       % Second band
            values_temp(1, 4) = layer_data(2, p + 1);       % Second band

            % Arrange them in ascending order along with values
            [Id_ascend, Id_key] = sort(ids_temp);
            values_temp_ascend = values_temp(Id_key);

            % Eliminate cell id if two are very close to each other
            % Take 3 gradients of 3 line segments.

            if (~skip_next)

                %% If three adjacent points are distant to one another.

                if (Id_ascend(1,3) - Id_ascend(1,2)) > 2

                    % Calculate gradients of two adjacent line segments

                    grad_seg_1 = (values_temp_ascend(1,2) - values_temp_ascend(1,1)) / (Id_ascend(1,2) - Id_ascend(1,1));
                    grad_seg_2 = (values_temp_ascend(1,3) - values_temp_ascend(1,2)) / (Id_ascend(1,3) - Id_ascend(1,2));
                    grad_seg_3 = (values_temp_ascend(1,4) - values_temp_ascend(1,3)) / (Id_ascend(1,4) - Id_ascend(1,3));

                    % Get the absolute value of gradient difference

                    if ((abs((grad_seg_2 - grad_seg_1)) > 0.15) && (abs((grad_seg_3 - grad_seg_2)) > 0.15))
                        selected_ids(layer_y, p) = Id_ascend(1,2);
                        selected_ids(layer_y, p + 1) = Id_ascend(1,3);

                        skip_next = true;

                    elseif ((abs((grad_seg_2 - grad_seg_1)) > 0.15) && (abs((grad_seg_3 - grad_seg_2)) < 0.15))
                        selected_ids(layer_y, p) = Id_ascend(1,2);
                        
                    elseif ((abs((grad_seg_2 - grad_seg_1)) < 0.15) && (abs((grad_seg_3 - grad_seg_2)) > 0.15))
                        selected_ids(layer_y, p) = Id_ascend(1,3);
                        
                    else
                        selected_ids(layer_y, p) = Id_ascend(1,1);
                    end
                    %%
                else
                    grad_seg_1 = (values_temp_ascend(1,2) - values_temp_ascend(1,1)) / (Id_ascend(1,2) - Id_ascend(1,1));
                    grad_seg_3 = (values_temp_ascend(1,2) - values_temp_ascend(1,1)) / (Id_ascend(1,2) - Id_ascend(1,1));

                    if abs((grad_seg_3 - grad_seg_1)) > 0.15
                        selected_ids(layer_y, p) = Id_ascend(1,2);
                    else
                        selected_ids(layer_y, p) = Id_ascend(1,1);
                    end
                end
                

                
                %%
            else
                skip_next = false;  
            end
            
            % For the last point in the selected id table
            if (p == reduced_bands_count - 1)
                selected_ids(layer_y, p + 1) = Id_ascend(1,4);
            end
        end
        % Continue to next layer.
        row_count = row_count + stride;

        layer_y = layer_y + 1;
    end

    % Get final selected bands for the feature detection.

    selected_bands = zeros(1,reduced_bands_count);

    for band_index = 1:reduced_bands_count

        band = round(mean(selected_ids(:, band_index)));

        if band ~= 0
            selected_bands(1, band_index) = band;
        else
            selected_bands(1, band_index) = 1;
        end
    end

end