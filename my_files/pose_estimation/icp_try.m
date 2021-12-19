clear all
close all
clc

%% Image blob centriods 
centriods = readtable("D:\SEM_4\Project\my_files\image_segmentation\processed_images\try_1\left\centriods.csv");
path_to_images = "D:\SEM_4\Project\my_files\image_segmentation\pre_processing\try_1\left";
n = 12;
%% Read Point cloud of wire phantom 
point_cloud_phantom_full = csvread('wire_phantom.csv');
%% Initial Rotation Matrix 
init_trasfrom_matrix = [rotx(180) [5;25;90;];
                        [0    0    0   1  ]];
init_trasfrom = rigid3d(init_trasfrom_matrix');

      
% Get conversion factor from pixel to mm 
scale_matrix = get_pixel_to_mm_conversion_factor(path_to_images);

%% Blobs of 1st image    
image_centriods = centriods(:,11:12);
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

%% Create point cloud objects and trasfrom to initial pose 
image_point_cloud_object = pointCloud(point_cloud_image_initial_trasfrom);
phantom_point_cloud_object =  pointCloud(point_cloud_phantom_full);

%% Visualize phantom and initial transformation
figure(1);
pcshow(phantom_point_cloud_object); 
hold on;
pcshow(image_point_cloud_object, 'MarkerSize', 100); 
title('Intial Data')
hold off

%% Approach 1 - point to point method

% applying simpe ICP algorithm
tform = pcregistericp(image_point_cloud_object,phantom_point_cloud_object,'MaxIterations',100);

% rotating the image points 
transfromed_point_cloud = pctransform(image_point_cloud_object,tform);

figure(2) ;
pcshow(phantom_point_cloud_object); 
hold on;
pcshow(transfromed_point_cloud, 'MarkerSize', 100); 
title('Data after trasfroming')


%% Approcach 2 - point to plane 
t = [1 0 0 0;
     0 1 0 0;
     0 0 1 0;
     1 1 1 1];

init =  rigid3d(t);
 
% Apply icp
tform = pcregistericp(image_point_cloud_object, ...
                      phantom_point_cloud_object,...
                      'MaxIterations',100,...
                      'Metric','pointToPlane',...
                      'InitialTransform', init  );

% rotating the image points 
transfromed_point_cloud = pctransform(image_point_cloud_object,tform);

figure(2) ;
pcshow(phantom_point_cloud_object); 
hold on;
pcshow(transfromed_point_cloud, 'MarkerSize', 100); 
title('Data after trasfroming')
%% Approach 3 
% need to traspose the data matrices 
x = 170;
% point_cloud_phantom = point_cloud_phantom_full( (x*12)+1:(x+1)*12,:)';
point_cloud_phantom = point_cloud_phantom_full';
point_cloud_image_initial_trasfrom_transpose = point_cloud_image_initial_trasfrom';
%% Run ICP (standard settings)
[Ricp Ticp ER t] = icp(point_cloud_phantom, point_cloud_image_initial_trasfrom_transpose, 300,'Minimize', 'point' );
% Transform data-matrix using ICP result
Dicp = Ricp * point_cloud_image_initial_trasfrom_transpose + repmat(Ticp, 1, n);
% Plot model points blue and transformed points red
figure(1);
subplot(2,2,1);
plot3(point_cloud_phantom(1,:),point_cloud_phantom(2,:),point_cloud_phantom(3,:),'bo', 'MarkerSize', 1);
hold on;
plot3(point_cloud_image_initial_trasfrom_transpose(1,:),point_cloud_image_initial_trasfrom_transpose(2,:),point_cloud_image_initial_trasfrom_transpose(3,:),'rx');
hold off;
axis equal;
xlabel('x'); ylabel('y'); zlabel('z');
title('Red: z=sin(x)*cos(y), blue: transformed point cloud');
% Plot the results
subplot(2,2,2);
plot3(point_cloud_phantom(1,:),point_cloud_phantom(2,:),point_cloud_phantom(3,:),'bo','MarkerSize', 1)
hold on;
plot3(Dicp(1,:),Dicp(2,:),Dicp(3,:),'rx');
hold off;
axis equal;
xlabel('x'); ylabel('y'); zlabel('z');
title('ICP result');
% Plot RMS curve
subplot(2,2,[3 4]);
plot(0:300,ER,'--x');
xlabel('iteration#');
ylabel('d_{RMS}');
legend('bruteForce matching');
title(['Total elapsed time: ' num2str(t(end),2) ' s']);

%% Run ICP (fast kDtree matching and extrapolation)

[Ricp Ticp ER t] = icp(point_cloud_phantom, point_cloud_image_init_trasfrom, 15, 'Matching', 'kDtree', 'Extrapolation', true, 'Minimize', 'point');
% Transform data-matrix using ICP result
Dicp = Ricp * point_cloud_image_init_trasfrom + repmat(Ticp, 1, n);
% Plot model points blue and transformed points red
figure(1);
subplot(2,2,1);
plot3(point_cloud_phantom(1,:),point_cloud_phantom(2,:),point_cloud_phantom(3,:),'bo', 'MarkerSize', 1);
hold on;
plot3(point_cloud_image_init_trasfrom(1,:),point_cloud_image_init_trasfrom(2,:),point_cloud_image_init_trasfrom(3,:),'r.');
hold off;
axis equal;
xlabel('x'); ylabel('y'); zlabel('z');
title('Red: z=sin(x)*cos(y), blue: transformed point cloud');
% Plot the results
subplot(2,2,2);
plot3(point_cloud_phantom(1,:),point_cloud_phantom(2,:),point_cloud_phantom(3,:),'bo','MarkerSize', 1)
hold on;
plot3(Dicp(1,:),Dicp(2,:),Dicp(3,:),'r.');
hold off;
axis equal;
xlabel('x'); ylabel('y'); zlabel('z');
title('ICP result');
% Plot RMS curve
subplot(2,2,[3 4]);
plot(0:15,ER,'--x');
xlabel('iteration');
ylabel('d_{RMS}');
legend('kDtree matching and extrapolation');
title(['Total elapsed time: ' num2str(t(end),2) ' s']);


%% Approach 3 - Sending 1 plane of the phantom at 1st and computeing the match 
% then computing the error between the points 
% Using the trasformation with least error. This one fails as well 
r =  [];
error = [];
point_cloud_phantrom_traspose = point_cloud_phantom_full';

for i= 1:12:size(point_cloud_phantom_full, 1)
    point_cloud_phantom_plane = point_cloud_phantom_full(i:i+11, :)';
    [Ricp Ticp ER t] = icp(point_cloud_phantom_plane, point_cloud_image_init_trasfrom, 15);
    % Transform data-matrix using ICP result
    Dicp = Ricp * point_cloud_image_init_trasfrom + repmat(Ticp, 1, n);
 
    t = [Ricp Ticp];
    r = [r; t];
    dist= sqrt(((point_cloud_phantom_plane(1,:)-Dicp(1,:)).^2)...
        + ((point_cloud_phantom_plane(2,:)-Dicp(2,:)).^2)...
        + ((point_cloud_phantom_plane(3,:)-Dicp(3, :)).^2));
    min_dist=mean(dist);
    error = [error; min_dist];
    

end

[min_error, I] = min(error);
disp(min_error);

i = (I*4)+1;
T = r(i: i+2, :);
Ticp = T(:,4);
Dicp =  T(1:3,1:3);

Dicp = Ricp * point_cloud_image_init_trasfrom + repmat(Ticp, 1, n);

figure;
subplot(2,2,1);
plot3(point_cloud_phantrom_traspose(1,:),point_cloud_phantrom_traspose(2,:),point_cloud_phantrom_traspose(3,:),'bo', 'MarkerSize', 1)
hold on 
plot3(point_cloud_image_init_trasfrom(1,:),point_cloud_image_init_trasfrom(2,:),point_cloud_image_init_trasfrom(3,:),'r.');
hold off
axis equal;
xlabel('x'); ylabel('y'); zlabel('z');
title('Red: z=sin(x)*cos(y), blue: transformed point cloud');
% Plot the results
subplot(2,2,2);
plot3(point_cloud_phantrom_traspose(1,:),point_cloud_phantrom_traspose(2,:),point_cloud_phantrom_traspose(3,:),'bo','MarkerSize', 1);
hold on 
plot3(Dicp(1,:),Dicp(2,:),Dicp(3,:),'r.')
hold off
axis equal;
xlabel('x'); ylabel('y'); zlabel('z');
title('ICP result');
% Plot RMS curve
subplot(2,2,[3 4]);
plot(0:15,ER,'--x');
xlabel('iteration');
ylabel('d_{RMS}');
legend('kDtree matching and extrapolation');
title(['Total elapsed time: ' num2str(t(end),2) ' s']);
%% Using 1 plane at a time and computing error of the mean and chooing points wilth least error

r =  [];
error = [];
point_cloud_phantrom_traspose = point_cloud_phantom_full';

figure(5)
plot3(point_cloud_phantom_full(:,1),point_cloud_phantom_full(:,2),point_cloud_phantom_full(:,3), 'b.', 'MarkerSize', 1);
hold on;

for i= 1:12:size(point_cloud_phantom_full, 1)
    % Creat point cloud of just one plane 
    point_cloud_phantom = point_cloud_phantom_full(i:i+11, :)';
    
    % apply icp
    [Ricp Ticp ER t] = icp(point_cloud_phantom, point_cloud_image_init_trasfrom, 15);
    
    % Transform data-matrix using ICP result
    Dicp = Ricp * point_cloud_image_init_trasfrom + repmat(Ticp, 1, n);
    plot3(Dicp(1,:),Dicp(2,:),Dicp(3,:), 'r.');
    % Transformations 
    t = [Ricp Ticp];
    r = [r; t];
    mid_points_image = Dicp(:,2:3:end)';
    mid_points_phantom = point_cloud_phantom(:,5:8)';
    %mid_points_image = [Dicp(:,3:3:end)  Dicp(:,2:3:end) Dicp(:,1:3:end) ]';
    %mid_points_image = [mid_points_image(:,1) mid_points_image(:,3)];
    
    %mid_points_phantom =point_cloud_phantom';
    %mid_points_phantom = [mid_points_phantom(:,1) mid_points_phantom(:,3)];
    dist = pdist2(mid_points_image, mid_points_phantom);
    relevant = diag(dist);
    dist = mean(relevant);

    % get mean of the plane 
    %mean_pointcloud_plane = mean(point_cloud_phantom');
    %mean_image_points = mean(Dicp');
    %dist = pdist2(mean_pointcloud_plane,mean_image_points);
    error = [error; dist];
    

end

hold off 

% get min error and index
[min_error, Index] = min(error);

point_cloud_phantom = point_cloud_phantom_full(Index:Index+11, :)';
    
% apply icp
[Ricp Ticp ER t] = icp(point_cloud_phantom, point_cloud_image_init_trasfrom, 15);

% Transform data-matrix using ICP result
Dicp = Ricp * point_cloud_image_init_trasfrom + repmat(Ticp, 1, n);

    
figure;
title("Point Cloud Registration using ICP",'FontSize', 24)
subplot(1,2,1);
plot3(  point_cloud_phantrom_traspose(1,:),...
        point_cloud_phantrom_traspose(2,:),...
        point_cloud_phantrom_traspose(3,:),...
        'bo', 'MarkerSize', 1)
hold on 
plot3(  point_cloud_phantom(1,:),...
        point_cloud_phantom(2,:),...
        point_cloud_phantom(3,:),...
        'rx', 'MarkerSize', 1)
hold on 
h = plot3(  point_cloud_image_init_trasfrom(1,:),...
        point_cloud_image_init_trasfrom(2,:),...
        point_cloud_image_init_trasfrom(3,:),...
        'r.', 'MarkerSize' , 5);
set(h, 'markersize', 20)
hold off
axis equal;
xlabel('x','FontSize', 24); ylabel('y','FontSize', 24); zlabel('z','FontSize', 24);
title('Initial Data','FontSize', 24);


% Plot the results
subplot(1,2,2);
plot3(  point_cloud_phantrom_traspose(1,:),...
        point_cloud_phantrom_traspose(2,:),...
        point_cloud_phantrom_traspose(3,:),...
        'bo','MarkerSize', 1);
hold on 
j = plot3(Dicp(1,:),Dicp(2,:),Dicp(3,:),'r.',  'MarkerSize' , 5);
set(j, 'markersize', 20)
hold off
axis equal;
xlabel('x','FontSize', 24); ylabel('y','FontSize', 24); zlabel('z','FontSize', 24);
title('ICP Result', 'FontSize', 24);

% % Plot RMS curve
% subplot(2,2,[3 4]);
% plot(0:15,ER,'--x');
% xlabel('iteration');
% ylabel('d_{RMS}');
% legend('kDtree matching and extrapolation');
% title(['Total elapsed time: ' num2str(t(end),2) ' s']);
