% Clear all data and window and close all tabs
% Set image window Size 
close all;
clear all;
clc;

%% Specify Dir  
raw_images = 'D:\SEM_4\Project\my_files\image_segmentation\raw_images\try_2\gama_negative';
pre_processed_images = 'D:\SEM_4\Project\my_files\image_segmentation\pre_processing\try_2\gama_negative';
processed_images = 'D:\SEM_4\Project\my_files\image_segmentation\processed_images\try_2\gama_negative';

%% Read names of all images 
files = dir(fullfile(raw_images, '*.jpg'));
files = struct2table(files);
file_names = natsortfiles(files.name);
centriods = [];
errors = [];
show_image = false;
threshould = 0.3;

% straight =  0.5, 7, 3 |  gama_positive= 0.3  1, 10

%% Iterate over the number of images 
for i=1:size(file_names,1)
    try
        %% Display File Name 
        file_name = char(file_names(i));
        disp(file_name);

        %% Preprocess Image
        image_pre_processing(file_names{i},raw_images, pre_processed_images,1, 10,show_image, threshould);
        % pre_processing_2(file_names{i},raw_images, pre_processed_images,show_image, false);
        
        %% Extract Centriods
        centriod = centriod_extraction(file_names{i},pre_processed_images, processed_images,show_image);
       
        if size(centriod,1) == 12
            centriods = [centriods [centriod]];
        else
            image_pre_processing(file_names{i},raw_images, pre_processed_images,3, 7,show_image, threshould);
            % pre_processing_2(file_names{i},raw_images, pre_processed_images,show_image, false);
       
            centriod = centriod_extraction(file_names{i},pre_processed_images, processed_images,show_image);

            if size(centriod,1) == 12
                centriods = [centriods [centriod]];
            else
                errors = [errors; i];
            end
            
        end
    catch exception
        disp(exception)
        errors = [errors; i];
    end
end

centriods = array2table(centriods);
disp(centriods)
writetable(centriods, fullfile(processed_images,'centriods.csv'));
writematrix(errors, fullfile(processed_images, 'errors.csv'));
close all;
disp('Processing is Finished ...');