clc;
clear all;
close all;

%% specify paths and load data and header
filename = 'straight (25)';
path = 'D:/SEM_4/Project/my_files/image_segmentation/raw_images/try_1/straight/';

path_reco = fullfile(path, [filename '.raw']);
path_mhd = fullfile(path, [filename '.mhd']);

fid = fopen(path_reco);
data = fread(fid, 'float32');
fclose(fid);
fid2 = fopen(path_mhd, 'r');
header = fscanf(fid2, '%s');
%% read dim-info from mhd
[startIndex,endIndex] = regexp(header, 'DimSize');
dimx = str2num(header(endIndex+2:endIndex+4));
dimy = str2num(header(endIndex+5:endIndex+7));
dimz = str2num(header(endIndex+8:endIndex+10));
numvol = str2num(header(endIndex+11));

%% visualize volume

US_volume = reshape(data, [dimx, dimy, dimz, numvol]);
% US_volume = US_volume(:,(1:dimy-10),:, :);

figure(1)
subplot(141)
imagesc(flip((squeeze(US_volume(round(dimx/2),:,:))')))
colormap gray
title('B-scan x');

subplot(142)
imagesc(flip((squeeze(US_volume(:,round(dimy/2),:))')))
colormap gray
title('B-scan y');

subplot(143)
imagesc(flip((squeeze(US_volume(:,:,round(dimz/2)')))))
colormap gray
title('B-scan z');



if numvol > 1
    for idx=1:length(numvol)
        volumeViewer(US_volume(:,:,:,idx));
    end
else
    volumeViewer(US_volume);
end




