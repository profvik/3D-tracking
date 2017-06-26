%% code for calculating orientation correlation
clear;
clc;
roi = 10;
step = 1;

data1 = dlmread('H:\Ross Lab\San Diego\SD code\Ian Analysis\6-12\Ianquiv6-12peg21.dat'); % %file1.dat
data2 = dlmread('H:\Ross Lab\San Diego\SD code\Ian Analysis\6-12\Ianquiv6-12peg22.dat'); % %file1.dat
data3 = dlmread('H:\Ross Lab\San Diego\SD code\Ian Analysis\6-12\Ianquiv6-12peg23.dat'); % %file1.dat
data4 = dlmread('H:\Ross Lab\San Diego\SD code\Ian Analysis\6-12\Ianquiv6-12peg24.dat'); % %file1.dat
data = cat(1,data1,data2,data3,data4);
quiver3(data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6))
s = size(data);
xmax = max(data(:,1));
ymax = max(data(:,2));
zmax = max(data(:,3));

%what is the effect of constrining orientation in one plane
%data(:,6) = abs(data(:,6));

bin = 0:step:roi
lb = size(bin);
res = zeros(lb(2),3);
for r = 1:lb(2)
    disp(r);
for np = 1:s(1)
    if data(np,1) >= roi && data(np,1) <= xmax-roi && data(np,2) >= roi && data(np,2) <= ymax-roi && data(np,3) >= roi && data(np,3) <= zmax-roi
        for nn = 1:s(1)
            if nn ~= np
                d = sqrt((data(np,1)-data(nn,1))^2+(data(np,1)-data(nn,1))^2+(data(np,1)-data(nn,1))^2);
                if d <= r*step && d > (r-1)*step
                    res(r,1) = r*step;
                    res(r,2) = res(r,2) + data(np,4)*data(nn,4) + data(np,5)*data(nn,5) +data(np,6)*data(nn,6);
                    res(r,3) = res(r,3) + 1;
                end
            end
        end
    end
end
res(r,2) = res(r,2)/res(r,3);
end
inivec = [0 1 1];
res = cat(1,inivec,res);
figure;
plot(res(:,1),res(:,2))