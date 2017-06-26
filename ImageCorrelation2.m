%image correlation code
%This code tries to take care of effect of averaging
%This code measures decay of correlation as a function of time.
clear;
clc;
avov = 10; 
n_im = 900;
x = 1:avov:n_im;
s = size(x);
dim = 512;
matrec = zeros(dim,dim,s(2));
dmax = s(2)/2;
dt = 1/15.45;
res = zeros(dmax,3); %first time, second mean of corr, third std of corr
str1 = 'C:\Users\vikrant\Desktop\SanDiego Data\1.12\5050c\time sequence5050cc2t';
ctr = 1;
for i = 1:avov:n_im
    disp(i);
    str2 = sprintf('%3.3d\n',i);
    str3 = '.tif';
    filename = strcat(str1,str2,str3);
    data = imread(filename);
    th = graythresh(data);
    bw = im2bw(data,th*1.25);
    matrec(:,:,ctr) = bw;
    ctr = ctr + 1;
end
 %% meat part
 for del = 1:dmax
     disp(del);
     ctr = 1;
     for i = 1:s(2)-del-1
         im1 = matrec(:,:,i);
         im2 = matrec(:,:,i+del-1);
         list(ctr) = corr2(im1,im2);
         ctr = ctr+ 1;
     end
     res(del,1) = (del-1)*avov*dt;
     res(del,2) = mean(list);
     res(del,3) = std(list);
     %disp(list);
     clear list;
 end
 errorbar(res(:,1),res(:,2),res(:,3));