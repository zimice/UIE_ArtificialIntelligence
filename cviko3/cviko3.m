%% Cviko 3

v = randi(100,9,1)
J = [1/3 1/3 1/3];
a= conv(v,J);

%%
M = [10 20 30; 40 50 60; 70 80 90;]
J = [1/4 1/4 ; 1/4 1/4]
a= conv2(M, J, "valid");
%%

A = imread('image.jpg');
A = rgb2gray(A);

A(700:750,500:550) = 0;

J = [1/4 1/4; 1/4 1/4]

A= conv2(A,J, "valid");

imshow(A);
%%

A = imread('image.jpg');
A = rgb2gray(A);
Anoise =imnoise(A,'gaussian');

AGaus = imgaussfilt(Anoise,2);

AW = wiener2(Anoise,[5 5]);
AW = imgaussfilt(AW,2);

subplot(2,2,1), imshow(A); title('Original Image');
subplot(2,2,2), imshow(Anoise); title('Noise Image');
subplot(2,2,3), imshow(AGaus); title('Gauss Image');
subplot(2,2,4), imshow(AW); title('Wiener Image');

%%

A = imread('image.jpg');
A = rgb2gray(A);


A= conv2(A,J, "valid");

imshow(A);