### Reduced Band Image Creation

    function reducedCube = ReducedBandImage(hsiCube, bandsList)

|Args||
|--------|----------|
|`hsiCube` | Hyperspectral data cube with all the spectral bands (h x w x d) matrix.|
|`bandsList` | Vector of selected hyperspectral bands from band selection. |       
        
|Returns||
|--------|----------|
|`reducedCube` | Spectral data cube with selected number of image bands.|