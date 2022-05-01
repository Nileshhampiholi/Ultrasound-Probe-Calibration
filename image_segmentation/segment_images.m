function segment_images(trial_no, show_image, home_path)

    %% Specify Dir  
    
    raw_images = fullfile(home_path,'image_segmentation\raw_images\', trial_no);
    pre_processed_images = fullfile(home_path,'image_segmentation\pre_processing\', trial_no);
    processed_images = fullfile(home_path,'image_segmentation\processed_images\', trial_no);
    
    create_dir(raw_images);
    create_dir(pre_processed_images);
    create_dir(processed_images);
    


    %% Read names of all images 
    files = dir(fullfile(raw_images, '*.jpg'));
    files = struct2table(files);
    file_names = natsortfiles(files.name);
    centriods = [];
    errors = [];
    threshould = 0.3;
    
    extra = [82,83, 84, 85, 86,121, 122,123, 125,126]';
%     extra = [82,83, 84, 85, 86, 87, 183,184,185,186,187,223,224,226,227]';
    %% Iterate over the number of images 
    for i=1:size(file_names,1)
        
        if ismember(i, extra, 'rows')
            errors = [errors; i];
            continue
        end
        try
            %% Display File Name 
            file_name = char(file_names(i));

            %% Preprocess Image
            image_pre_processing(file_names{i},raw_images, pre_processed_images,5, 10,show_image, 0.5);

            %% Extract Centriods
            centriod = centriod_extraction(file_names{i},pre_processed_images, processed_images,show_image);
            
            
            %% If all 12 centriods are not found redo the provessing with different parameters 
            if size(centriod,1) == 12
                centriods = [centriods [centriod]];
            else
               image_pre_processing(file_names{i},raw_images, pre_processed_images, 5, 7,show_image, 0.3);

               centriod = centriod_extraction(file_names{i},pre_processed_images, processed_images,show_image);
                
                %% If even after 2nd attempt all 12 centroids are not found mark image as error
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
    
    %% Scale the pixel values to mm 
    scale = get_pixel_to_mm_conversion_factor(pre_processed_images);
    count = 1;
    for i = 1:(size(centriods,2)/2)
        centriods(:,count:count+1) = centriods(:,count:count+1) * scale;
        count = count+2;
    end
    %% Store centriods 
    centriods = array2table(centriods);
    writetable(centriods, fullfile(processed_images,'centriods.csv'));
    writematrix(errors, fullfile(processed_images, 'errors.csv'));
    disp('Image Semgentation is Finished ...');
end
