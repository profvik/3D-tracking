%analysis of tracked images
%this code will read data file and do something with it.
clear;
clc;
data1 = dlmread('data1.dat');
data2 = dlmread('data2.dat');
nim = 41;
xres = 0.41;
yres = 0.41;
zres = 1.0;
imsizex = 512;
imsizey = 512;
xmax = imsizex*xres;
ymax = imsizey*yres;
%% first section is going to calculate volume fraction as a function of z
for i = 1:41
    z(i,1) = i;
    n = size(find(data1(:,3) == i));
    z(i,2) = n(1)/(imsizex*imsizey);
    n = size(find(data2(:,3) == i));
    z(i,3) = n(1)/(imsizex*imsizey);
end
figure;
plot(z(:,1),z(:,2));
hold;
plot(z(:,1),z(:,3));
%% This section claculates local orientation
xbox = 32;
ybox = 32;
zbox = 8;
for x = 1:xbox:256
    disp(x);
    for y = 1:ybox:256
        for z = 1:8:40
            xmin = x*xres;
            ymin = y*yres;
            zmin = z;
            xmax = (x+xbox)*xres;
            ymax = (y+ybox)*yres;
            zmax = z+zbox;
            listpxmin = find(data1(:,1) > xmin);
            listpxmax = find(data1(:,1) < xmax);
            listpx = intersect(listpxmin,listpxmax);
            listpymin = find(data1(:,2) > ymin);
            listpymax = find(data1(:,2) < ymax);
            listpy = intersect(listpymin,listpymax);
            listpzmin = find(data1(:,3) > zmin);
            listpzmax = find(data1(:,3) < zmax);
            listpz = intersect(listpzmin,listpzmax);
            listpre = intersect(listpx,listpy);
            listfin = intersect(listpre,listpz);
            xval = data1(listfin,1);
            yval = data1(listfin,2);
            zval = data1(listfin,3);
            np = size(xval);
            chk = isempty(np);
            if chk ~= 1
            Ixx = 0;
            Iyy = 0;
            Izz = 0;
            Ixy = 0;
            Iyz = 0;
            Ixz = 0;
            for n = 1:np(1)
                Ixx = Ixx + xval(n)^2;
                Iyy = Iyy + yval(n)^2;
                Izz = Izz + zval(n)^2;
                Ixy = Ixy + xval(n)*yval(n);
                Iyz = Iyz + yval(n)*zval(n);
                Ixz = Ixz + xval(n)*zval(n);
            end
            matdat = [Ixx -Ixy -Ixz; -Ixy Iyy -Iyz; -Ixz -Iyz Izz];
            [V D] = eig(matdat);
            [xmax ymax] = find(D == max(max(D)));
            
        end
    end
end