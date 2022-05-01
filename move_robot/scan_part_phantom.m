function scan_part_phantom(home_path)
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
home = [315 -90 90 -30 90 135]';
move_to_joint_angles(UR,home);

%% Move to start 
start = [315.0002  -78.4419  102.0552  -24.6135   90.0002  134.9997]';
move_to_joint_angles(UR,start);


%% Move to co-ordinates
current_hom_matrix = UR.getPositionHomRowWise;

coordinates = current_hom_matrix(:,4);
current_coordinates = Coordinates(coordinates(1),coordinates(2),coordinates(3));


x = current_coordinates.x -0;
y = current_coordinates.y -0;
z = current_coordinates.z +3;

new_coordinates = Coordinates(x,y,z);
UR.moveToCoordinates(new_coordinates);

%% Straight
save_pose = move_capture(120, UR, US, "part_orthogonal");
pause(2);
move_to_joint_angles(UR,start);
writematrix(save_pose,'part_orthogonal.csv');


%% Move to co-ordinates
current_hom_matrix = UR.getPositionHomRowWise;

coordinates = current_hom_matrix(:,4);
current_coordinates = Coordinates(coordinates(1),coordinates(2),coordinates(3));

x = current_coordinates.x -5;
y = current_coordinates.y -5;
z = current_coordinates.z +5;

new_coordinates = Coordinates(x,y,z);
UR.moveToCoordinates(new_coordinates);

%% Rotate wrist
joint_angle = UR.getJointPositions;
new_joint_angles = joint_angle + [0 0 0 0 0 -5]';
move_to_joint_angles(UR, new_joint_angles)


%% Left
save_pose = move_capture(120, UR, US, "part_left");
pause(2);
move_to_joint_angles(UR,start);
writematrix(save_pose,'part_right.csv');

%% Move to co-ordinates
current_hom_matrix = UR.getPositionHomRowWise;

coordinates = current_hom_matrix(:,4);
current_coordinates = Coordinates(coordinates(1),coordinates(2),coordinates(3));

x = current_coordinates.x +5;
y = current_coordinates.y +5;
z = current_coordinates.z +5;

new_coordinates = Coordinates(x,y,z);
UR.moveToCoordinates(new_coordinates);

%% Rotate wrist
joint_angle = UR.getJointPositions;
new_joint_angles = joint_angle + [0 0 0 0 0 5]';
move_to_joint_angles(UR, new_joint_angles)


%% Right
save_pose = move_capture(120, UR, US, "part");
pause(2);
move_to_joint_angles(UR,start);
writematrix(save_pose,fullfile(home_path, "robot_poses", "part", 'part.csv'));


%% freeze
fprintf(US,'freezeImaging\n');
out = fscanf(US);
disp(out)
end
