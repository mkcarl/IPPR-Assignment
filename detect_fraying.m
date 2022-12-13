clc; clear all; close all; 

img = imread('images/fraying_1.jpg');

figure("Name","RGB color space");
subplot(131); imshow(img(:,:,1)); title("R");
subplot(132); imshow(img(:,:,2)); title("G");
subplot(133); imshow(img(:,:,3)); title("B");

figure("Name", "YCbCr color space");
img_ycbcr = rgb2ycbcr(img);
subplot(131); imshow(img_ycbcr(:,:,1)); title("Y");
subplot(132); imshow(img_ycbcr(:,:,2)); title("Cb");
subplot(133); imshow(img_ycbcr(:,:,3)); title("Cr");


figure("Name", "the chosen one");
img_glove = histeq(img_ycbcr(:,:,3));
imshow(img_glove);

% img_gauss = imgaussfilt(img_glove, 30);
% figure("Name","smoothing");
% subplot(121);imshow(img_glove);
% subplot(122); imshow(img_glove);

% threshing it
figure('Name','histogram');
subplot(1,2,1); plot(imhist(img_glove));
thresh = img_glove > 170;
subplot(1,2,2); imshow(thresh);

% morphology 
subplot(231);imshow(thresh);title("original");

SE1 = strel('disk', 7);
SE2 = strel('diamond', 7);
img_fill = imfill(thresh, 'holes');
subplot(232); imshow(img_fill); title("filling");
img_open = imopen(img_fill, SE2);
subplot(233); imshow(img_open); title("opening");
img_close = imclose(img_open, SE2);
subplot(234); imshow(img_close); title("closing");
img_erode = imerode(img_close, SE2);
subplot(235); imshow(img_erode); title("eroding");
img_dilate = imdilate(img_erode, SE2);
subplot(236); imshow(img_dilate); title("dilating");

figure;
bw = imdilate(thresh, SE1);
bw = imdilate(bw, SE1);
bw = imdilate(bw, SE1);
bw = imfill(bw, "holes");
perim = bwperim(bw, 8);
perim = cat(3, uint8(perim)*255, uint8(perim)*255, uint8(perim)*255);
final = imadd(img, perim);
imshow(final);






