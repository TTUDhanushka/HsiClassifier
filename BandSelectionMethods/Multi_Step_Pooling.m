function [selected_bands, no_of_steps] = Multi_Step_Pooling(vec_hsi, target_bands)
    %% Multi step pooling based on maximum value
    
    %%
    % Uses multi step pooling method to reduce number of bands
    [len,d] = size(vec_hsi);

    samples = len;
        
    no_of_steps = 0;
    
    % Start with 3x3 filters, estimate number of iterations.
    kernal_size = 5;
    
    % If the target number of bands can't be achieved with the filter size
    % then some of the bands from original image need to be ignored. The
    % most suitable regions are at the very beggining of the spectrum and
    % at the very end of the spectrum. This is due to the fact that there
    % are noises at the beginning and at the end.
    
    remainder = mod(d,target_bands);
    
    if remainder > 0
        % Remove bands from start and end. Usually near infra red zone
        % carries more information compared to ultra-violet region.
        % Therefore max number of bands should be removed from the
        % beginning than at the end.
        
        odd_or_even = mod(remainder, 2);
        removable = (remainder - odd_or_even) / 2;
        
        if odd_or_even == 0
            % Remove equal number of bands from start and end
            starting_band = removable;
            bands = d - (2 * removable);
        else
            % Remove more number of bands from the start than the end.
            starting_band = removable + 1;
            bands = d - (2 * removable) - 1;
        end
        
        ending_band = d - removable;

    else
        starting_band = 1;
        ending_band = d;
        bands = d;
    end
    
    %% Calculate number of iterations to reach target number of bands.
    
    while bands > target_bands
        bands =  bands / kernal_size;
        no_of_steps = no_of_steps + 1;
    end
    
    %% Perform max pooling
    
    filter = zeros(kernal_size,kernal_size);
    
    % 3 - dimensional array to store all the pixrl ids taken for further
    % pooling.
    cell_id = zeros(len, d);
    
    for cell_idx = 1:d
        cell_id(:,cell_idx) = cell_idx;
    end
    
    cell_reflectance = vec_hsi;
    
    
    % Iterate pooling multiple times until it reduce the number of bands to
    % the target number
    for iterations = 1:no_of_steps
    row_count = 1;
    
        % Search in equal intervals of "init_kernals".
        for i = 1 : kernal_size: (samples - kernal_size)
            col_count = 1;
                
            for j = starting_band : kernal_size: (ending_band - kernal_size)

                % Get maximum reflectance of the pixel.           
                previous_intensity = 0;

                for m = 1:kernal_size
                    for n = 1: kernal_size
                        filter(m,n) = cell_reflectance(i + m - 1, j + n - 1);
                        current_intensity = filter(m,n);

                        if current_intensity > previous_intensity
                            previous_intensity = current_intensity;

%                             cell_id(row_count, col_count, 1) = i + m;        % Get the cell id
                            cell_id(row_count, col_count) = cell_id(i + m, j + n);        % Get the cell id

                            cell_reflectance(row_count, col_count) = current_intensity;
                        end
                    end
                end
                col_count = col_count + 1;
            end
            row_count = row_count + 1;
        end
        samples = row_count;
        starting_band = 1;
        ending_band = col_count;
        x_x = current_intensity;
    end        

    bands_temp = zeros(row_count, col_count);
    
    for i = 1:row_count
        for j = 1:col_count
            bands_temp(i,j) = cell_id(i,j);
        end
    end
    
    selected_bands = zeros(1,target_bands);
    
    for band_index = 1:target_bands

        band = round(mean(bands_temp(:, band_index)));

        selected_bands(1, band_index) = band;
    end
    
end