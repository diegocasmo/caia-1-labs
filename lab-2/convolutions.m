clear(); % clear workspace

Im = imread('images/cameraman.png');
% draw original image
figure, imshow(Im);


% average filters and sharpening
filter_average3 = fspecial('average', 3);
filter_average7 = fspecial('average', 7);
filter_average31 = fspecial('average', 31);
filter_sharpened_avrg3 = sharpening('average', 3, 3);
filter_sharpened_avrg7 = sharpening('average', 7, 7);
filter_sharpened_avrg31 = sharpening('average', 31, 31);
Im_average3 = imfilter(Im, filter_average3);
Im_average7 = imfilter(Im, filter_average7);
Im_average31 = imfilter(Im, filter_average31);
Im_sharpened_avrg3 = imfilter(Im, filter_sharpened_avrg3);
Im_sharpened_avrg7 = imfilter(Im, filter_sharpened_avrg7);
Im_sharpened_avrg31 = imfilter(Im, filter_sharpened_avrg31);
draw3plots(Im_average3, Im_average7, Im_average31);
draw3plots(Im_sharpened_avrg3, Im_sharpened_avrg7, Im_sharpened_avrg31);

% disk filter and sharpening
filter_disk3 = fspecial('disk', 1);
filter_disk7 = fspecial('disk', 3);
filter_disk31 = fspecial('disk', 15);
filter_sharpened_disk3 = sharpening('disk', 3, 1);
filter_sharpened_disk7 = sharpening('disk', 7, 3);
filter_sharpened_disk31 = sharpening('disk', 31, 15);
Im_disk3 = imfilter(Im, filter_disk3);
Im_disk7 = imfilter(Im, filter_disk7);
Im_disk31 = imfilter(Im, filter_disk31);
Im_sharpened_disk3 = imfilter(Im, filter_sharpened_disk3);
Im_sharpened_disk7 = imfilter(Im, filter_sharpened_disk7);
Im_sharpened_disk31 = imfilter(Im, filter_sharpened_disk31);
draw3plots(Im_disk3, Im_disk7, Im_disk31);
draw3plots(Im_sharpened_disk3, Im_sharpened_disk7, Im_sharpened_disk31);

% gaussian filter and sharpening
filter_gauss3 = fspecial('gaussian', 3);
filter_gauss7 = fspecial('gaussian', 7);
filter_gauss31 = fspecial('gaussian', 31);
filter_sharpened_gauss3 = sharpening('gaussian', 3, 3);
filter_sharpened_gauss7 = sharpening('gaussian', 7, 7);
filter_sharpened_gauss31 = sharpening('gaussian', 31, 31);
Im_gauss3 = imfilter(Im, filter_gauss3);
Im_gauss7 = imfilter(Im, filter_gauss7);
Im_gauss31 = imfilter(Im, filter_gauss31);
Im_sharpened_gauss3 = imfilter(Im, filter_sharpened_gauss3);
Im_sharpened_gauss7 = imfilter(Im, filter_sharpened_gauss7);
Im_sharpened_gauss31 = imfilter(Im, filter_sharpened_gauss31);
draw3plots(Im_gauss3, Im_gauss7, Im_gauss31);
draw3plots(Im_sharpened_gauss3, Im_sharpened_gauss7, Im_sharpened_gauss31);



% draw the three passed images in a new figure
function draw3plots(Im1, Im2, Im3)

figure,
subplot(2, 2, 1), imshow(Im1);
subplot(2, 2, 2), imshow(Im2);
subplot(2, 2, 3), imshow(Im3);

end

% requires that size is odd and > 0
function filter = sharpening(name, size, filter_size)

    filter_average = fspecial(name, filter_size);
    filter_original = zeros(size);
    filter_original(round(size/2), round(size/2)) = 1;

    filter = filter_original + 3 * (filter_original - filter_average);
    
end