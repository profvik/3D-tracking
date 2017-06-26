%% Test for 3d tracking on sandiago data
clear;
clc;
f_dim = 1024;
quad = 4; %%quadrant = 1, 2, 3, 4 for bigger pictures
n_ini = 10;
n_file = 110; %number of files
xystep = 0.11; %micon/pix
zstep = 0.5; %micron/frame
str1 = 'E:\Ian\Tiff Stacks\6by12peg4\4% 6-12 50fv 60x zstack01z';
mat3d = zeros(f_dim,f_dim,n_file);
matrec = zeros(f_dim,f_dim,n_file);
loc = [0 0 0];
for i = 1:n_file
    disp(i);
    str2 = sprintf('%3.3d\n',i);
    str3 = '.tif';
    filename = strcat(str1,str2,str3);
    data = imread(filename);
    if quad == 1
    data = data(1:f_dim,1:f_dim);
    x0 = 0;
    y0 = 0;
    elseif quad == 2
        data = data(f_dim+1:2*f_dim,1:f_dim);
        x0 = f_dim*xystep;
        y0 = 0;
    elseif quad == 3
        data = data(1:f_dim,f_dim+1:2*f_dim);
        x0 = 0;
        y0 = f_dim*xystep;
    elseif quad == 4
        data = data(f_dim+1:2*f_dim,f_dim+1:2*f_dim);
        x0 = f_dim*xystep;
        y0 = f_dim*xystep;
    end
    %data = data1(1:512,1:512);
    matrec(:,:,i) = data;
    % modifcation section begin
    %data = histeq(uint8(data));
    th = graythresh(data);
    bw = im2bw(data,th*1.3);
    filtim = medfilt2(bw,[3 3]);
%     imshow(filtim);
%     waitforbuttonpress;
    %bwa = bwareaopen(bw,20,4);
    % modifcation section end
    mat3d(:,:,i) = filtim;%bwa;
    %[x y] = find(bwa == 1);
    %templs = cat(2,x,y);
    %templs(:,3) = i;
    %loc = cat(1,loc,templs);
    %clear templs;
end
bwa = bwareaopen(mat3d,500);
skel =Skeleton3D(bwa);
for i = 1:n_file
    %chkim = bwa(:,:,i);
    chkim = skel(:,:,i);
    [x y] = find(chkim == 1);
    templs = cat(2,x,y);
    templs(:,3) = i;
    loc = cat(1,loc,templs);
    clear templs;
end
loc(1,:) = [];
loc(:,1) = x0 + (loc(:,1))*xystep;
loc(:,2) = y0 + (loc(:,2))*xystep;
loc(:,3) = loc(:,3)*zstep;
dlmwrite('Ian6-12peg44.dat',loc);

%% This part looks at orientation of particles in 3d
cc = bwconncomp(bwa);
parlist = regionprops(cc,'PixelList')
sz = size(parlist);
resquiv = zeros(sz(1),6);
for i = 1:sz(1)
    szl = size(parlist(i).PixelList);
    I11 = 0;
    I22 = 0;
    I33 = 0;
    I12 = 0;
    I13 = 0;
    I23 = 0;
    xcm = 0;
    ycm = 0;
    zcm = 0;
    for j = 1:szl(1)
        x = x0 + parlist(i).PixelList(j,1)*0.11;
        y = y0 + parlist(i).PixelList(j,2)*0.11;
        z = parlist(i).PixelList(j,3)*0.5;
        I11 = I11 + y^2 + z^2;
        I22 = I22 + x^2 + z^2;
        I33 = I33 + x^2 + y^2;
        I12 = I12 + x*y;
        I13 = I13 + x*z;
        I23 = I23 + y*z;
        xcm = xcm + x;
        ycm = ycm + y;
        zcm = zcm + z;
    end
    inmat = [I11 -I12 -I13; -I12 I22 -I23; -I13 -I23 I33];
    [V D] = eig(inmat);
    [px py] = find(D == max(max(D)));
    orvec = V(:,px);
    resquiv(i,1) = xcm/szl(1);
    resquiv(i,2) = ycm/szl(1);
    resquiv(i,3) = zcm/szl(1);
    resquiv(i,4) = orvec(1);
    resquiv(i,5) = orvec(2);
    resquiv(i,6) = orvec(3);
