clear all
close all 
clc

%% Read al files 

% Robot Poses 
errors = csvread("D:\SEM_4\Project\my_files\image_segmentation\processed_images\try_1\straight\errors.csv");

robot_poses = csvread("D:\SEM_4\Project\my_files\robot_poses\try_1\image_poses_straight_50.csv");
robot_poses = robot_poses(4:end,:);
AA = [];
for i = 1:3:size(robot_poses,1)  
    if any(errors(:)==(i+2)/3)
        continue
    else
        AA = [AA ;  [robot_poses(i:i+2,:); 0 0 0 1]];
    end
   
        
end
% Corresponding pose estimation
BB = csvread("D:\SEM_4\Project\my_files\image_segmentation\processed_images\try_1\straight\transforms_planewise.csv");

%% Solve Caliberation - QR24 method

[X_q, Y_q] = QR24(AA,BB);

%% Solve Caliberation = shiu method 

X_q

Y_q
