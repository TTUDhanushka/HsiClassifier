### Manifold Alignment Method

script ***Hsi_Rgb_manifold_alignment.m***


### Bilateral Filter


### Selected Three Spectral Bands

These spectral bands were selected from each of red, green and blue chennels where each band corresponds to the peak wavelength.

### CIE Color Conversion from XYZ to RGB

    function [rgbImage] = RGB_From_CIE(dataCube, selectedBands)

|Args||
|--------|----------|
|`dataCube` | Hyperspectral data cube with all the spectral bands (h x w x d) matrix.|
|`selectedBands` | Vector of selected hyperspectral bands from band selection. |       
        
|Returns||
|--------|----------|
|`rgbImage` | Spatial image (RGB).|