clear();

load landsat_data;

I_orig = landsat_data(:,:,[3,2,1])./255;
I_filter = I_orig;
I_filter(450:480, 170:200,:) = 1;

T = zeros(512, 512);
T(450:480, 170:200) = 1; % class 1 - forest
T(10:40, 380:400) = 1;
T(160:200, 60:110) = 2; % class 2 - urban
T(253:260, 108:115) = 3; % class 3 - greenest agricultural field
%T( 470:500, 30:60) = 4; % class 4 - water
%I_orig(253:260, 108:115, :) = Inf;
figure(1);

colormap("parula");
subplot(1,3,1); imagesc(I_orig);
subplot(1,3,3); imagesc(T);

I_data = landsat_data(:,:,[1,2,3])./255;
[data,class] = create_training_data(I_data,T);

Itest = im2testdata(I_data); % Reshape the image before classification
C = classify(double(Itest),double(data),double(class), 'linear'); % Train classifier and classify the data
ImC = class2im(C,size(I_data,1),size(I_orig,2)); % Reshape the classification to an image

subplot(1,3,2); imagesc(ImC); % View the classification result
