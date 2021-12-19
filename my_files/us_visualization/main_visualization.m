clc;
clear all;
close all;

%% specify paths and load data and header
path_image = 'D:\SEM_4\Project\my_files\us_visualization\try_2';
path_to_save = 'D:\SEM_4\Project\my_files\image_segmentation\raw_images\try_2';
show_image = true;

%% Read all file names in dir
dir_data = dir(fullfile(path_image, '*.raw'));
files_list = struct2table(dir_data);
file_names = files_list.name;
file_names = split(file_names, '.');


%% Convert from raw and mhd files to jpg
for i = 1:size(file_names,1)
    i
    success = us_raw_to_jpg(path_image, path_to_save, file_names{i,1}, show_image);
    
end
 
%%
disp("success")