%image correlation code
%This code measures decay of correlation as a function of time.
clear;
clc;
n_ini = 1;
n_im = 30;
dim = 512;
matrec = zeros(dim,dim,n_im-n_ini);
dmax = 10;
dt = 1/2.01;
res = zeros(dmax+1,3); %first time, second mean of corr, third std of corr
str1 = 'E:\Shea\100A\TS1\100a_ts1t';
for i = n_ini:n_im
    disp(i);
    str2 = sprintf('%3.3d\n',i);
    str3 = '.tif';
    filename = strcat(str1,str2,str3);
    data = imread(filename);
    matrec(:,:,i-n_ini+1) = data;
end
%meat part
for del = 0:dmax
    disp(del);
    ctr = 1;
    for i = 1:n_im-n_ini-del-1
        im1 = matrec(:,:,i);
        im2 = matrec(:,:,i+del);
        % test section
        gt1 = graythresh(im1);
        gt2 = graythresh(im2);
        mim1 = im2bw(im1,gt1*1.2);
        mim2 = im2bw(im2,gt2*1.2);
        fim1 = medfilt2(mim1,[3 3]);
        fim2 = medfilt2(mim2,[3 3]);
        % end test section
        list(ctr) = corr2(fim1,fim2);
        ctr = ctr+ 1;
    end
    res(del+1,1) = del*dt;
    res(del+1,2) = mean(list);
    res(del+1,3) = std(list);
    %disp(list);
    clear list;
end
errorbar(res(:,1),res(:,2),res(:,3));