close all;
% Path to the MNIST dataset
digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos','nndatasets', 'DigitDataset');

% Create imageDatastore
imds = imageDatastore(digitDatasetPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% Split into training and validation sets
[imdsTrain, imdsValidation] = splitEachLabel(imds, 0.7, 'randomize');

% Define the layers of the CNN
layers = [
    imageInputLayer([28 28 1]) % input layer for grayscale images of size 28x28
    convolution2dLayer(5, 16, 'Padding', 'same') % convolution layer with 16 filters of size 5
    batchNormalizationLayer % normalization layer
    reluLayer % ReLU layer
    
    convolution2dLayer(8, 20, 'Padding', 'same') % additional convolution layer with 20 filters of size 8
    batchNormalizationLayer % another normalization layer
    leakyReluLayer % leaky ReLU layer
    
    fullyConnectedLayer(10) % fully connected layer with 10 neurons (for 10 digits)
    softmaxLayer % softmax layer for classification
    classificationLayer % classification layer
];

load net;
%options = trainingOptions('sgdm', ...
 %  'ExecutionEnvironment', 'parallel', ...
 %  'MaxEpochs', 100, ...
 % 'ValidationData', imdsValidation, ...
 % 'ValidationFrequency', 10, ...
 %  'Verbose', true, ...
   % 'Plots', 'training-progress');


%net = trainNetwork(imdsTrain, layers, options);

%save net;

% Create test imageDatastore (replace 'testImagesPath' with your test images path)
testImagesPath = '7v0';
imds_test = imageDatastore(testImagesPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% Apply transformation
preproc_imds_test = transform(imds_test, @preprocessData);


% Classify test images
predictedLabels = classify(net, preproc_imds_test);

% Optional: Display some results
figure;
for i = 1:min(5, numel(predictedLabels)) % Display the first 5 test images and their labels
    subplot(2,5,i);
    testImage = readimage(imds_test, i);
    imshow(testImage);
    title(['Test Image: ', num2str(i)]);

    subplot(2,5,i+5);
    title(['Predicted: ', char(predictedLabels(i))]);
end

figure;
for i = 6:min(12, numel(predictedLabels)) % Display test images 6 to 11 and their labels
    subplotIndex = i - 5;  % Adjust index for subplot

    % Display the test image
    subplot(2, 6, subplotIndex);
    testImage = readimage(imds_test, i);
    imshow(testImage);
    title(['Test Image: ', num2str(i)]);

    % Display the predicted label
    subplot(2, 6, subplotIndex + 6);
    title(['Predicted: ', char(predictedLabels(i))]);
end

function out = preprocessData(data)
    if ~iscell(data)
        data = {data};
    end

    out = cell(size(data));
    for i = 1:numel(data)
        img = data{i};
        if size(img, 3) == 3
            img = rgb2gray(img); % Convert to grayscale if RGB
        end

        % Binarize the image using a global threshold
        threshold = graythresh(img);
        img = imbinarize(img, threshold);

        % Invert the image if necessary to ensure the digit is white and the background is black

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
