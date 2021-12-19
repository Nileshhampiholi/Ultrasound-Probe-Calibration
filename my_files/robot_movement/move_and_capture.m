%% Clearning

clear;
close all;
clc;


%% Create a UR3 object

UR = UR3("134.28.45.11", 5005);

%% Create a camera object and connect to server 
US=tcpip('134.28.45.11',4567);
fopen(US);
set(US, 'TimeOut', 5);
%% Unfreeze
fprintf(US,'unfreezeImaging\n');
out = fscanf(US);
disp(out);
%% Move to home 
home = [130 -90 90 -30 90 135]';
move_to_joint_angles(UR,home);

%% Move to start
start = [130 -79 101 -23 90 135]';
move_to_joint_angles(UR,start);
%% Rotate along x 
alpha_postive = [130.7965 -78 109.4372 -45 90.7846 134.8617]';
move_to_joint_angles(UR, alpha_postive)

%% FRONT
alpha_negative = [130.9908 -67.4904 80.5189 -3.0274 90.9754 135.1711]';
% move_to_joint_angles(UR, alpha_negative);

%% ROTATE ALONG Z LEFT
gama_positive = [122.1724 -78.1927 101.1809 -26.1764 62.1837 135.4615]';
% move_to_joint_angles(UR,gama_positive);

%% rOTATE ALONG Z RIGHT 
gama_negative = [139.0288 -72.2964 93.1463 -24.0749 119.0159 134.4612]';
% move_to_joint_angles(UR,gama_negative);

%%
beta_positive = [136.1268 -76.4526 98.0749 -22.6287 96.1263 124.8922]';
% move_to_joint_angles(UR, beta_positive);

%%
beta_negative = [124.6888 -80.5579 103.1891 -23.6362 84.6895 145.0918]';
% move_to_joint_angles(UR, beta_negative);


%% Move to co-ordinates
current_hom_matrix = UR.getPositionHomRowWise;

coordinates = current_hom_matrix(:,4);
current_coordinates = Coordinates(coordinates(1),coordinates(2),coordinates(3));

x = current_coordinates.x + 0;
y = current_coordinates.y + 0;
z = current_coordinates.z + 1;

new_coordinates = Coordinates(x,y,z);
UR.moveToCoordinates(new_coordinates);


%% Move and capture
%% Unfreeze
fprintf(US,'unfreezeImaging\n');
out = fscanf(US);
disp(out);
%% Straight done
move_to_joint_angles(UR,start);
pause(2);
save_pose = move_capture(25, UR, US, "straight");
pause(2);
move_to_joint_angles(UR,start);
writematrix(save_pose,'robot_poses_straight.csv');

%% Rotate along y  negative  done
% move_to_joint_angles(UR, beta_negative);
pause(5);
save_pose = move_capture(25, UR, US, "beta_negative");
pause(5);
move_to_joint_angles(UR,start);
pause(5);
writematrix(save_pose,'robot_poses_beta_negative.csv');
%% Rotate along y positive  done
% move_to_joint_angles(UR, beta_positive);
pause(5);
save_pose = move_capture(25, UR, US,  "beta_positive");
pause(5);
move_to_joint_angles(UR,start);
pause(5);
writematrix(save_pose,'robot_poses_beta_positive.csv');
%% Rotate along z positive done
% move_to_joint_angles(UR,gama_positive);
pause(5);
save_pose = move_capture(25, UR, US, "gama_positive");
pause(5);
move_to_joint_angles(UR,start);
pause(5);
writematrix(save_pose,'robot_poses_gama_positive.csv');
%% Rotate along z negative  done
% move_to_joint_angles(UR,gama_negative);
pause(2);
save_pose = move_capture(25, UR, US,  "gama_negative");
pause(2);
move_to_joint_angles(UR,start);
pause(2);
writematrix(save_pose,'robot_poses_gama_negative.csv');
%% Rotate along x axis done
% move_to_joint_angles(UR,alpha_negative);
pause(2);
save_pose = move_capture(25, UR, US, "alpha_negative");
pause(2);
move_to_joint_angles(UR,start);
pause(2);
writematrix(save_pose,'robot_poses_alpha_negative.csv');
%% Rotate along x axis
% move_to_joint_angles(UR,alpha_postive);
pause(2);
save_pose = move_capture(25, UR, US,  "alpha_postive");
pause(2);
move_to_joint_angles(UR,start);
pause(2);
writematrix(save_pose,'robot_poses_alpha_postive.csv');
   

%% freeze
fprintf(US,'freezeImaging\n');
out = fscanf(US);
disp(out)
