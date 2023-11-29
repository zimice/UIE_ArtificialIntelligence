%% Segmentace kytky

A = imread('kytka256.jpg');
Ag = rgb2gray(A);

th = graythresh(Ag);

B = imbinarize(Ag, th);
imshow(B);

%% 
close all;
double_img = double(Ag);
indx = kmeans(double_img(:),6);
a = reshape(indx,size(Ag));
imshow(a,[]);

%% Spojení barevné kytky a černobíleho pozadí

close all;
thresh = graythresh(A);
hsv_img = rgb2hsv(A);
hsv1 = hsv_img(:,:,1);
maska1 = imbinarize(hsv1,thresh);
maska2 = ~maska1;
maska1= uint8(maska1);
maska2 = uint8(maska2);
kytka = A .* maska2;
pozadi = Ag .* maska1;

d = kytka + pozadi;

imshow(d);


%% Segmentace pomocí hran


cell = imread("cell.tif");
thresh = 0.03;
cell_edge = edge(cell,"sobel",thresh);

se = strel("disk",2);
cell_imdilate = imdilate(cell_edge,se);
cell_fill = imfill(cell_imdilate,"holes");

cell_cler = imclearborder(cell_fill);

cell_imerode = imerode(cell_cler,se);

cell_bwperim = bwperim(cell_imerode);
stats = regionprops(cell_imerode, 'Area');
velikost_objektu = stats(1).Area; 
disp(['Velikost objektu: ' num2str(velikost_objektu)])

imshow(cell_bwperim)