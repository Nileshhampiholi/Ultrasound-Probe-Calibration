clear all
close all
clc

%% Image blob centriods 
centriods = readtable("D:\SEM_4\Project\my_files\image_segmentation\processed_images\try_1\straight\centriods.csv");
path_to_images = "D:\SEM_4\Project\my_files\image_segmentation\pre_processing\try_1\straight";

%% Read Point cloud of wire phantom 
point_cloud_phantom_full = csvread('wire_phantom.csv');
%% Initial Rotation Matrix 
init_trasfrom_matrix = [rotx(180) [5;25;90;];
                        [0    0    0   1  ]];
init_trasfrom = rigid3d(init_trasfrom_matrix');

      
% Get conversion factor from pixel to mm 
scale_matrix = get_pixel_to_mm_conversion_factor(path_to_images);

%% Blobs of 1st image    
image_centriods = centriods(:,1:2);
image_centriods = image_centriods{:,:};

% Convert centriods from pixels to mm
image_centriods_scaled = image_centriods*scale_matrix;

% Conver image points for 2d to 3d  
point_cloud_image_scaled = [image_centriods_scaled(:,1) zeros(size(image_centriods_scaled, 1),1) image_centriods_scaled(:,2)];


point_cloud_image_re_arranged = sortrows(point_cloud_image_scaled,1);
point_cloud_image_re_arranged = [sortrows(point_cloud_image_re_arranged(1:4,:),3);
                                   sortrows(point_cloud_image_re_arranged(5:8,:),3);
                                   sortrows(point_cloud_image_re_arranged(9:12,:),3)];
 
point_cloud_image_initial_trasfrom =point_cloud_image_re_arranged * init_trasfrom.Rotation +repmat(init_trasfrom.Translation, 12, 1);                              

%% Number of point in image 
n = 12;

%% Visualization of initial data

figure(1);

title("Point Cloud Registration using ICP",'FontSize', 24)
plot3(  point_cloud_phantom_full(:,1),...
        point_cloud_phantom_full(:, 2),...
        point_cloud_phantom_full(:, 3),...
        'bo', 'MarkerSize', 1)
grid on;
hold on 

h = plot3(  point_cloud_image_initial_trasfrom(:, 1),...
            point_cloud_image_initial_trasfrom(:, 2),...
            point_cloud_image_initial_trasfrom(:, 3),...
            'r.', 'MarkerSize' , 5);

set(h, 'markersize', 20)
hold off
axis equal;
xlabel('x','FontSize', 24); ylabel('y','FontSize', 24); zlabel('z','FontSize', 24);
subtitle('Initial Data','FontSize', 16);
legend('Z-Wire Phantom', 'Image Blobs after Initial Trasfromation','FontSize', 16)

%%
error = [];
trasfrom = [];

for i= 1:12:size(point_cloud_phantom_full, 1)
    % Creat point cloud of just one plane 
    point_cloud_phantom = point_cloud_phantom_full(i:i+11, :)';
    
    % apply icp
    [Ricp Ticp ER t] = icp(point_cloud_phantom, point_cloud_image_initial_trasfrom', 30);
    
    % Transform data-matrix using ICP result
    Dicp = Ricp * point_cloud_image_initial_trasfrom' + repmat(Ticp, 1, n);
   
    % Transformations 
    tform = rigid3d(Ricp, Ticp');
    trasfrom = [trasfrom; tform];
    
    % Compute distance error between trasfromed image points and phantom
    % points  and copute the mean 
    dist = pdist2(point_cloud_phantom', Dicp');
    relevant = diag(dist);
    dist = mean(relevant);

    error = [error; dist];

end

[min_error, index] = min(error);
disp(min_error)
disp(index)

tform = trasfrom(index);

final_transform  = tform.Rotation * point_cloud_image_initial_trasfrom' + repmat(tform.Translation', 1, n);
final_transform = final_transform';

index
%% Visualization of result
figure(2);
title("Point Cloud Registration using ICP",'FontSize', 24)
subplot(1,2,1);
plot3(  point_cloud_phantom_full(:,1),...
        point_cloud_phantom_full(:, 2),...
        point_cloud_phantom_full(:, 3),...
        'bo', 'MarkerSize', 1)
grid on;
hold on 

h = plot3(  point_cloud_image_initial_trasfrom(:, 1),...
            point_cloud_image_initial_trasfrom(:, 2),...
            point_cloud_image_initial_trasfrom(:, 3),...
            'r.', 'MarkerSize' , 5);

set(h, 'markersize', 20)
hold off
axis equal;
xlabel('x','FontSize', 24); ylabel('y','FontSize', 24); zlabel('z','FontSize', 24);
title('Initial Data','FontSize', 16);
%legend('Z-Wire Phantom', 'Image Blobs after Initial Trasfromation','FontSize', 14)


subplot(1,2,2);
plot3(  point_cloud_phantom_full(:,1),...
        point_cloud_phantom_full(:, 2),...
        point_cloud_phantom_full(:, 3),...
        'bo', 'MarkerSize', 1)
grid on;
hold on 

h = plot3(  final_transform(:, 1),...
            final_transform(:, 2),...
            final_transform(:, 3),...
            'r.', 'MarkerSize' , 5);

set(h, 'markersize', 20)
hold off
axis equal;
xlabel('x','FontSize', 24); ylabel('y','FontSize', 24); zlabel('z','FontSize', 24);
title('ICP Result','FontSize', 16);
%legend('Z-Wire Phantom', 'Image Blobs after Trasfromation','FontSize', 14)


