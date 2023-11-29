%% Cviko 6

A = imread('tvary.png');
A = im2gray(A);
Ab = imbinarize(A,'adaptive','ForegroundPolarity','dark','Sensitivity',0.55);


Ab = ~Ab

filledImage = imfill(Ab, 'holes');
cleanedImage = imclearborder(filledImage);


imshow(cleanedImage);

%%

B  = cleanedImage;

B = bwareafilt(B,16);

imshowpair(cleanedImage,B,'montage')

%%



props = regionprops(cleanedImage, 'Area', 'Solidity', 'Eccentricity');
h  = histogram([props.Area]);


%% odfiltrovat nekolecka

C = B;

Clb = bwlabel(C);
props = regionprops(C, 'Circularity');

[props.Circularity] > 0.9
kdeKolecka = find([props.Circularity] > 0.9);

E= label2rgb(Clb);

F = ismember(Clb,kdeKolecka)    

imshow(F);


%%

