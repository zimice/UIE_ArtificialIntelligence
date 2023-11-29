%% Cviko 4

A = imread('kytka256.jpg');
B = imread('grad.jpg');
imshow(A);


%%
kytka = imread('../imgs/kytka256.jpg');
gradient = imread('grad.jpg');
figure (1)
% Pruhlednost - Alfa kanál
subplot 221
alpha = 0.5;
combined_image = alpha * kytka + (1 - alpha) * gradient;
imshow (combined_image)
title('alpha = 50%');

subplot 222
alpha_2 = 1;
combined_image_2 = alpha_2 * kytka + (1 - alpha_2) * gradient;
imshow(combined_image_2)
title('alpha = 100%');

subplot 223
alpha_3 = 0;
combined_image_3 = alpha_3 * kytka + (1 - alpha_3) * gradient;
imshow(combined_image_3)
title ('alpha = 0%');
%%
x = linspace(0, 2*pi, 1000); 
y = sin(x);
figure; 
plot(x, y);

Y = fft(y);
amplitude = abs(Y / length(x));
amplitude = amplitude(1:length(x)/2);
frequencies = linspace(0, 1, length(x)/2) / (2*pi/mean(diff(x)));
figure;
plot(frequencies, amplitude);
grid on;
xlim([0 max(frequencies)/10]);

%%
clc
clear
img = imread('cor.jpg');
img = rgb2gray(img);
% Převést obrázek do frekvenční oblasti
img_fft = fft2(img);
img_fft_laf = log(abs(fftshift(img_fft)));
img_fft_shifted = fftshift(img_fft);
imshow(img_fft_laf)

%%


%%


img = imread('../imgs/kytka256.jpg')
img = rgb2gray(img)

subplot 331
imshow(img)
title('Puvodni obrazek v sedotonu')

subplot 332
spektrum_obr = fft2(img);
spektrum_obr_uprava = log(fftshift(abs(spektrum_obr)));
imshow(spektrum_obr_uprava, []);
title('spektrum puvodniho');

subplot 334
lp_mask = zeros(size(img));
lp_mask(size(lp_mask, 1)/2 - 20:size(lp_mask, 1)/2 + 20, size(lp_mask, 2)/2 - 20:size(lp_mask, 2)/2 + 20) = 1;
lp_masks = ifftshift(lp_mask);
lp_image = abs(ifft2(spektrum_obr .* lp_masks));
imshow(lp_image, [])
title('Obrázek po DP')

subplot 335
log_spectrum_lp = spektrum_obr_uprava .* lp_mask;
imshow(log_spectrum_lp, []);
title('Spektrum po DP')

subplot 336
imshow(lp_mask);
title('Maska DP');

subplot 337
hp_mask = ~lp_mask;
hp_masks = ifftshift(hp_mask);
hp_image = abs(ifft2(spektrum_obr .* hp_masks));
imshow(hp_image, []);
title('Obrázek po HP');

subplot 338
log_spectrum_hp = spektrum_obr_uprava .* hp_mask;
imshow(log_spectrum_hp, []);
title('Spektrum po HP');

subplot 339
imshow(hp_mask);
title('Maska HP');