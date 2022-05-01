function [mean_err, s_d] = segmentation_error(trial_no, home_path)

    %% Variables
    processed = fullfile(home_path,'\image_segmentation\processed_images\',trial_no);
    vertical_distance = [];
    horizonatal_distance = [];
    count = 0;

    %% Read names of all images 
    centriods = readtable(fullfile(processed, 'centriods.csv'));
    centriods = table2array(centriods);
    centriods = reshape(centriods,12,2,[]);
    %% Compute distances
    for i=1:size(centriods,3)
        data = centriods(:,:,i);
        first_layer  = sortrows(data(1:3,:),1); 
        second_layer = sortrows(data(4:6,:),1);  
        third_layer  = sortrows(data(7:9,:),1); 
        fourth_layer = sortrows(data(10:12,:),1);

        % Vertical 
        left_strand = [first_layer(1,:); second_layer(1,:); third_layer(1,:); fourth_layer(1,:);];    
        right_strand =   [first_layer(3,:); second_layer(3,:); third_layer(3,:); fourth_layer(3,:);];  

        % Distance between alternate has to be 10mm 
        temp =mean([mean(diag(pdist2(first_layer,second_layer)));
                       mean(diag(pdist2(second_layer,third_layer)));
                       mean(diag(pdist2(third_layer,fourth_layer)))]);
        vertical_distance = [vertical_distance, temp];

        % disance between left and right strand is 30mm
        horizonatal_distance = [horizonatal_distance, mean(diag(pdist2(left_strand,right_strand)))];


    end    
    
    %% Compute the deviation 
    vertical_error = abs(10 - vertical_distance);
    horizontal_error = abs(30 - (horizonatal_distance));
    
    %% Get mean error and stanard deviation 
    mean_horizonaltal_error = mean(horizontal_error);
    mean_vertical_error = mean(vertical_error);

    mean_err = [mean_horizonaltal_error, mean_vertical_error];
    s_d = std([horizontal_error', vertical_error']);
    % [max(horizontal_error), max(vertical_error)]
    % [min(horizontal_error), min(vertical_error)]

end 

