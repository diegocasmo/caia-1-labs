%{
    First part, blur filter
%}
% Load the image, convert to grayscale, and resize
I = imread('./images/part_8/lion.JPG');
I_gray = rgb2gray(I);
I_gray_resized = imresize(I_gray, [128 128], 'bilinear', 'antialiasing', false);

[rows, cols] = size(I_gray_resized);
result = zeros(rows, cols);
% Copy boundary pixels:
for i = 1:rows
    result(i,1) = I_gray_resized(i,1);
    result(i,2) = I_gray_resized(i,2);
    result(i,cols-1) = I_gray_resized(i,cols-1);
    result(i,cols) = I_gray_resized(i,cols);
end
for j = 1:cols
    result(1,j) = I_gray_resized(1,j);
    result(2,j) = I_gray_resized(2,j);
    result(rows-1,j) = I_gray_resized(rows-1,j);
    result(rows,j) = I_gray_resized(rows,j);
end
% Filter interior pixels:
for i = 3:rows - 2
    for j = 3:cols - 2
        result(i,j) = mean(reshape(I_gray_resized(i-2:i+2,j-2:j+2), [], 1));
    end
end
result = uint8(result); % Convert to uint8

figure, 
subplot(1,2,1), imshow(I);
subplot(1,2,2), imshow(I_gray);
figure,
subplot(1,3,1), imshow(I_gray_resized);
subplot(1,3,2), imshow(result); 
subplot(1,3,3), imshow(I_gray_resized - result);
