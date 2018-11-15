clear(); % clear workspace

Im1 = imread('images/cameraman.png');
Im2 = imread('images/wagon.png');

% x-direction
xsobel = fspecial('sobel')';
Im1_sobel_x = imfilter(Im1, xsobel);
Im2_sobel_x = imfilter(Im2, xsobel);
% draw image
figure('Name', 'Sobel in X');
subplot(2,2,1), imshow(Im1);
subplot(2,2,2), imshow(Im1_sobel_x);
subplot(2,2,3), imshow(Im2);
subplot(2,2,4), imshow(Im2_sobel_x);

% y-direction
ysobel = fspecial('sobel');
Im1_sobel_y = imfilter(Im1, ysobel);
Im2_sobel_y = imfilter(Im2, ysobel);
% draw image
figure('Name', 'Sobel in Y');
subplot(2,2,1), imshow(Im1);
subplot(2,2,2), imshow(Im1_sobel_y);
subplot(2,2,3), imshow(Im2);
subplot(2,2,4), imshow(Im2_sobel_y);


