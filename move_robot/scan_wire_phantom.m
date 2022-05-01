function scan_wire_phantom(home_path, trial_no)
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
pause
%% Move to start
start = [315.0002  -78.4419  102.0552  -24.6135   90.0002  134.9997]';
move_to_joint_angles(UR,start);
pause
%%
robot_poses = csvread("robot_poses.csv");
robot_poses = reshape(robot_poses',4,3,[]);
robot_poses = permute(robot_poses, [2 1 3]);

%%
poses =[];

for i=1:size(robot_poses,3)
    % Move to pose 
    UR.moveLINToHomRowWise(robot_poses(:,:,i));
    
    % Wait for system to stabalize
    pause(5);
    
    % Capture Image 
    image_capture(US, "final");
    
    % Save pose 
    
    poses = [poses; UR.getExactPositionHomRowWise];
    

end

% robot_poses = csvread("matrix.csv");
% poses = [robot_poses; poses];
writematrix(poses,fullfile(home_path, "robot_poses", trial_no, "robot_poses.csv"));

%% freeze
fprintf(US,'freezeImaging\n');
out = fscanf(US);
disp(out)

end