end
dlmwrite('Ianquiv6-12peg44.dat',resquiv);
quiver3(resquiv(:,1),resquiv(:,2),resquiv(:,3),resquiv(:,4),resquiv(:,5),resquiv(:,6))
beep;
%% checking section
%skel =Skeleton3D(bwa);
% for i = 1:n_file
%     %imshow(mat3d(:,:,i));
%     imshow(skel(:,:,i));
%     m(i) = getframe();
%     %waitforbuttonpress();
% end
% %% This section removes connecting points
% rw = 1; %size of running window is rw x rw x rw
% ctr = 1;
% s = size(skel);
% for x = 2:f_dim-1
%     for y = 2:f_dim-1
%         for z = 2:n_file-1
%             partim = skel(x-rw:x+rw,y-rw:y+rw,z-rw:z+rw);
%             if sum(sum(sum(partim))) >= 7 && skel(x,y,z) == 1
%                 list(ctr,1) = sub2ind(s,x,y,z);
%                 ctr = ctr + 1;
%             end
%         end
%     end
% end
% sl = size(list);
% figure;
% hold;
% for i = 1:sl(1)
%     [x y z] = ind2sub(s,list(i));
%     vec = [x y z];
%     scatter3(x,y,z);
%     disp(vec);
%     skel(x-1:x+1,y-1:y+1,z-1:z+1) = 0;
% end
% 
% load example binary skeleton image

% -------------------------------------------
% here is the edge code
% lets go
% -------------------------------------------

% %% new section
% 
% w = size(skel,1);
% l = size(skel,2);
% h = size(skel,3);
% 
% %initial step: condense, convert to voxels and back, detect cells
% [~,node,link] = Skel2Graph3D(skel,0);
% 
% %total length of network
% wl = sum(cellfun('length',{node.links}));
% 
% skel2 = Graph2Skel3D(node,link,w,l,h);
% [~,node2,link2] = Skel2Graph3D(skel2,0);
% 
% %calculate new total length of network
% wl_new = sum(cellfun('length',{node2.links}));
% 
% %iterate the same steps until network length changed by less than 0.5%
% ctr = 0;
% while(wl_new~=wl)
% %while(wl_new <= 0.9999*wl)
%     disp(ctr);
%     disp(wl);
%     disp(wl_new);
%     ctr = ctr+1;
%     wl = wl_new;   
%     
%      skel2 = Graph2Skel3D(node2,link2,w,l,h);
%      [A2,node2,link2] = Skel2Graph3D(skel2,0);
% 
%      wl_new = sum(cellfun('length',{node2.links}));
% 
% end;
% 
% %display result
% figure();
% hold on;
% for i=1:length(node2)
%     x1 = node2(i).comx;
%     y1 = node2(i).comy;
%     z1 = node2(i).comz;
%     
%     if(node2(i).ep==1)
%         ncol = 'c';
%     else
%         ncol = 'y';
%     end;
%     
%     for j=1:length(node2(i).links)    % draw all connections of each node
%         if(node2(link2(node2(i).links(j)).n2).ep==1)
%             col='k'; % branches are blue
%         else
%             col='k'; % links are red
%         end;
%         if(node2(link2(i).n1).ep==1)
%             col='k';
%         end;
% 
% %       draw edges as lines using voxel positions
%         for k=1:length(link2(node2(i).links(j)).point)-1            
%             [x3,y3,z3]=ind2sub([w,l,h],link2(node2(i).links(j)).point(k));
%             [x2,y2,z2]=ind2sub([w,l,h],link2(node2(i).links(j)).point(k+1));
%             line([y3 y2],[x3 x2],[z3 z2],'Color',col,'LineWidth',2);
%         end;
%     end;
%     
%  %   draw all nodes as yellow circles
%     plot3(y1,x1,z1,'o','Markersize',9,...
%        'MarkerFaceColor',ncol,...
%        'Color','k');
% end;
% axis image;axis off;
% set(gcf,'Color','white');
% drawnow;
% view(-17,46);
% 
% bin = 0:2:64;
% [ydat,xdat] = hist(cellfun('length',{node2.links}),bin);
% ydat = ydat/sum(ydat);
% plot(xdat,ydat);
% xdat = xdat';
% ydat = ydat';