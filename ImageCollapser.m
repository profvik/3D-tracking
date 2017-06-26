%% this code creates a collapsed image for san diego experiments
clear;
clc;
finim = uint8(zeros(512,512));
ini = 1;
fin = 20;
%n_file = 20; %number of files
filename = 'H:\New Danny\20170113\20170113_ch06_MyLOVChar_EX4R_1-4dilution_2mMATP_2mMMag_1mspf_600frames_150Xmag 05 - Copy.tif';
%xystep = 0.21; %micon/pix
%zstep = 0.41; %micron/frame
%str1 = 'H:\Ross Lab\San Diego\New data\ZSB\z-seriesbz';
%mat3d = zeros(512,512,n_file);
%matrec = zeros(512,512,n_file);
loc = [0 0 0];
for i = ini:fin
%for i = 1:n_file
    disp(i);
    %str2 = sprintf('%3.3d\n',i);
    %str3 = '.tif';
    %filename = strcat(str1,str2,str3);
    %data = imread(filename);
    data = uint8(sqrt(double(imread(filename,i))));
    bw = im2bw(data,0.05);
    filtim = uint8(medfilt2(bw,[2 2]));
    finim = max(finim,filtim);
end
imagesc(finim)