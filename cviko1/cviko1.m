A = imread('image.jpg');

R = A(:,:,1);
B = A(:,:,2);
G = A(:,:,3);

%%

B = zeros (256,256,3)* 0.8;
 imshow(B);

%%
%{
R = A(:,:,1);
B = A(:,:,2);
G = A(:,:,3);

subplot 221
imshow(A);
subplot 222
imshow(R);


subplot 223;

imshow(B);
subplot 224;kocha

imshow(G)

%}

%{
allBlack = zeros(size(A, 1), size(A, 2), 'uint8');

R = cat(3, A(:,:,1), allBlack, allBlack);
G = cat(3, allBlack, A(:,:,2), allBlack);
B = cat(3, allBlack, allBlack, A(:,:,3));

subplot 221
imshow(A);
title("Original");
subplot 222
imshow(R);
title("Red");

subplot 223;

imshow(B);
title("Blue");
subplot 224;

imshow(G)
title("Green");

%}
%% Falesne barvy pana Tesare
Z = zeros(size(A));

RR = cat(3,R,Z,Z)
imshow(RR);

GG = A;
GG(:,:,[1,3]) = 0;
imshow(GG)

BB = A;
BB(1:end,:,1:2) = 0;
imshow(BB);

%%

Ag = rgb2gray(A);
imshow(Ag);

%%
Ag_mean = mean(A,3);
subplot 122
imshow(Ag_mean);
%%
for v = 0.0:0.1:1.0
    Ab = imbinarize(Ag, v);
    imshow(Ab);
    pause(0.2);
end


%%
