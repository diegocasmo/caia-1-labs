clear(); % clear workspace

Im1 = imread('images/lines.png');
Im2 = imread('images/cameraman.png');

% FFT - q11
Im1_FFT = log(abs(fftshift(fft2(double(Im1)))));
Im2_FFT = log(abs(fftshift(fft2(double(Im2)))));
Im1_FFT_res = Im1_FFT;
Im2_FFT_res = Im2_FFT;

% Random, small signals
randvec1 = fftshift(fft2(rand(1,5)));
randvec2 = fftshift(fft2(rand(1,6)));

% filter here?

resvec1 = ifft2(ifftshift(randvec1));
resvec2 = ifft2(ifftshift(randvec2));

% FFT - q13
Im1_FFT = fftshift(fft2(Im1));
Im2_FFT = fftshift(fft2(Im2));

% do filter
Im1_FFT = filter(Im1_FFT);
Im2_FFT = filter(Im2_FFT);

Im1_FFT = ifft2(ifftshift(Im1_FFT));
Im2_FFT = ifft2(ifftshift(Im2_FFT));   

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

figure('Name', 'FFT - own filter');
subplot(2,2,1), imshow(Im1);
subplot(2,2,2), imagesc(Im1_FFT);
subplot(2,2,3), imshow(Im2);
subplot(2,2,4), imagesc(Im2_FFT);


figure('Name', 'FFT - freqdist.png');
subplot(1,2,1), imshow(Im3);
subplot(1,2,2); imshow(Im3_FFT);

function result = filter(Image)
    result = Image;
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
