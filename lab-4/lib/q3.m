clear();

I2 = imread("hand.pnm"); % Read the image
figure(5);imshow(I2); % Show the image
R = I2(:,:,1); % Separate the three layers, RGB
G = I2(:,:,2);
B = I2(:,:,3);
figure(6);plot3(R(:),G(:),B(:),".") % 3D scatterplot of the RGB data
% histograms of channels
figure(7);subplot(1,3,1);imhist(R);
subplot(1,3,2);imhist(G);
subplot(1,3,3);imhist(B);

label_im = imread("hand_training.png"); % Read image with labels
figure(8);imagesc(label_im);% View the training areas

I3(:,:,1) = R; % Create an image with bands/features
I3(:,:,2) = G;
I3(:,:,3) = B;
[data,class] = create_training_data(I3,label_im); % Arrange the training data into vectors
figure(9);scatterplot3D(data,class); % View the training feature vectors

Itest = im2testdata(I3); % Reshape the image before classification
C = classify(double(Itest),double(data),double(class), 'linear'); % Train classifier and classify the data
ImC = class2im(C,size(I3,1),size(I3,2)); % Reshape the classification to an image
figure(10);imagesc(ImC); % View the classification result


figure(11);imagesc(medfilt3(ImC, [3 3 3]));
