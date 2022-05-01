function main_3d_reconstruction(show_image,home_path)

%% Variables
trial_1 = 'part\top';
trial_2 = 'part\left';
trial_3 = 'part\right';

path_to_save = fullfile(home_path,'3D reconstruction\');

%% Convert raw image to jpg

% main_raw_to_jpg(trial_1, show_image, fullfile(path_to_save, trial_1));
% main_raw_to_jpg(trial_2, show_image, fullfile(path_to_save, trial_2));
% main_raw_to_jpg(trial_3, show_image, fullfile(path_to_save, trial_3));

%% Get point clouds 

point_cloud_top = generate_point_cloud( fullfile(path_to_save, trial_1), show_image);
% point_cloud_left = generate_point_cloud( fullfile(path_to_save, trial_2), show_image);
% point_cloud_right = generate_point_cloud( fullfile(path_to_save, trial_3), show_image);

%% Read the caliberation matrix 

X = csvread(home_path,"solve_ax_y_b\try_6.csv");
X = reshape(X',4,4,[]);
Y = X(:,:,2);
X = X(:,:,1);

%% Read Robot Poses and compute AX
path = fullfile(home_path,"robot_poses\part");
robot_poses = csvread(fullfile(path, "part.csv"));
AA = [];
AX = [];
count = 1;
for i = 1:3:size(robot_poses,1)
    A = [robot_poses(i:i+2,:); [0 0 0 1]];
    AA(:,:,count) = A;
    AX = [AX; (A'*X)];
    count = count +1;
end

%% Transfrom the point cloud to location given bz AX  trasfroms the point clound into robot base cordinate system

point_clouds = point_cloud_top;
transfromed_point_cloud = [];
count = 4;
for i=1:size(point_clouds,1)
%     tfrom = affine3d([rotx(0), [0; 0; 0]; [0 i*0.25 0 1]]);
%     tfrom = affine3d(AX(count:count+3,:));
    tfrom = affine3d([rotx(180), [0; 0; 0]; AX(count,1:4)]);
    count = count+4;   
    trasfromed = pctransform(point_clouds(i), tfrom);  
    transfromed_point_cloud = [transfromed_point_cloud;trasfromed];
end
  
%% Merge all sclices into into a single 
pt = transfromed_point_cloud(1);

for i =2:length(transfromed_point_cloud)
    pt = pcmerge(pt, transfromed_point_cloud(i),1) ;
end

%%
figure(12)
points = pt.Location;
plot3(points(:,1), points(:,2), points(:,3), ".-")
tri = delaunay(points(:,1), points(:,2));
plot(points(:,1), points(:,2),'.')
[r,c] = size(tri);
h = trisurf(tri,points(:,1), points(:,2), points(:,3));
axis vis3d
l = light('Position',[-50 -15 29]);
set(gca,'CameraPosition',[208 -50 687])
lighting phong
shading interp
xlabel('X in mm', 'FontSize', 24)
ylabel('Y in mm','FontSize',  24)
zlabel('Z in mm', 'FontSize', 24)
set(findall(gcf, '-property','FontSize'), 'FontSize', 15)
end
