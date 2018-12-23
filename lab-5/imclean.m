%% 'Cleans' the passed image

function res = imclean(Im)

% grayscale
Im = imbinarize(Im, graythresh(Im));
% pre-process more
Im = ~Im; % invert, since the passed image has white background
Im = bwmorph(Im, 'erode'); % remove small objects
Im = bwmorph(Im, 'skel', Inf); % skeletonize the remaining objects
Im = bwmorph(Im, 'spur'); % remove "spur" pixels
Im = bwmorph(Im, 'clean'); % remove small dots which are not connected to the numbers
Im = bwmorph(Im, 'diag'); % ensure that the pixels of the digits are 8-connected
res = ~Im; % re-invert, to return an image with white background

end