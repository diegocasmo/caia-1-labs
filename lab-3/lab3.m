% Clear workspace
clear();

% Number of rows/cols for subplotting
n_rows = 3;
n_cols = 3;
figure;

% Read image
I = imread('./images/coins.tif');
subplot(n_rows, n_cols, 1), 
imshow(I),
title('Original');

% Pre-process image
I = imsharpen(I);
subplot(n_rows, n_cols, 2),
imshow(I),
title('Sharpened');

% Get BW image
I_bw = ~imbinarize(I, graythresh(I));
subplot(n_rows, n_cols, 3),
imshow(I_bw),
title('Binarized');

% Apply more pre-processing to the BW image
I_bw = imdilate(I_bw, true(3));
subplot(n_rows, n_cols, 4),
imshow(I_bw),
title('Dilated');

% Compute distance: assign a number that is the distance between that 
% pixel and the nearest nonzero pixel of BW
I_dist = bwdist(~I_bw);
I_dist_rgb = repmat(rescale(I_dist), [1 1 3]);
subplot(n_rows, n_cols, 5), 
imshow(I_dist_rgb),
title('BW Distance');

% Complement the distance transform, and force pixels that don't belong to 
% the objects to be at Inf (white)
I_dist = -I_dist;
I_dist(~I_bw) = Inf;
subplot(n_rows, n_cols, 6),
imshow(I_dist),
title('Force Non-objects to Inf');

% Use the watershed method for segmentation
I_watershed = watershed(I_dist, 8);
I_watershed(~I_bw) = 0;
subplot(n_rows, n_cols, 7),
imshow(label2rgb(I_watershed)),
title('Labeled Watershed');

% Get measurements for each 8-connected component in the binary image
F = regionprops(I_watershed, 'Area', 'Centroid');

% Put a label in each centroid
for i = 1:numel(F)
    text(F(i).Centroid(1), F(i).Centroid(2), num2str(i), 'Color', 'w', ...
        'HorizontalAlignment', 'center')
end

% Render histogram based in object's area
areas = [F.Area];
figure, histogram(areas(areas > 500), 20);
title('Lab 3'),
ylabel('Number of Objects'),
xlabel('Area (measured in pixels)');
