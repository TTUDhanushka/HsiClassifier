## HSI Classifier v1.0

### Startup script : MainProgram.m

Here are the steps to use the script.
1. Collect training spectral data for each class into workspace. Then save them as workspace files with ".mat".  

   The class names are unique and only 16 classes will be used in this project. They are listed in "HelperFunctions\Get_Label_Color.m".

2. Need to use MainProgram.m and CollectTrainingData.m to get the training data.

3. The Mainprogram.m should run in section-by-section. 

4. DatacubeTransformTo1D.m will convert the dataset into 1D CNN input arrays.

5. Train the neural networks or other type of classifiers.
    1D CNN
    K Means clustering
    SVM

6. Display classification result.

