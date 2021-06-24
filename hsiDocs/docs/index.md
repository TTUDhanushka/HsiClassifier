# HSI Classification Code Documentation

Author [Dhanushka Liyanage](http://dhanushkaliyanage.com/).

## Getting Docs Online

* Use anaconda promt and change directory into the "hsiDocs" folder on HSI classifier v1.0.

    ```
        cd "G:\3. Hyperspectral\5. Matlab HSI\1. HSI classifier v1.0\hsiDocs"
    ```

* `mkdocs serve` - Start the live-reloading docs server.

* Open ```http://127.0.0.1:8000/``` on browser.

* `mkdocs help` - Print this help message.



## Structure

| Folder | Description |
| ----------- | ----------- |
| BandSelectionMethods | Contains all the band selection methods tested in this project. |
| SpectralClassificationMethods | SVM, kNN, 1D CNN, MLP and other classification methods. |
| SpectralSpatialClassificationMethods | CNN classification methods for both spectral-spatial combined classification. |
| HelperFunctions |<ul><li>Calibrate spectral images</li><li>Get label color</li><li>Get data files</li><li>Get single band grayscale image</li><li>Get tri band RGB image</li><li>Rotate HSi image</li><li>Overlay points</li><li>Reduced band image</li></ul>|
| HsiToRgb | Hyperspectral image visualization in RGB color space and export as RGB image. |
| ImageQualityMatrices | RGB visualization quality estimation matrices. |
| Old | Old MATLAB scripts which are no longer in use. |
| AdditionalMatlabScripts | Some experimental scripts. (Not required) |
| hsiDocs | Complete documentation. |
| Root | All the other scripts and functions are on root folder. |


## Source Code
The code is on [github](https://github.com/TTUDhanushka/HsiClassifier.git) as a private repository. Request access if needed.


> The documentation is continuously updating.

