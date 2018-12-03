% Clear workspace
clear();

% Read image
Im_orig = imread('images/coins.tif');

% pre-process the image:
% grayscale
Im = imbinarize(Im_orig, graythresh(Im_orig));

% smooth using mean
Im = medfilt2(Im, [5,5]);

% distance
Im_pp = bwdist(Im);

% generate labels for coloring of regions
Im_emax = imextendedmax(Im_pp, 1);
Im_emax = bwmorph(Im_emax, 'shrink', Inf); % let one dot remain for each region
[rows, cols] = size(Im_emax);
Im_emax = uint8(Im_emax);
for r = 1:rows
    for c = 1:cols
        if Im_emax(r,c) == 1
            Im_emax(r,c) = Im_pp(r,c);
        end
    end
end

% apply watershed segmentation
Im_seg = Im_pp;

Im_seg = -Im_seg;
Im_seg(~Im_pp) = Inf;
Im_seg = watershed(Im_seg);

% post-process the image
Im_postp = Im_seg;
Im_postp(~Im_pp) = 0;
Im_postp = logical(Im_postp);

% generate histogram
regprops = regionprops(Im_postp, 'Area');
A = [regprops.Area];
A(A<500)=[];

% erode to remove small components
Im_postp = bwmorph(Im_postp, 'erode');

% color all regions with same radius with same color
rp = regionprops(Im_postp, 'ConvexHull');
Im_postp = uint8(Im_postp);
for r = 1:rows
    for c = 1:cols
        if Im_emax(r,c) > 0 && Im_postp(r,c) > 0
            Im_postp(r,c) = Im_emax(r,c);
        end
    end
end

for i = 1:length(rp)
    roi = roipoly(Im_postp, rp(i).ConvexHull(:,1), rp(i).ConvexHull(:,2));
    Im_postp(roi) = max(Im_postp(roi));
end
Im_postp = label2rgb(Im_postp, 'prism', 'k');

% display the result
figure('Name', 'Segmentation');
subplot(2,2,1), imshow(Im_orig), title('Original');
subplot(2,2,2), imshow(mat2gray(Im_pp)), title('Distances');
subplot(2,2,3), imshow(mat2gray(Im_seg)), title('Segmentation');
subplot(2,2,4), imshow(Im_postp), title('Final result');
figure('Name', 'Objects by area'),
histogram(A, 20);

