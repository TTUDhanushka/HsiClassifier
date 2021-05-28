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


### k - Means Clustering


### 1-D Convolutional Neural Networks

