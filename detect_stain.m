clc; clear all; close all; 

img = imread('images/stain_4.jpg');

% converting to HSV colorspace 
[H,S,V] = rgb2hsv(img);
figure("Name", 'hsv display');
subplot(1,3,1); imshow(H);
subplot(1,3,2); imshow(S);
subplot(1,3,3); imshow(V);


% selecting the orange color of ketchup
figure("Name", 'thresholding');
s_bw = S > 0.5;
s_bw = uint8(s_bw*255);
subplot(1,2,1); imshow(s_bw); title('S');
h_bw = H < 0.5;
h_bw = uint8(h_bw*255);
subplot(1,2,2); imshow(h_bw); title('H');

% smooth it 
figure("Name", 'smoothing');
subplot(2,2,1); imshow(s_bw); title('original S');
s_smooth = imgaussfilt(s_bw, 25);
subplot(2,2,2); imshow(s_smooth); title('smoothed S');

subplot(2,2,3); imshow(h_bw); title('original H');
h_smooth = imgaussfilt(h_bw, 25);
subplot(2,2,4); imshow(h_smooth); title('smoothed H');

% finding intersection
figure("Name", 'intersection');
bw = h_bw & s_bw;
imshow(bw); title('intersection');


% perform morphology 
figure("Name", 'morphology');
SE1 = strel("diamond",5);
bw2 = imopen(bw, SE1);
SE2 = strel("disk", 3);
bw2 = imdilate(bw2, SE2);
bw2 = imfill(bw2, "holes");
% bw2 = imdilate(bw2, SE1);
imshow(bw2);

% outline
figure("Name", 'Final segmentation');
outline = bwperim(bw2,8);
SE3 = strel('square',8);
outline = imdilate(outline, SE3);
outline3d = cat(3, outline, outline, outline);
segmentation = imsubtract(img, uint8(outline3d*255));
segmentation(:,:,3) = imadd(segmentation(:,:,3), uint8(outline*255));
imshow(segmentation);


