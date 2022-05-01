function remove_errors(trial_no,home_path)

    %% Paths 
    path_robot_poses = fullfile(home_path,"robot_poses", trial_no);
    robot_poses = csvread(fullfile(path_robot_poses,'robot_poses.csv'));
    errors = csvread(fullfile(home_path,'image_segmentation\processed_images\',trial_no, "errors.csv"));
    
    %% Remove errors 
    count = 1;
    AA = [];
    for i = 1:3:size(robot_poses,1)  
        if ismember(count, errors, 'rows')
            count;
        else
            AA = [AA; [robot_poses(i:i+2,:); 0 0 0 1]];
        end
        count= count + 1;
    end


    csvwrite(fullfile(path_robot_poses, "error_free\robot_poses.csv"), AA);
    

end
    
    