
digitDatasetPath = fullfile("7v0");

imds_test = imageDatastore(digitDatasetPath, 'IncludeSubfolders', true,'LabelSource', 'foldernames');

[imdsTrain, imdsValidation] = splitEachLabel (imds_test, 0.7, 'randomize');

layers = [
 imageInputLayer([28 28 1]) % input layer (grayscale image with size of 28x28 pixels)
 convolution2dLayer(5,16,'Padding', 'same') % 16 convolution filters with size of 5
 batchNormalizationLayer % normalization layer
 reluLayer

 fullyConnectedLayer(10) % 10 - number of neurons
 softmaxLayer % normalization
 classificationLayer
];

classify(layers, imds_test)