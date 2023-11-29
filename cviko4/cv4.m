% Vytvořit složku pro výsledky, pokud neexistuje
resultsFolder = 'cvt04_du_vysledky/kochasim';
if ~exist(resultsFolder, 'dir')
    mkdir(resultsFolder);
end

% Načíst obrázek
img = imread('../imgs/kytka256.jpg');
img = rgb2gray(img);
% Převést obrázek do frekvenční oblasti
img_fft = fft2(img);
img_fft_laf = log(abs(fftshift(img_fft)));
img_fft_shifted = fftshift(img_fft);
%imshow(img_fft_shifted, []);

% Velikost obrázku
[M, N] = size(img);

% Počet iterací
numIterations = 100;

for i = 1:numIterations
    % Náhodně vygenerovat masku (obdélník)
    maskWidth = randi([30, min(M, N) / 4]);
    maskHeight = randi([30, min(M, N) / 4]);
    maskX = randi([1, N - maskWidth + 1]);
    maskY = randi([1, M - maskHeight + 1]);
    mask = ones(M, N);
    mask = ifftshift(mask);
    mask(maskY:maskY + maskHeight - 1, maskX:maskX + maskWidth - 1) = 0;
    
    % Aplikovat masku na frekvenční spektrum
    img_fft_a = img_fft_laf .* mask;
    img_fft_b = img_fft_shifted .* mask;
    % Převést zpět do prostoru
    img_filtered = ifft2(img_fft_b);
    
    % %kontrola
    % figure
    % subplot 121
    % imshow(img_fft_a,[]);
    % subplot 122
    % imshow(abs(img_filtered),[]);

    % Uložit výsledky
    iterationStr = sprintf('%02d', i-1);
    imgFileName = fullfile(resultsFolder, ['img_' iterationStr '.jpg']);
    maskFileName = fullfile(resultsFolder, ['img_' iterationStr '_maska.png']);

    % Uložit obrázek a masku
    imwrite(uint8(abs(img_filtered)), imgFileName);
    % Normalizovat spektrum pro zobrazení
    img_fft_normalized = mat2gray(img_fft_a);
    imwrite(img_fft_normalized, maskFileName);
end
