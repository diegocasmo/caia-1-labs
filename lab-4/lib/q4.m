clear();


I_bw = imread("handBW.pnm");
figure(1); imshow(I_bw);

label_im = imread("hand_training.png"); % Read image with labels
[data,class] = create_training_data(I_bw,label_im); % Arrange the training data into vectors

Itest = im2testdata(I_bw); % Reshape the image before classification
C = classify(double(Itest),double(data),double(class), 'linear'); % Train classifier and classify the data
ImC = class2im(C,size(I_bw,1),size(I_bw,2)); % Reshape the classification to an image
figure(3);imagesc(ImC); % View the classification result


