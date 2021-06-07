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

### Unfold Hyperspectral Data Cube

    function outputVectors = UnfoldHsiCube(dataCube)

|Args||
|--------|----------|
|`dataCube` | HSI data cube. This can be any number of spectral bands.| 
        
|Returns||
|--------|----------|
|`outputVectors` | Unfolded HSI image with[bands, columns * lines] matrix.|

### Collect Spectral Training and Testing Data

    function [classDataCube, classLabels] =  CollectObjectClassData(className, dataCube)

|Args||
|--------|----------|
|`className` | Class name as a string.|
|`dataCube` | HSI data cube. This can be any number of spectral bands.| 
        
|Returns||
|--------|----------|
|`classDataCube` | Collected data cube containing same number of spectral bands as the original HSI cube.|
|`classLabels` | Class labels.| 

### Plot Spectral Characteristic Curves

    function fig = PlotSpectralCharacteristics(classCube, className, bandsList)

|Args||
|--------|----------|
|`classCube` | HSI sample data cube for a terrain object class.| 
|`className` | Class name as a string.|
|`bandsList` | List of spectral bands as a vector.|
        
|Returns||
|--------|----------|
|`fig` | Spectral characteristic figure as gcf.|

### Update Class Datasets in Workspace

This is only for combining different class datacubes in the workspace.

    function [classCube, classLabels] = UpdateClassSampleCubes(className, dataCubeSample, dataLabels, existOnWs)

|Args||
|--------|----------|
|`className` | Class name as a string.|
|`dataCubeSample` | HSI sample data cube for a terrain object class.| 
|`dataLabels` | List of spectral bands as a vector.|
|`existOnWs` | List of spectral bands as a vector.|
        
|Returns||
|--------|----------|
|`classCube` | Spectral characteristic figure as gcf.|
|`classLabels` | Spectral characteristic figure as gcf.|

### Bands Reduced Training Data for CNNs

    function reducedBandData = GetReducedBandData1D(trainingData, bandsList)

The purpose of the above function is to extract the necessary bands from the collected HSI training data for classification and band selection. The input for this method should be unfolded HSI data with all the bands (204 bands).

|Args||
|--------|----------|
|`trainingData` | The unfolded hyperspectral data as mentioned in the above description.|
|`bandsList`| Vector of selected hyperspectral image bands.|       
      
|Returns||
|--------|----------|
|`reducedBandData`| Only selected bands will be available in the output data matrix.| 


