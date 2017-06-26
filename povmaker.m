clear;
clc;
data = dlmread('Ian.dat');
%data2 = dlmread('zs1-10cy3t.dat');
%data3 = dlmread('zM30A70MT.dat');
s = size(data);
%s2 = size(data2);
%s3 = size(data3);
fileid = fopen('Ian.pov','w');
fprintf(fileid, '#include "colors.inc"\r\n');
fprintf(fileid, 'background { color White }\r\n');
fprintf(fileid, 'camera {\r\n');
fprintf(fileid, 'location <0, 0, 45>\r\n');
fprintf(fileid, 'look_at <0, 0, 0>\r\n');
fprintf(fileid, '}\r\n');
fprintf(fileid, 'union\r\n');
fprintf(fileid, '{\r\n');
for i = 1:s(1)
    fprintf(fileid, 'sphere {\r\n');
    fprintf(fileid, '<%f %f %f>, %f\r\n',data(i,1),data(i,2),data(i,3),0.3);
    fprintf(fileid, '  texture {\r\n');
    fprintf(fileid, 'pigment{color Green transmit 0.7}\r\n');
    fprintf(fileid, '}\r\n');
    fprintf(fileid, '}\r\n');
end
% for i = 1:s3(1)
%     fprintf(fileid, 'sphere {\r\n');
%     fprintf(fileid, '<%f %f %f>, %f\r\n',data3(i,1),data3(i,2),data3(i,3),0.3);
%     fprintf(fileid, '<%f %f %f>, %f\r\n',data2(i,1),data2(i,2),data2(i,3),0.2);
%     fprintf(fileid, '  texture {\r\n');
%     fprintf(fileid, 'pigment { color Red filter 0.7 }\r\n');
%     fprintf(fileid, '}\r\n');
%     fprintf(fileid, '}\r\n');
% end
fprintf(fileid, 'translate < -56.32, -56.32, -13.12>\r\n');
%fprintf(fileid, 'translate < -28.16, -28.16, -25>\r\n');
fprintf(fileid, 'rotate < 0,360*clock,0>//  <-!!!!\r\n');
fprintf(fileid, '}\r\n');

fprintf(fileid, 'light_source { <0, 0, 50> color White shadowless}\r\n');
fclose(fileid);