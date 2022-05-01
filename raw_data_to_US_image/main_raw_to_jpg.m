function main_raw_to_jpg(trial_no, show_image, home_path, varargin)
    
  %% specify paths and load data and header
    path_image = fullfile(home_path, 'raw_data_to_US_image\', trial_no);
   
    if nargin == 4
        path_to_save = varargin{1};
    else
        path_to_save = fullfile(home_path, 'image_segmentation\raw_images', trial_no);
    end
    create_dir(path_to_save)
    %% Read all file names in dir
    dir_data = dir(fullfile(path_image, '*.raw'));
    files_list = struct2table(dir_data);
    file_names = files_list.name;
    file_names = split(file_names, '.');


    %% Convert from raw and mhd files to jpg
    for i = 1:size(file_names,1)
        success = us_raw_to_jpg(path_image, path_to_save, file_names{i,1}, show_image);

    end

    %%
    disp(['Number of images processd =', num2str(i)])
    
end