addpath('imgs\');
A = imread("kytka256.jpg");
Ag = rgb2gray(A);
th = graythresh(Ag);
%Th = multithresh(Ag,N);
Ab = imbinarize(Ag,th);
imshow(Ab);
%%
for i = 1:1:10
indx=kmeans(double(Ag(:)),i); %shlukovaci algoritmus
Ar=reshape(indx, size(Ag));
imshow(Ar, []);
pause(0.1)
end
%%
Ah=rgb2hsv(A);
%subplot 131
imshow(Ah(:,:,1));
% subplot 132
% imshow(Ah(:,:,2));
% subplot 133
% imshow(Ah(:,:,3));
%%
A2=A;
H = Ah(:,:,1);
th2= graythresh(double(H));
Hb = imbinarize(H,th2);
Hb3=cat(3,Hb,Hb,Hb);
Ag3=cat(3,Ag,Ag,Ag);
A2(Hb3)=Ag3(Hb3);
imshow(A2);
%%
%colorThresholder
I=imread("cell.tif");

%Hrany
I_edge = edge(I, 'sobel',0.03);

% Dilatace 
se = strel('disk', 2); 
I_dilated = imdilate(I_edge, se);

% Vyplnění
I_filled = imfill(I_dilated, 'holes');

% Odstranění hran
I_clear_border = imclearborder(I_filled);

% Eroze binárního obrázku
se = strel('disk', 1); 
I_eroded = imerode(I_clear_border, se);

% Získání hran binárního obrázku
I_perim = bwperim(I_eroded);

% Výsledky
subplot(3, 2, 1), imshow(I), title('Původní obrázek');
subplot(3, 2, 2), imshow(I_edge), title('Detekce hran');
subplot(3, 2, 3), imshow(I_dilated), title('Dilatace');
subplot(3, 2, 4), imshow(I_filled), title('Vyplnění');
subplot(3, 2, 5), imshow(I_clear_border), title('Odstranění okrajů');
subplot(3, 2, 6), imshow(I_eroded), title('Eroze');

