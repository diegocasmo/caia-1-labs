clear(); % clear workspace

Im = imread('images/wagon_shot_noise.png');
% median filtering
Im_median_3 = medfilt2(Im, [3 3]);
Im_median_7 = medfilt2(Im, [7 7]);
Im_median_31 = medfilt2(Im, [31 31]);

% mean/average filtering
filter_average3 = fspecial('average', 3);
filter_average7 = fspecial('average', 7);
filter_average31 = fspecial('average', 31);
Im_average3 = imfilter(Im, filter_average3);
Im_average7 = imfilter(Im, filter_average7);
Im_average31 = imfilter(Im, filter_average31);

% gaussian filtering
filter_gauss3 = fspecial('gaussian', 3);
filter_gauss7 = fspecial('gaussian', 7);
filter_gauss31 = fspecial('gaussian', 31);
Im_gauss3 = imfilter(Im, filter_gauss3);
Im_gauss7 = imfilter(Im, filter_gauss7);
Im_gauss31 = imfilter(Im, filter_gauss31);

% own median filter, based on assignment 1
[rows, cols] = size(Im);
Im_median_own = zeros(rows, cols);
% Copy boundary pixels:
for i = 1:rows
    Im_median_own(i,1) = Im(i,1);
    Im_median_own(i,2) = Im(i,2);
    Im_median_own(i,cols-1) = Im(i,cols-1);
    Im_median_own(i,cols) = Im(i,cols);
end
for j = 1:cols
    Im_median_own(1,j) = Im(1,j);
    Im_median_own(2,j) = Im(2,j);
    Im_median_own(rows-1,j) = Im(rows-1,j);
    Im_median_own(rows,j) = Im(rows,j);
end
% Filter interior pixels:
for i = 3:rows - 2
    for j = 3:cols - 2
        Im_median_own(i,j) = median(reshape(Im(i-2:i+2,j-2:j+2), [], 1));
    end
end
Im_median_own = uint8(Im_median_own); % Convert to uint8


% draw plots
draw4plots(Im, Im_median_3, Im_median_7, Im_median_31, 'Median filtering');
draw4plots(Im, Im_average3, Im_average7, Im_average31, 'Average filtering');
draw4plots(Im, Im_gauss3, Im_gauss7, Im_gauss31, 'Gaussian filtering');
figure('Name', 'Own median filtering');
subplot(1,2,1), imshow(Im);
subplot(1,2,2), imshow(Im_median_own);


function draw4plots(Im1, Im2, Im3, Im4, title)

figure('Name', title),
subplot(2,2,1), imshow(Im1);
subplot(2,2,2), imshow(Im2);
subplot(2,2,3), imshow(Im3);
subplot(2,2,4), imshow(Im4);

end