%% code for measuring distance distribution of filaments
%% code for calculating orientation correlation
clear;
clc;
ctr = 1;

data1 = dlmread('H:\Ross Lab\San Diego\SD code\Ian Analysis\6-12\Ianquiv6-12peg41.dat'); % %file1.dat
data2 = dlmread('H:\Ross Lab\San Diego\SD code\Ian Analysis\6-12\Ianquiv6-12peg42.dat'); % %file1.dat
data3 = dlmread('H:\Ross Lab\San Diego\SD code\Ian Analysis\6-12\Ianquiv6-12peg43.dat'); % %file1.dat
data4 = dlmread('H:\Ross Lab\San Diego\SD code\Ian Analysis\6-12\Ianquiv6-12peg44.dat'); % %file1.dat
data = cat(1,data1,data2,data3,data4);
quiver3(data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6))

%% size dependent measurement
s = size(data);
xmax = max(data(:,1));
ymax = max(data(:,2));
zmax = max(data(:,3));
roi = 10;

%what is the effect of constrining orientation in one plane
%data(:,6) = abs(data(:,6));

%bin = 0:step:roi
%lb = size(bin);
%res = zeros(lb(2),3);
ctr = 1;
for np = 1:s(1)
    if data(np,1) >= roi && data(np,1) <= xmax-roi && data(np,2) >= roi && data(np,2) <= ymax-roi && data(np,3) >= roi && data(np,3) <= zmax-roi
        for nn = np:s(1)
                d = sqrt((data(np,1)-data(nn,1))^2+(data(np,1)-data(nn,1))^2+(data(np,1)-data(nn,1))^2);
                if d <= roi;
                res(ctr) = d;
                ctr = ctr+1;
                end
        end
    end
end
bin = 0:0.2:20;
[y x] = hist(res,bin);
y = y/sum(y);
x = x';
y = y';
%plot(x,y)

%% size independent measurement
% s = size(data);
% for i = 1:s(1)
%     for j = i:s(1)
%         d(ctr) = sqrt((data(i,1)-data(j,1))^2+(data(i,2)-data(j,2))^2+(data(i,3)-data(j,3))^2);
%         ctr = ctr + 1;
%     end
% end
% d = d';
% bin = 0:4:400;
% [y,x] = hist(d,bin);
% y = y/sum(y);
% plot(x,y)