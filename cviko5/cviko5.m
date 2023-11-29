img = imread("kytka256.jpg");
img_gray = rgb2gray(img);

thresh = graythresh(img_gray);
img_bin = imbinarize(img_gray,thresh);
imshow(img_bin)

%% Rozdělení a 6 barevných shluků
close all;
double_img = double(img_gray);
indx = kmeans(double_img(:),6);
a = reshape(indx,size(img_gray));
imshow(a,[]);
%% Spojení barevné kytky a černobíleho pozadí
close all;
thresh = graythresh(img);
hsv_img = rgb2hsv(img);
hsv1 = hsv_img(:,:,1);
maska1 = imbinarize(hsv1,thresh);
maska2 = ~maska1;
maska1= uint8(maska1);
maska2 = uint8(maska2);
kytka = img .* maska2;
pozadi = img_gray .* maska1;


d = kytka + pozadi;

imshow(d);

%% Ukázka práce s vektory
v = [10 20 30 40 50];
v(4)
v(logical([0 0 1 1 0]))

%% Možnosti jak pracovat s obrázkem
colorThresholder
%% Segmentace pomocí hran
close all;

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

b = imoverlay(cell, cell_bwperim, [1 0 0]);
imshow(b);

%% Hledání silnice
close all;
auto = imread("img/zauta.jpg");
thresh = 0.8;

Gauto = rgb2gray(auto);
BGauto = imbinarize(Gauto, thresh);

bwauto = bwareaopen(BGauto, 1000);

clearauto = imclearborder(bwauto);

% Použijte regionprops k analýze oblastí na binárním obrazu.
stats = regionprops(clearauto, 'Eccentricity');

% Inicializujte proměnné pro nejvyšší "kolečkovost" a index největšího regionu.
max_eccentricity = -1; % Inicializujte na nízkou hodnotu
max_index = -1;

% Projděte všechny regiony a najděte ten s největší "kolečkovostí".
for i = 1:length(stats)
    if stats(i).Eccentricity > max_eccentricity
        max_eccentricity = stats(i).Eccentricity;
        max_index = i;
    end
end

if max_index ~= -1
    % Nalezení regionu s největší "kolečkovostí.
    disp('Největší "kolečkovost" nalezena:');
    disp(max_eccentricity);
    
    % Vytvořte nový binární obraz s pouze největším regionem.
    largest_region = zeros(size(clearauto));
    largest_region(bwlabel(clearauto) == max_index) = 1;
    
    % Zobrazte pouze největší region.
    figure;
    %imshow(largest_region);
else
    disp('Nenalezena žádná oblast s "kolečkovostí".');
end
colorauto = label2rgb(largest_region);

largest_region = imbinarize(largest_region);
maska = ~largest_region;

pozadi = Gauto .* uint8(maska);
cara = colorauto .* uint8(largest_region);

konecny = pozadi + cara;
imshow(konecny)