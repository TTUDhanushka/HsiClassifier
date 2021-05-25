# HSI Classification Code Documentation

Author [Dhanushka](http://dhanushkaliyanage.com/).

## Getting Docs Online

* Use anaconda promt and change directory into the "hsiDocs" folder on HSI classifier v1.0.

* `mkdocs serve` - Start the live-reloading docs server.

* Open "http://127.0.0.1:8000/" on browser.

* `mkdocs help` - Print this help message.



## HSI classifier v1.0

| Folder | Description |
| ----------- | ----------- |
| BandSelectionMethods | Contains all the band selection methods tested in this project. |
| ClassificationMethods | SVM, kNN, 1D CNN, MLP and other classification methods. |


## BandSelectionMethods


#### Min-Max Pooling

        function selected_bands = Min_Max_Pooling(vec_hsi, reduced_bands_count)

        Parameters: 'vec_hsi, reduced_bands_count'
            vec_hsi - the unfolded hyperspectral data. 
            reduced_bands_count - number of desired bands count from band selection.