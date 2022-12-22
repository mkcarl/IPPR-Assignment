clc; clear all; close all; 

img = imread('images/stain_4.jpg');
img = imresize(img, 0.2);

[H,S,V]  = rgb2hsv(img);
H = imgaussfilt(H, 3);
S = imgaussfilt(S, 3);

h_thresh = H >= 0.014 & H < 224;
s_thresh = S >= 0.39;
v_thresh = V >= 0.4;

thresh1 = h_thresh & s_thresh & v_thresh;
figure; imshow(thresh1);

img_fill = imfill(thresh1, "holes");
figure;imshow(img_fill);

SE1 = strel('disk', 5);
img_morphology = imopen(img_fill, SE1);
img_morphology = imdilate(img_morphology, SE1);
% img_morphology = imdilate(img_morphology, SE1);
figure; imshow(img_morphology);

% draw perimeter
figure("Name", "Perimeter");
perim = bwperim(img_morphology);
perim = cat(3, perim, perim, perim);
imshow(imadd(img, uint8(perim * 255)));

% showing the bounding boxes
figure("Name", "Bounding box");
imshow(img);
[L, n] = bwlabel(img_morphology);
stain = regionprops(L);
stain_box = [stain.BoundingBox];
stain_box = reshape(stain_box, [4 n]);

for c = 1:n
    rectangle('position', stain_box(:, c), 'EdgeColor','r');
end


