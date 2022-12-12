clc; clear all; close all; 

img = imread("images/incomplete_stitching_2.jpg");

% resize image 
img = imresize(img, 0.15);


img_gray = rgb2gray(img);

% show image gradient
figure("Name", "Image Gradient");
[Gmag, Gdir] = imgradient(img_gray);
Gmag = uint8(Gmag);
subplot(121);imshow(img_gray);title("Original Image");
subplot(122);imshow(Gmag);title("Image Gradient");

% power law transform
power1 = imadjust(img_gray, [], [], 0.5);
power2 = imadjust(img_gray, [], [], 2);
power3 = imadjust(img_gray, [], [], 6);

figure("Name", "Power Law Transform");
subplot(231);imshow(img_gray);title("Original Image");
subplot(232);imshow(power1);title("Power Law Transform (gamma = 0.5)");
subplot(233);imshow(power2);title("Power Law Transform (gamma = 2)");
subplot(234);imshow(power3);title("Power Law Transform (gamma = 6)");
thresh1 = imgaussfilt(power3,1) > 80;
subplot(235);imshow(thresh1); title("Gauss-thresh");
thresh2 = bwmorph(thresh1, 'clean');
SE1 = strel('square', 2);
SE2 = strel('diamond', 4);
thresh3 = bwmorph(thresh2, 'bridge');
thresh3 = imopen(thresh3,SE1);
thresh3 = imdilate(thresh3, SE2);
thresh3 = imdilate(thresh3, SE2);
thresh3 = imdilate(thresh3, SE2);
subplot(236);imshow(thresh3); title("Bridge");


% log transform
log1 = 0.5 * log10(1+double(img_gray)/255);
log2 = 2 * log10(1+double(img_gray)/255);
log3 = 5 * log10(1+double(img_gray)/255);

figure("Name", "Log Transform");
subplot(231);imshow(img_gray);title("Original Image");
subplot(232);imshow(log1);title("Log Transform (c = 0.5)");
subplot(233);imshow(log2);title("Log Transform (c = 2)");
subplot(234);imshow(log3);title("Log Transform (c = 5)");
log_gauss = imgaussfilt(log3, 2);
thresh_log_gauss = log_gauss < 0.6;
subplot(235);imshow(log_gauss); title("Threshold");
subplot(236);imshow(thresh_log_gauss); title("Gaussian Filter");

% show bounding box 
figure("Name", "Bounding Box");
imshow(img);
hold on;
stats = regionprops(thresh3, 'BoundingBox');
for i = 1:length(stats)
    rectangle('Position', stats(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
end

