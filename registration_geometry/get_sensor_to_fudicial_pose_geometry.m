function [mean_rms_error, sd]= get_sensor_to_fudicial_pose_geometry(trial_no,home_path)

centriods = readtable(fullfile(home_path,'image_segmentation\processed_images\',trial_no,'\centriods.csv'));
centriods = table2array(centriods);
centriods = reshape(centriods,12,2,[]);

%% Read Point cloud of wire phantom 
point_cloud_phantom_full = csvread('wire_phantom.csv');

%% Plotting  wire 
figure(7);
plot3(  point_cloud_phantom_full(:,1),...
        point_cloud_phantom_full(:, 2),...
        point_cloud_phantom_full(:, 3),...
         'bo', 'MarkerSize', 1)
axis equal;
grid on;
hold on;

%  %% Iterate over the images 

rms_error = [];
local_error = [];
transforms = [];
for i=1:size(centriods,3)
    
     init_trasfrom_matrix = [rotx(180) [0 ;20;-5;];
                            [0    0    0   1  ]];
    
    %Get x, y of image blobbs stored in the table
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

    [tfrom,error, transformed_image_points, l_err, x_y_Z_phantom] = register_pose_grometry(point_cloud_image_initial_trasfrom);

    rms_error =[rms_error; error];
    transforms = [transforms; tfrom*init_trasfrom_matrix];
    local_error = [local_error; l_err];
  
     h = plot3(  transformed_image_points(:, 1),...
                 transformed_image_points(:, 2),...
                 transformed_image_points(:, 3),...
                 'r.', 'MarkerSize' , 5);
     h = plot3(  x_y_Z_phantom(:, 1),...
                 x_y_Z_phantom(:, 2),...
                 x_y_Z_phantom(:, 3),...
                 'rx', 'MarkerSize' , 5);
    hold on 
%   pause
end
                    
xlabel("X",'FontSize', 24);
ylabel("Y",'FontSize', 24);
zlabel("Z",'FontSize', 24);

%%
mean_rms_error = mean(rms_error);
sd = std(rms_error);

mean(local_error)
std(local_error)

csvwrite(fullfile(home_path,"registration_geometry\",trial_no,"registration_poses.csv"), transforms)
end
  
  