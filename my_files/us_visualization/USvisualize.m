clc;
clear all;
close all;

%% specify paths and load data and header
filename = 'left (1)';
path = 'D:\SEM_4\Project\my_files\us_visualization\try_1\left';
path_to_save = 'D:\SEM_4\Project\my_files\image_segmentation\raw_images\try_1\straight';

path_reco = fullfile(path, [filename '.raw']);
path_mhd = fullfile(path, [filename '.mhd']);
path_save = fullfile(path_to_save, [filename '.jpg']);

fid = fopen(path_reco);
data = fread(fid, 'float32');
fclose(fid);
fid2 = fopen(path_mhd, 'r');
header = fscanf(fid2, '%s');
%% read dim-info from mhd
[startIndex,endIndex] = regexp(header, 'DimSize');
dimx = str2num(header(endIndex+2:endIndex+5));
dimy = str2num(header(endIndex+6:endIndex+9));
numvol = str2num(header(endIndex+10));

%% visualize volume

BScan = reshape(data, [dimx, dimy, numvol]);

figure(1)
imagesc(BScan')
colormap gray
title('B Scan');


gray_image = im2gray(BScan');
imwrite(gray_image,gray, path_save); 


