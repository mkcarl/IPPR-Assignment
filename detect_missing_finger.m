clc; clear all; close all; 

% read image
img = imread('images/missing_finger_1.jpg');
img_resized = imresize(img, 0.2);

% show image in h s and v
[H,S,V] = rgb2hsv(img_resized);
figure("Name","HSV");
subplot(131); imshow(H); title("Hue");
subplot(132); imshow(S); title("Saturation");
subplot(133); imshow(V); title("Value");

% apply gauss on S 
s_gauss = imgaussfilt(S, 10);


% threshold image in hsv 
h_thresh = H >= 0.879 | H < 0.088;
s_thresh = s_gauss >= 0.272;

thresh1 = h_thresh & s_thresh;
figure("Name","Threshold");
subplot(121); imshow(s_gauss); title("smoothed S");
subplot(122); imshow(thresh1); title("Threshold");

% fill arm hole
img_fill = imclearborder(thresh1);
figure("Name","Fill");
subplot(121); imshow(thresh1); title("Threshold");
subplot(122); imshow(img_fill); title("Clear border");


% apply opening 
SE1 = strel('disk', 10);
img_open = imopen(img_fill, SE1);
img_dilated = imdilate(img_open, SE1);
% img_dilated = imdilate(img_dilated, SE1);
figure("Name","Opening");
subplot(121); imshow(img_open); title("Opening");
subplot(122); imshow(img_dilated); title("Dilated");

% show boundary on image
SE2 = strel('disk', 3);
figure("Name","Boundary");
perim = bwperim(img_dilated);
perim = imdilate(perim, SE2);
perim = cat(3, perim, perim, perim);
imshow(imadd(img_resized, uint8(perim * 255)));

% show bounding box 
[L, num] = bwlabel(img_open);
stats = regionprops(L, 'BoundingBox');
figure("Name","Bounding box");
imshow(img_resized);
hold on;
for i = 1:num
    rectangle('Position', stats(i).BoundingBox, 'EdgeColor', 'r');
end
hold off;
