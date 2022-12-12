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
SE2 = strel('square', 4);
thresh3 = bwmorph(thresh2, 'bridge');
thresh3 = imopen(thresh3,SE1);
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



% remove noise using mean filter
kernal = ones(5,5)/25;
img_denoise = medfilt2(log3, [5 5]);
img_gauss = imgaussfilt(img_denoise, 3);
figure;
subplot(221);imshow(log3); title("Original Image");
subplot(222);imshow(img_denoise); title("Denoise Image");
subplot(223);imshow(img_gauss); title("Gaussian Filter");



img_sobel_vertical = edge(img_gauss, 'sobel', 'vertical');
img_sobel_horizontal = edge(img_gauss, 'sobel', 'horizontal');
img_canny_vertical = edge(img_gauss, 'canny', 'vertical');
img_canny_horizontal = edge(img_gauss, 'canny', 'horizontal');

figure("Name", "");
subplot(221);imshow(img_sobel_vertical);title("Sobel Vertical");
subplot(222);imshow(img_sobel_horizontal);title("Sobel Horizontal");
subplot(223);imshow(img_canny_vertical);title("Canny Vertical");
subplot(224);imshow(img_canny_horizontal);title("Canny Horizontal");

% apply dilation
SE1 = strel('diamond', 3);
img_dilated = imdilate(img_sobel_vertical, SE1);
figure;
subplot(121);imshow(img_sobel_vertical);title("Original Image");
subplot(122);imshow(img_dilated);title("Dilated Image");


