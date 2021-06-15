This page contains hyperspectral image classification methods based on spectral data alone. 
These methods take the pixelwise spectral characteristics into consideration for the classification.

### Spectral Angle Mapper

Spectral angle mapper uses entire spectral bands (204 bands) in the image as it uses sample data from the workspace which are in 204 bands.
It can be used with reduced HSI cube along with class input data with same number of spectral bands.
 
The SAM classifier requires training data from all 16 classes. These data must be available on the MATLAB workspace.

    function resultsVector = SamClassification(hsiCube)

|Args||
|--------|----------|
|`hsiCube` | Hyperspectral data cube with all the spectral bands (h x w x d) matrix.|
     
        
|Returns||
|--------|----------|
|`resultsVector` | Classification result as a vector which is same as unfolded HSI cube .|

### Support Vector Machines Classifier

Support Vector Machines (SVM) method for HSI classification. This script can be used either to classify all the 204 or selected number of bands. 
Training data also needs to be transform.

Below variables should be available in the base workspace.

    Input data: reflectanceCube.DataCube
    Bands list: bSet

### k - Means Clustering

Several parameters should be defined in the script.

    kClasses = 13

### 1-D Convolutional Neural Networks

CNN was created according to the Distance Density Band Selection article.