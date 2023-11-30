close all;
clc;


digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos','nndatasets', 'DigitDataset');
imds = imageDatastore(digitDatasetPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[imdsTrain, imdsValidation] = splitEachLabel(imds, 0.7, 'randomize');

% Define the layers of the CNN
layers = [
    imageInputLayer([28 28 1])
    convolution2dLayer(5, 16, 'Padding', 'same') 
    batchNormalizationLayer 
    reluLayer 
    
    convolution2dLayer(8, 20, 'Padding', 'same') 
    batchNormalizationLayer 
    leakyReluLayer 
    
    fullyConnectedLayer(10) 
    softmaxLayer 
    classificationLayer
];

% in the case of already trained neural net uncomment this block
%load net;
% in the case of already trained neural net comment this block
options = trainingOptions('sgdm', ...
   'ExecutionEnvironment', 'parallel', ...
   'MaxEpochs', 10, ...
  'ValidationData', imdsValidation, ...
 'ValidationFrequency', 10, ...
   'Verbose', true, ...
    'Plots', 'training-progress');

% in the case of already trained neural net comment this block
net = trainNetwork(imdsTrain, layers, options);

% in the case of already trained neural net comment this block

save net;

% Create test imageDatastore
testImagesPath = '7v0';
imds_test = imageDatastore(testImagesPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% Apply transformation
preproc_imds_test = transform(imds_test, @preprocessData);


% Classify test images
predictedLabels = classify(net, preproc_imds_test);



figure;
numImages = numel(predictedLabels);
for i = 1:numImages
    % Display the test image
    subplot(2, numImages, i); % Top row for images
    testImage = readimage(imds_test, i);
    imshow(testImage);
    title(['Image: ', num2str(i)]);

    % Display the predicted label
    subplot(2, numImages, i + numImages);
    axis off; 
    text(0.5, 0.5, char(predictedLabels(i)), 'HorizontalAlignment', 'Center', ...
         'VerticalAlignment', 'Middle', 'FontSize', 10); 
end

function out = preprocessData(data)

    data = {data};

    out = cell(size(data));
    for i = 1:numel(data)
        img = data{i};
        if size(img, 3) == 3
            img = rgb2gray(img); % Convert to grayscale if RGB
        end

        % Binarize the image using a global threshold
        threshold = graythresh(img);
        img = imbinarize(img, threshold);

        % Invert the image
        img = ~img;

        % Remove small objects that are not the digit
        img = bwareaopen(img, 30);

        % Extract the largest connected component, which is likely the digit
        img = bwareafilt(img, 1);

        % Find the bounding box around the digit
        props = regionprops(img, 'BoundingBox');
        if ~isempty(props)
            bbox = props(1).BoundingBox;
            img = imcrop(img, bbox);
        end

        % Determine padding to center the digit in a 28x28 image
        [rows, cols] = size(img);
        targetSize = 20; % Target size for the digit, to leave some space for padding
        scaleFactor = min([targetSize / rows, targetSize / cols]);
        img = imresize(img, scaleFactor); % Resize the image to the target size

        % Calculate padding size to center the digit in the final image
        [rows, cols] = size(img);
        padVert = floor((28 - rows) / 2);
        padHorz = floor((28 - cols) / 2);
        padSize = [padVert, padHorz];

        % Pad the image to get a final size of 28x28
        img = padarray(img, padSize, 0, 'pre');
        img = padarray(img, padSize, 0, 'post');
        if mod(rows, 2) ~= 0
            img = padarray(img, [1, 0], 0, 'post');
        end
        if mod(cols, 2) ~= 0
            img = padarray(img, [0, 1], 0, 'post');
        end

        % Convert to uint8 format
        out{i} = im2uint8(img);
    end
end
