clear all;
clc;

imgfile = ['J:\Matlab_Program\MATLAB\My_Histogram\PVO_based\data\'];
imgdir = dir([imgfile,'\*.bmp']);
fid=fopen('fileName.txt','wt');
performance = zeros(length(imgdir)*2,5000);
location_map = zeros(length(imgdir),1);
Thresh = zeros(length(imgdir)*3,5000);
Tnum = 1;
for i = 1:1
    
img = 2*(i-1)+1;
I = double(imread([imgfile,'\',imgdir(i).name]));
fprintf(fid, '%s\n',imgdir(i).name);
tic
[nPer LM T] = PVO_K2(I);
toc
performance(img,:) = nPer(1,:);
performance(img+1,:) = nPer(2,:);
location_map(i) = LM;

Thresh(Tnum,:) = T(1,:);
Thresh(Tnum+1,:) = T(2,:);
% Thresh(Tnum+2,:) = T(3,:);
Tnum = Tnum+2;

% figure;
% a = sum(performance(img,:)>0);
% plot(performance(img,1:a),performance(img+1,1:a), 'kd', 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'MarkerSize', 4);
% filename =sprintf('%s',strtok(imgdir(i).name,'.')); 
% title(filename);
% grid on;

end
fclose(fid);