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

%{
    Second part, histogram equalisation
%}

% Loading the image and conversion to grayscale is done above
% I is original image
% I_gray is grayscaled image

% MATLAB's native histeq:
I_histeqd = histeq(I_gray);

figure,
subplot(1,3,1), imhist(I_gray);
subplot(1,3,2), imhist(I_histeqd);
subplot(1,3,3), imhist(flathist(I_gray));

% Own histogram algorithm
function hist = flathist(image, bins)
% default 64 bins:
if ~exist('bins')
    bins = 64;
end

% derived constants
[rows, cols] = size(image);
sum_freqs = rows * cols;

% the ideal frequencies are as equally distributed as possible
ideal_freqs = zeros(bins, 1);
for b = 1:bins
    ideal_freqs(b) = sum_freqs/bins;
end
for b = 1:mod(sum_freqs,bins) % in case there is a remainder
    ideal_freqs(b) = ideal_freqs(b) + 1;
end
cul_ideal_freqs = cumsum(ideal_freqs); %cumulative frequencies of the ideal

freqs = zeros(256,1); % freqs(i) is frequency of pixel value i
map = zeros(256,1); % maps pixel value i to ideal bin map(i)

% For each pixel value, count its frequency:
for i = 1:256
    freqs(i) = sum(image(:) == i-1);
end
cul_freqs = cumsum(freqs); %cumulative frequencies of pixel values

% For each frequency, map it to an ideal bin:
for i = 1:256
    map(i) = 1;
    for b = 2:bins
        if abs(cul_freqs(i) - cul_ideal_freqs(b)) < abs(cul_freqs(i) - cul_ideal_freqs(map(i)))
            map(i) = b;
        end
    end
end

% for each pixel, apply map
hist = image;
for i = 1:rows
    for j = 1:cols
        hist(i,j) = map(image(i,j)+1) * 4;
    end
end

end