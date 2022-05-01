clear all
close 
clc

path = "D:\SEM_4\Project\my_files\3D_volume_reconstruction\part\";
%%
AA = csvread("D:\SEM_4\Project\my_files\robot_poses\try_4\error_free\robot_poses_straight.csv");
AA = reshape(AA',4,4,[]);
AA = permute(AA, [2 1 3]);

%%
X = csvread("D:\SEM_4\Project\my_files\Solve_equations\hand_eye_results\6_10.csv");
X = reshape(X',4,4,[]);
Y = X(:,:,2)';
X = X(:,:,1)';
%%

AX =[];
for i = 1:size(AA,3)
    AX(:,:,i) = AA(:,:,i) * X;
end
%%
centriods = readtable("D:\SEM_4\Project\my_files\image_segmentation\processed_images\try_4\straight\centriods.csv");
centriods = table2array(centriods);
centriods = reshape(centriods,12,2,[]);

%% Read Point cloud of wire phantom 
point_cloud_phantom_full = csvread('wire_phantom.csv');

%%
%% Visualization of initial data

figure(1);
title("Initial Data",'FontSize', 24)
for i =1:size(centriods,3)
    image_centriods = centriods(:,:,i);
   
    image_points_3d = [image_centriods(:,1), zeros(12,1) , image_centriods(:,2)];
    transformed_image_points = image_points_3d * AX(1:3,1:3,i) +repmat(AX(1:3,4,i)', 12, 1);  
    cc(:,:,i) = transformed_image_points;
    h = plot3(  transformed_image_points(:, 1),...
                transformed_image_points(:, 2),...
                transformed_image_points(:, 3),...
                'r.', 'MarkerSize' , 5);

    set(h, 'markersize', 5)
    hold on
    
end
legend("z- Wire Phantom", "Centriod of Image blobs obatined from US Image",'Orientation','horizontal', 'Location', 'southoutside','FontSize', 16)
xlabel("X",'FontSize', 24);
ylabel("Y",'FontSize', 24);
zlabel("Z",'FontSize', 24);

    



