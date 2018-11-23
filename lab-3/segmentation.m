
Im_orig = imread('images/coins.tif');
%Im_orig = Im_orig(1:50, 301:350);
% pre-process the image

% grayscale
Im = imbinarize(Im_orig, graythresh(Im_orig));

% smooth 3x3 mean
Im = medfilt2(Im);

% distance
Im_pp = bwdist(Im);

% apply segmentation
Im_seg = Im_pp;

Im_seg = -Im_seg;
Im_seg(~Im_pp) = Inf;
Im_seg = watershed(Im_seg);

% post-process the image
Im_postp = Im_seg;
Im_postp(~Im_pp) = 0;
Im_postp = label2rgb(Im_postp);

% generate histogram
regprops = regionprops(Im_postp, 'Area');
A = [regprops.Area];
A(A==0)=[];

% display the result
figure('Name', 'Coins');
subplot(2,2,1), imshow(Im_orig);
subplot(2,2,2), imshow(mat2gray(Im_pp));
subplot(2,2,3), imshow(mat2gray(Im_seg));
subplot(2,2,4), imshow(Im_postp);

figure,
hist(A(1:13));
