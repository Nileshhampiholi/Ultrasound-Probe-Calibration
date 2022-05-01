%% Clear 
clear;
close all; 
clc;

%% Define variables

%  Home path 
home_path = pwd;

% If new recording is done add it in trail_7 in seprate folader
trial_no ='try_6';

% Displays all the images 
show_image = false;

% ICP method or geometric method 
method =1;

% Origin at the wire or  structure 
origin_at_1st_strand = true;

%% Move and Record Data 

% Scan the wire phantom from different poses
% Requires the external code to connect to Robot and and US 
% Robot moves to pre deined poses. 
% Moves to home positing place the wire phantom accordingly. Press enter to
% continue
% Moves to start position adjust the phantom to besed on visual in the US.
% Press enter to contine 
% Captures about 130 images.

scan_wire_phantom(home_path, trial_no);
disp('Move the raw data to --> (.\Poject Arbeit\raw_data_to_US_image\try_no) and hit enter')
pause;
    
%% Convert Raw Data to JPG
% Converts the raw data to jpg images 
tic
main_raw_to_jpg(trial_no, show_image, home_path);
toc

%% Segment Images
tic    
segment_images(trial_no, show_image, home_path);
toc
%% Get segmentation error
[mean_segmentation_error, sd_segmentation] = segmentation_error(trial_no, home_path);
 disp(['Mean deviation for segmentation in X and Z direction = ', mat2str(mean_segmentation_error)]);

 disp(['SD for segmentation in X and Z direction = ',  mat2str(sd_segmentation)]);
 
%% Generate virtual N-wire phantom

get_z_wire_phantom_points(origin_at_1st_strand, home_path);
 
 %% Registration ICP
 tic
[mean_localization_error, sd_localization] = get_sensor_to_fudicial_pose(trial_no,origin_at_1st_strand, home_path);
 
disp(['Mean localization error for all 12 points cobined using icp = ', num2str(mean_localization_error)]);
disp(['Mean localization error for all 12 points cobined using icp = ', num2str(sd_localization)]);
toc
 %% Registration using geometry 
 
[mean_localization_error, sd_localization] = get_sensor_to_fudicial_pose_geometry(trial_no,home_path);
disp(['Mean localization error for all 12 points cobined using geometric method = ', num2str(mean_localization_error)]);
disp(['Mean localization error for all 12 points cobined using geometric method = ', num2str(sd_localization)]);

%% Remove poses for  images where 12 points are not detected
% Discard the poses and images where 12 points are not detected.
remove_errors(trial_no,home_path)

%% Solve hand eye probelem
% Solves AX= YB problem based on the QR24 Algorithm
minObs = 25; 
validatSet = 80;
jumpObs = 20;

solve_hand_eye_problem(trial_no, method, minObs,validatSet, jumpObs, home_path)


%% Scan Part phantom for 3D Reconstruction 
% Scan part phantom
scan_part_phantom(home_path);

%% For the scanned part reonstruct the surface

main_3d_reconstruction(show_image, home_path)
