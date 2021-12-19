clear all
close all
clc

%% Image blob centriods 
centriods = readtable("D:\SEM_4\Project\my_files\image_segmentation\processed_images\try_1\straight\centriods.csv");
path_to_images = "D:\SEM_4\Project\my_files\image_segmentation\pre_processing\try_1\straight";

%% Read Point cloud of wire phantom 
point_cloud_phantom_full = csvread('wire_phantom.csv');

%% Variables
transforms =[];
min_er = [];
%% Initial Rotation Matrix 
init_trasfrom_matrix = [rotx(180) [5;25;90;];
                        [0    0    0   1  ]];
init_trasfrom = rigid3d(init_trasfrom_matrix');

      
% Get conversion factor from pixel to mm 
scale_matrix = get_pixel_to_mm_conversion_factor(path_to_images);

%% Visualization of initial data

figure(1);
title("Initial Data",'FontSize', 24)
plot3(  point_cloud_phantom_full(:,1),...
        point_cloud_phantom_full(:, 2),...
        point_cloud_phantom_full(:, 3),...
        'bo', 'MarkerSize', 1)
axis equal;
grid on;
hold on 
for i =1:2:size(centriods,2)
    %% Get image points ready for ICP
    % Get x, y of image blobbs stored in the table
    image_centriods = centriods(:,i:i+1);
    % Convert to matrix from tbale 
    image_centriods = image_centriods{:,:};
    image_centriods = image_centriods*scale_matrix;
    point_cloud_image = [image_centriods(:,1) zeros(size(image_centriods, 1),1)+(i*0.5) image_centriods(:,2)];
    h = plot3(  point_cloud_image(:, 1),...
                point_cloud_image(:, 2),...
                point_cloud_image(:, 3),...
                'r.', 'MarkerSize' , 5);

    set(h, 'markersize', 5)
    
end
legend("z- Wire Phantom", "Centriod of Image blobs obatined from US Image",'Orientation','horizontal', 'Location', 'southoutside','FontSize', 16)
xlabel("X",'FontSize', 24);
ylabel("Y",'FontSize', 24);
zlabel("Z",'FontSize', 24);
hold off
    

%% Number of point in image 
n = 12;

%% Visualisation of ICP results
figure(2);
title("ICP Results",'FontSize', 24)
plot3(  point_cloud_phantom_full(:,1),...
        point_cloud_phantom_full(:, 2),...
        point_cloud_phantom_full(:, 3),...
        'bo', 'MarkerSize', 1)
axis equal;
grid on;
hold on 
%% Iterte over Images 
errors =[];
for i =1:2:size(centriods,2)
    disp((i+1)/2)
    %% Get image points ready for ICP
    % Get x, y of image blobbs stored in the table
    image_centriods = centriods(:,i:i+1);
    % Convert to matrix from tbale 
    image_centriods = image_centriods{:,:};

    %Convert centriods from pixels to mm
    image_centriods_scaled = image_centriods*scale_matrix;

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
    point_cloud_image_initial_trasfrom =point_cloud_image_re_arranged * init_trasfrom.Rotation +repmat(init_trasfrom.Translation, 12, 1);      
    
    %% Apply ICP plane wise for every image
    %[trasfromation, point_cloud_image_transfromed, min_error] = icp_plane_wise(point_cloud_phantom_full, point_cloud_image_initial_trasfrom,n);
     
    %% Aplly Distance ratio based ICP
    [trasfromation,point_cloud_image_transfromed, min_error] = distance_ratio_phantom(point_cloud_phantom_full, point_cloud_image_initial_trasfrom);

    min_er = [min_er; min_error];
    if min_error > 1.0
        index = (i+1)/2;
        errors = [errors; index];
    
    else
    %% Visualise the Tansformed Points 
        h = plot3(  point_cloud_image_transfromed(:, 1),...
                    point_cloud_image_transfromed(:, 2),...
                    point_cloud_image_transfromed(:, 3),...
                    'r.', 'MarkerSize' , 5);
        tfrom = [trasfromation.Rotation trasfromation.Translation';
                 0   0 0 1] *  [rotx(180) [5;25;90;];[0    0    0   1  ]];
        transforms = [transforms; tfrom];
        set(h, 'markersize', 10)
    end

end

xlabel("X",'FontSize', 24);
ylabel("Y",'FontSize', 24);
zlabel("Z",'FontSize', 24);
legend("Z-Wire Phantom", "Estimated Pose",'Orientation','horizontal', 'Location', 'southoutside','FontSize', 16)

min_er
mean(min_er)
csvwrite("D:\SEM_4\Project\my_files\image_segmentation\processed_images\try_1\straight\transforms_planewise.csv", transforms)

