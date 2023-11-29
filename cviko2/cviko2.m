%% Rozcvička

A = imread('image.jpg');

%% Zvýšení brightness
B = A +90; 
imshow(B);

%% Zmena velikosti obrazku

C = imresize(A,0.25);
imshow(C);

%% Ukazat histogram 

imhist(A);

%% Vymaz casti
D = A;
for i = 600:900
    for j = 900:1200
    D(i,j,1) = 0;
    D(i,j,2) = 0;
    D(i,j,3) = 0;
    end
end 

Av = A;
Av(100:150,90:120,:) = 0;
imshow(Av);
imshow(D);

%% Barevny pruh


%Ag3 = cat(3, A,A,A);
Ag3 = repmat(Ag,[1,1,3]);
Ag3 (50:80,:,:)  = A(50:80,:,:) 
imshow(Ag3);

%% opakujici se vzor 



%% Konec rozcvicky

%% HISTOGRAM

Ag = rgb2gray(A);
B = uint8([255 64; 0 255]);

imshow(B, InitialMagnification=20000);

inhist(Ag);

%% Vykresleni histogramu sedotonoveho obrazku

Ag = rgb2gray(A);

imhist(A);

%% Vykresleni barevnych kanalu na histogramu

R=imhist(A(:,:,1));
G=imhist(A(:,:,2));
B=imhist(A(:,:,3));

plot(R,'r','LineWidth',2)

hold on
plot(G,'g','LineWidth',2)
plot(B,'b','LineWidth',2)
hold off  

%% 

A3g = reshape(A,[256,256*3]);
imshow(A3g)
imhist(A3g)

%%



%% Ekvalizace Histogramu
A = imread('tire.tif')
%A = imread('pout.tif');
subplot 221
imshow(A);
subplot 222
imhist(A);
J = histeq(A);
subplot 223
imshow(J);
subplot 224
imhist(J);

%%

A = imread('pout.tif');

[Ahq, T] = histeq(A);

imshow(Ahq);
imhist(Ahq);
plot(linspace(0,1,256),T);
%%
A = imread("rtg.jpg");

%% 
A = imread("rtg.jpg");
A = rgb2gray(A);
imshow(A);
while true
    [y,x] = ginput(1);
A = imread("rtg.jpg");

A = rgb2gray(A);
imshow(A);



hold on;
B = histeq(A);

q= 400/2

A(x-q:x+q,y-q:y+q) = B(x-q:x+q,y-q:y+q);

imshow(A);



end


