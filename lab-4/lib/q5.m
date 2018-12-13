clear();

load landsat_data;

I_orig = landsat_data(:,:,[3,2,1])./255;

T = zeros(512, 512);
T(440:500, 150:220) = 1; % class 1 - forest
T(10:40, 320:400) = 1;
T(140:200, 40:110) = 2; % class 2 - urban
T(253:280, 108:115) = 3; % class 3 - agricultural field
T(263:293, 324:359) = 3;
T(490:510, 25:65) = 4; % class 4 - water

%visualize T, cy coloring the original image
T_vis = label2rgb(T, "lines", "k");
T_vis = T_vis ./ 255;
I_T = I_orig;
replace = find(T_vis);
I_T(replace) = T_vis(replace);

figure(1);
colormap("parula");
subplot(1,2,1); imagesc(I_orig); title("Original");
subplot(1,2,2); imagesc(I_T); title("Filter");

I = landsat_data(:,:,[3,2,1,4,5,6,7])./255;
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
a = I(:,:,4);
b = I(:,:,5);
c = I(:,:,6);
d = I(:,:,7);
figure(2);plot3(R(:), G(:), B(:),".") % 3D scatterplot of the RGB data
% histograms of the channels
figure(3);subplot(2,4,1);imhist(R);title("R");
subplot(2,4,2);imhist(G);title("G");
subplot(2,4,3);imhist(B);title("B");
subplot(2,4,4);imhist(a);title("band 4");
subplot(2,4,5);imhist(b);title("band 5");
subplot(2,4,6);imhist(c);title("band 6");
subplot(2,4,7);imhist(d);title("band 7");

figure(4);
subplot(2,2,1); imagesc(I_orig); title("Original");
% bands 1,2,3
I_data = landsat_data(:,:,[1,2,3])./255;
C = classify_band(I_data, T, 'linear');
ImC = class2im(C,size(I_data,1),size(I_orig,2)); % Reshape the classification to an image
subplot(2,2,2); imagesc(ImC); title("Bands 1,2,3");
I_data = landsat_data(:,:,[1,4,5,6])./255;
C = classify_band(I_data, T, 'diaglinear');
ImC = class2im(C,size(I_data,1),size(I_orig,2)); % Reshape the classification to an image
subplot(2,2,3);imagesc(ImC); title("1,4,5,6 dlin");
% bands 1,2,3,4,6,7 diaglinear
I_data = landsat_data(:,:,[1,2,3,4,5,6,7])./255;
C = classify_band(I_data, T, 'diaglinear');
ImC = class2im(C,size(I_data,1),size(I_orig,2)); % Reshape the classification to an image
subplot(2,2,4); imagesc(ImC); title("All bands, dlin");

function res = classify_band(indata, filter, classification)
    [data,class] = create_training_data(indata,filter);
    Itest = im2testdata(indata); % Reshape the image before classification
    res = classify(double(Itest),double(data),double(class), classification); % Train classifier and classify the data
end