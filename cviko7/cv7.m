%% Cviko 7

A=dicomread('ctslice.dcm');

imshow(A,[]);


B = dicomread('slice2.dcm');
info = dicominfo('slice2.dcm');

% Extract the study date and time
studyDate = info.StudyDate;
studyTime = info.StudyTime;

% Display the date and time
fprintf('Study Date: %s\n', studyDate);
fprintf('Study Time: %s\n', studyTime);
imshow(B);

%%

A = dicomread('MR-MONO2-8-16x-heart')
A = squeeze(A);
%% Aktivni kontury pro segmentaci
A=dicomread('ctslice.dcm');
A = mat2gray(A);
imshow(A, []);
mask = roipoly

figure, imshow(mask);


maxIter = 500;

bw= activecontour(A,mask,maxIter,'Chan-vese')


bw = imfill(bw,'holes');

figure

A(bw) = 1
imshow(A,[])


%% 

load mri.mat


%montage(D3)

size(D);

D = squeeze(D);

%D = mat2gray(D);

D = ind2gray(D,map);
D3 = squeeze(ind2gray(D,map));

rez = squeeze( D3(:,60,:));
imshow(rez);

%%
clear
close all;
load mri.mat
D = ind2gray(D,map);
D = squeeze(D);
subplot 131; imshow(D(:,:,3));
a = squeeze(D(:,50,:));
a = imresize(a,[128,128]);
subplot 132; imshow(a);
b = squeeze(D(40,:,:)); 
b = imresize(b,[128,128]);
subplot 133; imshow(b)
