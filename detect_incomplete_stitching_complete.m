clc; clear all; close all; 

img = imread("images/incomplete_stitching_2.jpg");

% resize image 
img = imresize(img, 0.15);
img_gray = rgb2gray(img);
figure("Name", "Original Image");
imshow(img_gray);

% apply power law transform
% using c = 6 
img_power = imadjust(img_gray, [], [], 6);
img_gauss = imgaussfilt(img_power, 1);
img_thresh = img_gauss > 80;

figure("Name", "Power Law Transform");
subplot(131); imshow(img_power); title("Power Law Transform");
subplot(132); imshow(img_gauss); title("Gaussian Filter");
subplot(133); imshow(img_thresh); title("Thresholding");

% apply morphological operations
img_clean = bwmorph(img_thresh, "clean");
img_bridged = bwmorph(img_clean, "bridge");

SE1 = strel('square',2);
SE2 = strel('diamond',4);

img_opened = imopen(img_bridged, SE1);
defective_area = imdilate(img_opened, SE2);
defective_area = imdilate(defective_area, SE2);
defective_area = imdilate(defective_area, SE2);

figure("Name", "Defective Area");
subplot(221); imshow(img_clean); title("Clean");
subplot(222); imshow(img_bridged); title("Bridge");
subplot(223); imshow(img_opened); title("Opened");
subplot(224); imshow(defective_area); title("Apply dilation");

% show bounding box 
figure("Name", "Bounding Box");
imshow(img);
hold on;
stats = regionprops(defective_area, 'BoundingBox');
for i = 1:length(stats)
    rectangle('Position', stats(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
end
