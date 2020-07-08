function layer_ids = Mean_Pooling(vec_hsi, filter_size)
    % Get vectorized hyperspectral image
    
    % Find the maximum value by pooling
    
    [len,d] = size(vec_hsi);
    
    % Square filter without overlaps. Stride same as filter size.
    stride = filter_size;
        
    row_count = 1;
    filter = zeros(filter_size); 

    
    layer_ids = zeros(fix(len /filter_size), fix(d / filter_size));

    layer_y = 1;
    
    for i = 1:stride:d - filter_size         
        layer_x = 1;
        
        for row_count = 1:stride: len - filter_size
            
            previous_pxl_refl = 0;
            
            % Copy the maximum values to filter
            for n = 0:filter_size - 1
                for m = 0:filter_size - 1
                    
                    current_pxl_refl = vec_hsi(row_count + n, i + m);
                    filter(n + 1, m + 1) = current_pxl_refl;
                    
                    % Get the indexes of maximum value out of filter.
                    if previous_pxl_refl < current_pxl_refl
                        previous_pxl_refl = current_pxl_refl;
                        cell_id = i + m;                     
                    end
                    layer_ids(layer_x, layer_y) = cell_id; %current_pxl_refl;  % 
                end
            end
            
            % Get the maximum value out of filter.            
            row_count = row_count + stride;
            
            layer_x = layer_x + 1;
        end
        
        layer_y = layer_y + 1;
    end
     
end