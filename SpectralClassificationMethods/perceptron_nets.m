%% Shallow neural networks without back propagation

no_of_bands = 25;
no_of_classes = 8;

%% Three layer neural network
two_layer_net = feedforwardnet([no_of_bands no_of_classes], 'trainlm');

two_layer_net.performFcn = 'crossentropy';

two_layer_net.trainParam.epochs = 5000;

two_layer_net.layers{3}.transferFcn  = 'softmax'; 

[two_layer_net, tr] = train(two_layer_net, P', T', 'useGPU','yes');

%% Three layer neural network
three_layer_net = feedforwardnet([no_of_bands 50 no_of_classes], 'trainlm');

three_layer_net.performFcn = 'crossentropy';

three_layer_net.trainParam.epochs = 5000;

three_layer_net.layers{3}.transferFcn  = 'softmax'; 

[three_layer_net, tr] = train(three_layer_net, P', T', 'useGPU','yes');


%% Four layer neural network
four_layer_net = feedforwardnet([no_of_bands 50 20 no_of_classes], 'trainlm');

four_layer_net.performFcn = 'crossentropy';
% net.performFcn = 'mse';

four_layer_net.trainParam.epochs = 5000;

% net.output = softmaxLayer();
four_layer_net.layers{4}.transferFcn  = 'softmax'; 


[four_layer_net, tr] = train(four_layer_net, P', T', 'useGPU','yes');