resultsFolder = 'cvt04_du_vysledky/kochasim';
if ~exist(resultsFolder, 'dir')
    mkdir(resultsFolder);
end

img = imread('kytka256.jpg');
img = rgb2gray(img);
img_fft = fft2(img);
img_fft_laf = log(abs(fftshift(img_fft)));
img_fft_shifted = fftshift(img_fft);

[M, N] = size(img);

for i = 1:100

    maskW = randi([30, min(M, N) / 4]);
    maskH = randi([30, min(M, N) / 4]);
    maskX = randi([1, N - maskW + 1]);
    maskY = randi([1, M - maskH + 1]);
    mask = ones(M, N);
    mask = ifftshift(mask);
    mask(maskY:maskY + maskH - 1, maskX:maskX + maskW - 1) = 0;
    
    img_fft_a = img_fft_laf .* mask;
    img_fft_b = img_fft_shifted .* mask;

    img_filtered = ifft2(img_fft_b);
    iStr = sprintf('%02d', i-1);
    imgFileName = fullfile(resultsFolder, ['img_' iStr '.jpg']);
    maskFileName = fullfile(resultsFolder, ['img_' iStr '_maska.png']);
    imwrite(uint8(abs(img_filtered)), imgFileName);
    img_fft_normalized = mat2gray(img_fft_a);
    imwrite(img_fft_normalized, maskFileName);
end
