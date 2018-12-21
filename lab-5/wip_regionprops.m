clear();

% Classification based on regionprops
% Currently gives 0.935833 precision, with a runtime of ~20s
% Code is quite currently quite disorganised, and does not follow the required format

global debug
debug = 1;

tic
true_labels = importdata('labels.txt');
my_labels = zeros(size(true_labels));
N = size(true_labels,1);
l = 1; % 1
u = 1200; % N
for k = l:u 
    im = imread(sprintf('imagedata/train_%04d.png', k));
    my_labels(k,:) = mclassifier(im);
    debug = debug +1;
end

errors = 0;
for i = l:u
    if my_labels(i,1) ~= true_labels(i,1)
        errors = errors +1;
    end
    if my_labels(i,2) ~= true_labels(i,2)
       errors = errors +1;
    end
    if my_labels(i,3) ~= true_labels(i,3)
       errors = errors +1;
    end 
    if my_labels(i,1) ~= true_labels(i,1) || my_labels(i,2) ~= true_labels(i,2) || my_labels(i,3) ~= true_labels(i,3)
        fprintf("\nerror at image %d\n", i);
        fprintf("predicted [%d %d %d], but true is [%d %d %d]\n", my_labels(i,1), my_labels(i,2), my_labels(i,3), true_labels(i,1), true_labels(i,2), true_labels(i,3));
    end
end

fprintf("\ntotal number of errors: %d\n", errors);
fprintf('\n\nAverage precision: \n');
fprintf('%f\n\n',mean(sum(abs(true_labels(l:u,:) - my_labels(l:u,:)),2)==0));
toc

function res = mclassifier(Im)

    global debug

    Im = imclean(Im);
    Im = ~Im;
    
    RP = regionprops(Im, 'Extrema', 'EulerNumber', 'Image');
    Ext = cat(1,RP.Extrema);
    
    tol = 2;
    
    E = cat(1,RP.EulerNumber);
    nObjects = length(RP);

    result = zeros(3,1);
    
    if nObjects == 3
        for i = 1:3
            if E(i) == 0
                result(i) = 0;
            else
                if abs(Ext(8*(i-1)+4, 1) - Ext(8*(i-1)+2, 1)) < tol
                   result(i) = 1;
                else
                    result(i) = 2;
                end
            end
        end
    else
        if nObjects == 2
            Images = {RP.Image};
            Height(1) = size(Images{1},1);
            Height(2) = size(Images{2},1);
            Width(1) = size(Images{1},2);
            Width(2) = size(Images{2},2);
            % if the first component is two numbers
            if  Width(1) > Width(2)
                % split the first component
                Images{1} = bwmorph(Images{1}, 'thicken',1); % makes finding a split a little more consistent
                split = findSplit2(Images{1}, Width(1), Height(1));
                Images{1} = bwmorph(Images{1}, 'thicken',1); % ensure we don't cut open a 0
                Images{1}(:,floor(split)) = 0;
                % classify the first two numbers
                RP = regionprops(Images{1}, 'Extrema', 'EulerNumber', 'Area');
                Extc = cat(1,RP.Extrema);
                Ec = cat(1,RP.EulerNumber);
                Ac = cat(1,RP.Area);
                if length(RP) == 3 && Ac(2) < Ac(3) % In case a third component was created by splitting
                    Extc(9) = Extc(17);Extc(10) = Extc(18);
                    Extc(11) = Extc(19);Extc(12) = Extc(20);
                    Extc(13) = Extc(21);Extc(14) = Extc(22);
                    Extc(15) = Extc(23);Extc(16) = Extc(24);
                    Ec(2) = Ec(3);
                end
                for i = 1:2
                    if Ec(i) == 0
                        result(i) = 0;
                    else
                        if abs(Extc(8*(i-1)+4, 1) - Extc(8*(i-1)+2, 1)) < tol
                           result(i) = 1;
                        else
                            result(i) = 2;
                        end
                    end
                end
                % classify the last number
                if E(2) == 0
                    result(3) = 0;
                else
                    if abs(Ext(8*1+4, 1) - Ext(8*1+2, 1)) < tol
                       result(3) = 1;
                    else
                        result(3) = 2;
                    end
                end
            else % else, the second component is two numbers
                % classify the first number
                if E(1) == 0
                    result(1) = 0;
                else
                    if abs(Ext(4, 1) - Ext(2, 1)) < tol
                       result(1) = 1;
                    else
                        result(1) = 2;
                    end
                end
                % split the second component
                Images{2} = bwmorph(Images{2}, 'thicken',1); % makes finding a split a little more consistent
                split = findSplit2(Images{2}, Width(2), Height(2));
                Images{2} = bwmorph(Images{2}, 'thicken',1); % ensure we don't cut open a 0
                Images{2}(:,floor(split)) = 0;
                % classify the first two numbers
                RP = regionprops(Images{2}, 'Extrema', 'EulerNumber', 'Area');
                Extc = cat(1,RP.Extrema);
                Ec = cat(1,RP.EulerNumber);
                Ac = cat(1,RP.Area);
                if length(RP) == 3 && Ac(2) < Ac(3) % In case a third component was created by splitting
                    Extc(9) = Extc(17);Extc(10) = Extc(18);
                    Extc(11) = Extc(19);Extc(12) = Extc(20);
                    Extc(13) = Extc(21);Extc(14) = Extc(22);
                    Extc(15) = Extc(23);Extc(16) = Extc(24);
                    Ec(2) = Ec(3);
                end
                % classify the last numbers
                for i = 1:2
                    if Ec(i) == 0
                        result(i+1) = 0;
                    else
                        if abs(Extc(8*(i-1)+4, 1) - Extc(8*(i-1)+2, 1)) < tol
                           result(i+1) = 1;
                        else
                            result(i+1) = 2;
                        end
                    end
                end
            end
        end
    end

    if debug == 69
        x = 1;
    end
    
    res = result;
    
end

% find the x-coordinate of where to split the passed component into two,
% so that the numbers detected are the same
function res = findSplit2(Im, width, height)

    global debug

    if debug == 31
        x = 1;
    end
    
    Im = ~Im;
    ubound = floor(width*0.75);
    lbound = floor(width*0.25);
    Im = Im(:,lbound:ubound);
    
    RP = regionprops(Im, 'Extrema');
    nObjects = length(RP);
    Ext = cat(1,RP.Extrema);
    
    minx = width*0.5 - lbound / 2.0;
    miny = height*0.5; % split in the middle if nothing good enough is found
    
    for i = 1:nObjects
        x = Ext(8*(i-1)+5, 1);
        y = Ext(8*(i-1)+5, 2);
        if y < miny
            miny = y;
            minx = x;
        end
    end
    res = minx + lbound -1;
end
