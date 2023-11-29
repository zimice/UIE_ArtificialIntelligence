close all
% Vektor o 10 prvcích (pseudo náhodná čísla od 1-10)
vektor = randi([1, 10], 1, 10);

% Konvoluce pomocí klouzavého průměru o velikosti 3
rozostreny_vektor = conv(vektor, ones(1, 3) / 3, 'same');

% Vytvořte subplot s jedním řádkem a dvěma sloupci pro vektory
subplot(2,2,[1,2]);
plot(vektor, 'b');
hold on;
plot(rozostreny_vektor, 'g');
legend('Původní', 'Filtrovaný');
title('Graf původního a filtrovaného vektoru');

% Nahrání obrázku a aplikace konvoluce
addpath('imgs\');
A = imread('kytka256.jpg');
A = rgb2gray(A);

% Vytvořte subplot s dvěma řádky a jedním sloupcem pro obrazy
subplot(2,2,3);
imshow(A);
title('Původní obrázek');

subplot(2,2,4);
B = conv2(double(A), ones(1, 3) / 3, 'same');
imshow(uint8(B));
title('Filtrovaný obrázek');
%%
% Vytvoření původního signálu (příklad)
signal = rand(1, 10);

% Velikost výseku pro průměrování
velikost_vyseku = 3;

% Vytvoření masky pro průměrování
maska = ones(1, velikost_vyseku) / velikost_vyseku;

% Inicializace filtrovaného signálu
filtrovany_signal = zeros(size(signal));

% Procházení signálu a aplikace průměrovacího filtru
for i = 1:length(signal)
    if i + velikost_vyseku - 1 <= length(signal)
        vysek = signal(i:i+velikost_vyseku-1);
        filtrovany_signal(i) = sum(vysek .* maska);
    end
end

% Použijte funkci conv pro stejný výsledek
filtrovany_signal_conv = conv(signal, maska, 'same');

% Výsledky
subplot(2,1,1);
plot(signal, 'b');
title('Původní signál');

subplot(2,1,2);
plot(filtrovany_signal, 'g');
title('Filtrovaný signál (průměrovacím filtrem)');

% Porovnání s výsledkem z funkce conv
figure;
subplot(2,1,1);
plot(signal, 'b');
title('Původní signál');

subplot(2,1,2);
plot(filtrovany_signal_conv, 'r');
title('Filtrovaný signál (conv)');
%%
M = [10 20 30;
     40 50 60;
     70 80 90];
J= [0.25 0.25;
    0.25 0.25];
C=conv2(M,J,'valid');
plot(C);
%%
close all;
% Načtení obrázku
A = imread('kytka256.jpg');
A = rgb2gray(A);

% Přidání Gaussovského šumu
snr = 70; % Poměr signál/šum (Signal-to-Noise Ratio)
zasumeny_obrazek = imnoise(A, 'gaussian', 0, (1 / snr));

% Vytvoření Gaussovkého filtru
sigma = 1; % Smoothing faktor pro Gaussovský filtr
velikost_masky = 3; % Velikost masky (např. 3x3)
maska_gauss = fspecial('gaussian', [velikost_masky, velikost_masky], sigma);

% Filtrování zašuměného obrázku Gaussovským filtrem
filtrovany_obrazek_gauss = conv2(double(zasumeny_obrazek), maska_gauss, 'same');

% Filtrování zašuměného obrázku Wienerovým filtrem
filtrovany_obrazek_wiener = deconvwnr(zasumeny_obrazek, maska_gauss, 0.2);

% Zobrazení původního, zašuměného, filtrovaného Gaussovským a filtrovaného Wienerovým filtrem obrázku vedle sebe
subplot(2, 2, 1);
imshow(A);
title('Původní obrázek');

subplot(2, 2, 2);
imshow(zasumeny_obrazek);
title('Zašuměný obrázek');

subplot(2, 2, 3);
imshow(uint8(filtrovany_obrazek_gauss));
title('Filtrovaný Gaussovským filtrem');

subplot(2, 2, 4);
imshow(uint8(filtrovany_obrazek_wiener));
title('Filtrovaný Wienerovým filtrem');

%%
close all
% Načtení obrázku
A = imread('kytka256.jpg');
A = rgb2gray(A);

% Detekce oblasti s kytkou - jednoduchý prahovací algoritmus
threshold = 100; % Práh pro detekci kytky
maska_kytka = A > threshold;

% Rozmazání části obrázku mimo kytky
rozmazana_oblast = imgaussfilt(A, 5); % Rozmaže nekytkovou část

% Nahrazení části původního obrázku rozmaženou oblastí
vysledny_obrazek = A;
vysledny_obrazek(~maska_kytka) = rozmazana_oblast(~maska_kytka);

% Zobrazení původního a upraveného obrázku vedle sebe
subplot(1, 2, 1);
imshow(A);
title('Původní obrázek');

subplot(1, 2, 2);
imshow(vysledny_obrazek);
title('Upravený obrázek');
%%
% Název videa
videoFile = 'podzimni_kvetena_focus_test.mp4';

% Inicializace VideoReader
videoObj = VideoReader(videoFile);

% Inicializace proměnných pro nejostřejší snímek a jeho ostrost
nejostrejsi_snimek = [];
nejvyssi_ostrost = 0;

% Náhled videa a hledání nejostřejšího snímku
while hasFrame(videoObj)
    % Načtení snímku
    snimek = readFrame(videoObj);
    
    % Převod snímku na černobílý
    snimek = rgb2gray(snimek);
    
    % Detekce hran v obraze
    hrany = edge(snimek, 'Canny');
    
    % Výpočet sumy hodnot v obraze (ostrost)
    ostrost = sum(hrany(:));
    
    % Pokud je tato ostrost větší než dosud nalezená nejvyšší ostrost
    if ostrost > nejvyssi_ostrost
        nejvyssi_ostrost = ostrost;
        nejostrejsi_snimek = snimek;
    end
end

% Zobrazení nejostřejšího snímku
imshow(nejostrejsi_snimek);
title('Nejostřejší snímek');

% Možná můžete také uložit nejostřejší snímek do souboru:
% imwrite(nejostrejsi_snimek, 'nejostrejsi_snimek.jpg');
%%
% Název videa
videoFile = 'podzimni_kvetena_focus_test.mp4';

% Inicializace VideoReader
videoObj = VideoReader(videoFile);

% Inicializace proměnných pro nejostřejší snímek, jeho ostrost a pozici
nejostrejsi_snimek = [];
nejvyssi_ostrost = 0;
velikost_snimku = [50, 50]; % Velikost snímku, který budeme zkoumat

% Náhled videa a hledání nejostřejšího snímku uprostřed obrazu
while hasFrame(videoObj)
    % Načtení snímku
    snimek = readFrame(videoObj);
    
    % Převod snímku na černobílý
    snimek = rgb2gray(snimek);
    
    % Získání části snímku uprostřed obrazu
    [vyska, sirka] = size(snimek);
    radek_start = floor((vyska - velikost_snimku(1)) / 2) + 1;
    radek_konec = radek_start + velikost_snimku(1) - 1;
    sloupec_start = floor((sirka - velikost_snimku(2)) / 2) + 1;
    sloupec_konec = sloupec_start + velikost_snimku(2) - 1;
    
    cast_snimku = snimek(radek_start:radek_konec, sloupec_start:sloupec_konec);
    
    % Detekce hran v této části
    hrany = edge(cast_snimku, 'Canny');
    
    % Výpočet sumy hodnot v obraze (ostrost)
    ostrost = sum(hrany(:));
    
    % Pokud je tato ostrost větší než dosud nalezená nejvyšší ostrost
    if ostrost > nejvyssi_ostrost
        nejvyssi_ostrost = ostrost;
        nejostrejsi_snimek = snimek;
    end
end

% Zobrazení nejostřejšího snímku
imshow(nejostrejsi_snimek);
title('Nejostřejší snímek uprostřed obrazu');

% Možná můžete také uložit nejostřejší snímek do souboru:
% imwrite(nejostrejsi_snimek, 'nejostrejsi_snimek.jpg');
