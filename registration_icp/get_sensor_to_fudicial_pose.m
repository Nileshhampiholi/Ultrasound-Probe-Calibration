function [mean_error, sd]= get_sensor_to_fudicial_pose(trial_no, origin_at_wire, home_path)
    
    %% Image blob centriods 

    centriods = readtable(fullfile(home_path,'image_segmentation\processed_images\',trial_no,'\centriods.csv'));
    centriods = table2array(centriods);
    centriods = reshape(centriods,12,2,[]);
    %% Read Point cloud of wire phantom 
    point_cloud_phantom_full = csvread('wire_phantom.csv');

    %% Variables
    transforms =[];
    min_er = [];
    n = 12;

    %% Visualization of initial data

    figure(5);
    title("Initial Data",'FontSize', 24)
    plot3(  point_cloud_phantom_full(:,1),...
            point_cloud_phantom_full(:, 2),...
            point_cloud_phantom_full(:, 3),...
            'bo', 'MarkerSize', 1)
    axis equal;
    grid on;
    hold on 
    for i =1:size(centriods,3)
        %% Get image points ready for ICP
        % Get x, y of image blobbs stored in the table
        image_centriods = centriods(:,:,i);
        % Convert to matrix from tbale 
        %image_centriods = image_centriods{:,:};
        %image_centriods = image_centriods*scale_matrix;
        point_cloud_image = [image_centriods(:,1) zeros(size(image_centriods, 1),1)+(i*0.5) image_centriods(:,2)];
        h = plot3(  point_cloud_image(:, 1),...
                    point_cloud_image(:, 2),...
                    point_cloud_image(:, 3),...
                    'r.', 'MarkerSize' , 5);

        set(h, 'markersize', 5)

    end
    legend("N-Wire", "Centriod of Image blobs obatined from US Image",'Orientation','vertical', 'Location', 'southoutside','FontSize', 16)
    xlabel("X",'FontSize', 24);
    ylabel("Y",'FontSize', 24);
    zlabel("Z",'FontSize', 24);
    hold off

%% Visualisation of ICP results
    figure(6);
    title("ICP Results",'FontSize', 24)
    plot3(  point_cloud_phantom_full(:,1),...
            point_cloud_phantom_full(:, 2),...
            point_cloud_phantom_full(:, 3),...
            'bo', 'MarkerSize', 1)
    axis equal;
    grid off;
    hold on 
    %% Iterte over Images 
    errors =[];
    for i =1:size(centriods,3)
        
        %% Initial transfrom 
        if origin_at_wire
             init_trasfrom_matrix = [rotx(180) [0;10;0;];
                                    [0    0    0   1  ]];
        else
            init_trasfrom_matrix =  [rotx(180) [40;20;90];
                                    [0    0    0   1  ]];
        end
        %% Get image points ready for ICP
        % Get x, y of image blobbs stored in the table
        image_centriods_scaled = centriods(:,:,i);
        % Conver image points for 2d to 3d  
         point_cloud_image_scaled = [image_centriods_scaled(:,1) zeros(size(image_centriods_scaled, 1),1) image_centriods_scaled(:,2)];

        % Rearrange to match the structure of phantom model
        % 1st 4 rows are left strands, next 4 are at middle strands and last
        % are thr right stands 
        point_cloud_image_re_arranged = sortrows(point_cloud_image_scaled,1);
        point_cloud_image_re_arranged = [sortrows(point_cloud_image_re_arranged(1:4,:),3);
                                         sortrows(point_cloud_image_re_arranged(5:8,:),3);
                                         sortrows(point_cloud_image_re_arranged(9:12,:),3)];

        % Apply initial manual trasformation to alight with the phantom model
        point_cloud_image_initial_trasfrom =point_cloud_image_re_arranged * init_trasfrom_matrix(1:3,1:3) +repmat(init_trasfrom_matrix(1:3,4)', 12, 1);      

    
        %% Aplly Distance ratio based ICP
         [trasfromation,point_cloud_image_transfromed, min_error] = icp_distance_ratio(point_cloud_phantom_full, point_cloud_image_initial_trasfrom);
        
        if min_error > 1.5
            if origin_at_wire
                init_trasfrom_matrix = [rotx(180) [0;10;-5;];
                                       [0    0    0   1  ]];
            else
               init_trasfrom_matrix = [rotx(180) [40;20;97;];
                                      [0    0    0   1  ]];
            end
            point_cloud_image_initial_trasfrom =point_cloud_image_re_arranged * init_trasfrom_matrix(1:3,1:3) +repmat(init_trasfrom_matrix(1:3,4)', 12, 1);    
            [trasfromation,point_cloud_image_transfromed, min_error] = icp_distance_ratio(point_cloud_phantom_full, point_cloud_image_initial_trasfrom);
        end
        
        if min_error > 1.5
            errors = [errors; i];
        else
            min_er = [min_er; min_error];
        
            %% Visualise the Tansformed Points 
            h = plot3(  point_cloud_image_transfromed(:, 1),...
                        point_cloud_image_transfromed(:, 2),...
                        point_cloud_image_transfromed(:, 3),...
                        'r.', 'MarkerSize' , 5);
            set(h, 'markersize', 10)
            hold on
         
            tfrom = [trasfromation.Rotation trasfromation.Translation';
                     0   0 0 1]   *  init_trasfrom_matrix;  
            transforms = [transforms; invTfMat(tfrom)];
           
        end
       
    end

    xlabel("X",'FontSize', 24);
    ylabel("Y",'FontSize', 24);
    zlabel("Z",'FontSize', 24);
    legend("N-Wire", "Marker",'Orientation','vertical', 'Location', 'bestoutside','FontSize', 16)
    legend("Z-Wire Phantom", "Estimated Pose",'FontSize', 16)

    mean_error = mean(min_er);
    sd = std(min_er);
    %% If error file is not alred marked as error then add it to error files.
    exisiting_errors = csvread(fullfile(home_path,'image_segmentation\processed_images\',trial_no,"\errors.csv"));
    for x =1:size(errors,1)
        
        if ~any(exisiting_errors(:) == errors(x))
            exisiting_errors = [exisiting_errors ; errors(x)];
        end
    end

    %% Write error file and poses
    csvwrite(fullfile(home_path,'image_segmentation\processed_images\',trial_no,"\errors.csv"),exisiting_errors);
    csvwrite(fullfile(home_path, "registration_icp\",trial_no,"registration_poses.csv"), transforms)

end
