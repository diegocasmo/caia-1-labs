function S = myclassifier(I,trained_net)
  % Setup categorical label to label mapping
  labels = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26'};
  categories = {[0, 0, 0] [0,0,1] [0,0,2] [0,1,0] [0,1,1] [0,1,2] [0,2,0] [0,2,1] [0,2,2] [1,0,0] [1,0,1] [1,0,2] [1,1,0] [1,1,1] [1,1,2] [1,2,0] [1,2,1] [1,2,2] [2,0,0] [2,0,1] [2,0,2] [2,1,0] [2,1,1] [2,1,2] [2,2,0] [2,2,1] [2,2,2]};
  categorical_to_label = containers.Map(labels,categories);

  % Pre-process input image
  I = medfilt2(I,[8 8]);
  I = imcrop(I,[65 52 139 99]);
  I = imbinarize(I,graythresh(I));
  I = uint8(I);

  % Classify image
  categorical_label = classify(trained_net,I);

  % Get label given categorical label
  S = categorical_to_label(char(categorical_label));
end

