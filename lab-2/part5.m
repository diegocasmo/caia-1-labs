clear(); % clear workspace

Im1 = imread('images/lines.png');
Im2 = imread('images/cameraman.png');
ImRect = imread('images/rectangle.png');
ImCirc = imread('images/circle.png');

% FFT - q11
Im1_FFT = log(abs(fftshift(fft2(double(Im1)))));
Im2_FFT = log(abs(fftshift(fft2(double(Im2)))));
ImRect_FFT = log(abs(fftshift(fft2(double(ImRect)))));
ImCirc_FFT = log(abs(fftshift(fft2(double(ImCirc)))));
Im1_FFT_res = Im1_FFT;
Im2_FFT_res = Im2_FFT;
ImRect_FFT_res = ImRect_FFT;
ImCirc_FFT_res = ImCirc_FFT;

% Random, small signals - q12
% Transfer to frequency domain
ovec1 = rand(1,5);
randvec1 = fftshift(fft2(ovec1));
ovec2 = rand(1,6);
randvec2 = fftshift(fft2(ovec2));

% Do filter here
randvec1(1) = 0; randvec1(5) = 0;
randvec2(2) = 0; randvec2(6) = 0;

% Transfer back from frequency domain
resvec1 = ifft2(ifftshift(randvec1));
resvec2 = ifft2(ifftshift(randvec2));

% FFT - q13
Im1_FFT_shifted = fftshift(fft2(Im1));
Im2_FFT_shifted = fftshift(fft2(Im2));

% do filter
Im1_FFT_filtered = filter(Im1_FFT_shifted);
Im2_FFT_filtered = filter(Im2_FFT_shifted);

Im1_FFT_filtered = ifft2(ifftshift(Im1_FFT_filtered));
Im2_FFT_filtered = ifft2(ifftshift(Im2_FFT_filtered));   

% q14 - freqdist, suppressing values
Im3 = imread('images/freqdist.png');
Im3_FFT = fftshift(fft2(Im3));
Im3_FFT = suppress(Im3_FFT);
Im3_FFT = ifft2(ifftshift(Im3_FFT));


figure('Name', 'FFT');
subplot(2,2,1), imshow(Im1);
subplot(2,2,2), imagesc(Im1_FFT_res);
subplot(2,2,3), imshow(Im2);
subplot(2,2,4), imagesc(Im2_FFT_res);

figure('Name', 'FFT - continued');
subplot(2,2,1), imshow(ImRect);
subplot(2,2,2), imagesc(ImRect_FFT_res);
subplot(2,2,3), imshow(ImCirc);
subplot(2,2,4), imagesc(ImCirc_FFT_res);

figure('Name', 'FFT - own filter');
subplot(2,2,1), imshow(Im1);
subplot(2,2,2), imagesc(Im1_FFT_filtered);
subplot(2,2,3), imshow(Im2);
subplot(2,2,4), imagesc(Im2_FFT_filtered);


figure('Name', 'FFT - freqdist.png');
subplot(1,2,1), imshow(Im3);
subplot(1,2,2); imshow(Im3_FFT);

function result = filter(Image)

    [rows, cols] = size(Image);
    
    % assume that either both rows and cols are even, or none of them are
    if mod(rows, cols) == 0
        mid_r = rows/2 + 1; mid_c = cols/2 + 1;
    else
        mid_r = rows/2; mid_c = cols/2;
    end
    
    dx = 20;
    dy = 1;
    
    result = Image;
    
    result(mid_r-dx:mid_r+dx, mid_c-dy:mid_c+dy) = 0;
    
end

function result = suppress(Image)
    [rows, cols] = size(Image);
    
    result = Image;
    
    for i = 1:rows
        for j = 1:cols
            if abs(Image(i,j)) > 100000
                result(i,j) = 0;
            end
        end
    end
end
