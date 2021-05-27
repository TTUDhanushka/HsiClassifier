### Reduced Band Image Creation

    function reducedCube = ReducedBandImage(hsiCube, bandsList)

This function extracts all the selected band data from HSI image.

|Args||
|--------|----------|
|`hsiCube` | Hyperspectral data cube with all the spectral bands (h x w x d) matrix.|
|`bandsList` | Vector of selected hyperspectral bands from band selection. |       
        
|Returns||
|--------|----------|
|`reducedCube` | Spectral data cube with selected number of image bands.|

### Get Label Colors

    function label_color = Get_Label_Color(class_id)

This project uses 16 terrain classes. The class labels are defined in this function.

|Args||
|--------|----------|
|`class_id` | Class ID (1 - 16).|   
        
|Returns||
|--------|----------|
|`label_color` | Color vector.|


### Create RGB Image from Pre-defined Bands

    function imgOut = GetTriBandRgbImage(data_cube)

Create RGB visualization using three selected spectral bands from red, green and blue wavelength regions.

|Args||
|--------|----------|
|`data_cube` | Entire HSI data cube.|   
        
|Returns||
|--------|----------|
|`imgOut` | RGB image out with uint8 data type.|


### Create RGB Image from Selected Bands

    function rgb_Out = ConstructRgbImage(hsi_cube, redBand, greenBand, blueBand)

|Args||
|--------|----------|
|`hsi_cube` | Entire HSI data cube.|   
|`redBand` | Selected band for red channel.|
|`greenBand` | Selected band for green channel.|
|`blueBand` | Selected band for blue channel.|
        
|Returns||
|--------|----------|
|`rgb_Out` | RGB image out with uint8 data type.|


### Create Grayscale Image of a Selected Band

    imgGrayOut = GetSingleBandGrayscaleImage(data_cube, band)

|Args||
|--------|----------|
|`data_cube` | Entire HSI data cube.| 
|`band` | The spectral band number which need to be visualized in grayscale.|   
        
|Returns||
|--------|----------|
|`imgGrayOut` | Grayscale image out with uint8 data type.|


### Rotate Hyperspectral Image

    function output_image = RotateHsiImage(hsi_image, angle)

Rotate the hyperspectral image by a certain angle. Input Image preferable square matrix with [n, n, d] dimensions.
Specim hyperspectral images are rotated 90 degrees counterclockwise.

|Args||
|--------|----------|
|`hsi_image` | Entire HSI data cube.| 
|`angle` | Anglein degrees.|   
        
|Returns||
|--------|----------|
|`output_image` | Rotated hyperspectral image.|