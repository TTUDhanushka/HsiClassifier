
### Min-Max Pooling

    function selected_bands = Min_Max_Pooling(vec_hsi, reduced_bands_count)

Band selection using pooling method. For this method, the HSI image should be unfolded such that the original HSI in [h, w, d] should convert to [h * w, d].

|Args||
|--------|----------|
|`vec_hsi` | The unfolded hyperspectral data as mentioned in the above description.|
|`reduced_bands_count`|Number of desired bands count from band selection.|       
      
|Returns||
|--------|----------|
|`selected_bands`| Vector of selected hyperspectral image bands. Vector of [1, no_Of_bands]| 

### CNN and Distance Density

Method was proposed in [article](https://ieeexplore.ieee.org/abstract/document/8113688). 

    function selected_bands = DistanceDensityBandSelection(hsiDataCube, partitions, bandsPerPartition)

|Args||
|--------|----------|
|`hsiDataCube` | Full data cube containing all the spectral bands without unfolding.|
|`partitions`| Number of partitions in the spectral axis.|
|`bandsPerPartition`| Number of bands in the selected partition.|         
      
|Returns||
|--------|----------|
|`selected_bands`| Vector of selected hyperspectral image bands. Vector of [1, no_Of_bands]|




