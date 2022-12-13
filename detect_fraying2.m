clc; clear all; close all; 

img = imread('images/fraying_2.jpg');
img = imresize(img, 0.2);
img_gray = rgb2gray(img);
% img_gauss = imgaussfilt(img_gray, 5);
% figure("Name","smoothing");
% subplot(121);imshow(img_gray);
% subplot(122); imshow(img_gauss);

% detect edges using canny
% img_edge = edge(img_gray, 'canny');
% figure("Name","edge detection");
% imshow(img_edge);

img_hp = ideal_filter(img_gray, 20, 'high');
img_hp = mat2gray(abs(img_hp));
figure("Name","high pass filtering");
imshow(img_hp,[]);

thresh1 = imgaussfilt(img_hp, 3);
thresh1 = thresh1 > 0.5;
figure; imshow(thresh1)

% % smoothing again 
% img_smooth = imgaussfilt(img_hp,15);
% figure("Name","smoothing");
% % median filtering
% img_smooth = medfilt2(img_smooth, [5 5]);
% imshow(img_smooth,[]);
% mean filtering 
mean_kernal = fspecial('average', 5);
img_smooth = imfilter(img_hp, mean_kernal);

% apply canny edge detection
img_edge = edge(img_hp, 'canny');
figure("Name","edge detection");
imshow(img_edge);
 
% thicken the line 
SE1 = strel('diamond', 3);
img_thick = imdilate(img_edge, SE1);
figure;
imshow(img_thick);