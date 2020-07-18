## HsiClassifier

### Create spectral data library using BuildSpectralLibrary.m file
In the working directory, it will create additional folder named "SpectralLibrary". This folder contains, datacubes, spectral distribution, 
meta data and location of the sample data captured for each class.

### Training various neural network architectures
Various neural network architectures are implementd in "percepttron_nets.m" file.
These networks can be trained using "nn_trainer.m" script. And the "nn_tester.m" has all the functions needed for classification.
All the neural networks are based on multilayer perceptrons which are comprise of purelin activation functions. The only exception for the output layer which has softmax activation function.

1. Two layer network
2. Three layer network
3. Four layer network
