clear();

load cdata;

figure(1);plot(cdata(:,1),cdata(:,2),".");

I = imread("handBW.pnm");
figure(2);imshow(I);
figure(3);imhist(I);

t1 = 100; t2 = 175;
figure(4);mtresh(I,t1,t2);



