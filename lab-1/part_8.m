I = imread('./images/part_8/lion.JPG');
I_gray = rgb2gray(I);
I_gray_resized = imresize(I_gray, [128 128], 'bilinear', 'antialiasing', false);

[rows, cols] = size(I_gray_resized);
result = zeros(rows, cols);
for i = 3:rows - 2
    for j = 3:cols - 2
        result(i,j) = mean(reshape(I_gray_resized(i-2:i+2,j-2:j+2), [], 1));
    end
end


figure, imshow(I);
figure, imshow(result);
% figure, imshow(I - result);