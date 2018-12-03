clear(); % clear workspace

alpha = 5;
Im1 = imread('images/cameraman.png');
Im2 = imread('images/wagon.png');
% draw original image
figure('Name', 'Original images'), 
subplot(2,1,1), imshow(Im1);
subplot(2,1,2), imshow(Im2);

% Demo of unsharp masking. For more examples, see part 1
filter_sharpened_gauss7 = sharpening('gaussian', 7, 7, alpha);
Im1_sharpened_gauss7 = imfilter(Im1, filter_sharpened_gauss7);
Im2_sharpened_gauss7 = imfilter(Im2, filter_sharpened_gauss7);
figure('Name', 'Unsharp masking'),
subplot(2,1,1), imshow(Im1_sharpened_gauss7);
subplot(2,1,2), imshow(Im2_sharpened_gauss7);

% requires that size is odd and > 0
function filter = sharpening(name, size, filter_size, alpha)

    filter_average = fspecial(name, filter_size);
    filter_original = zeros(size);
    filter_original(round(size/2), round(size/2)) = 1;

    filter = filter_original + alpha * (filter_original - filter_average);
    
end