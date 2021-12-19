%% Clearning

clear;
close all;
clc;

%% Create a UR3 object

UR = UR3("134.28.45.11", 5005);

%% Create a camera object and connect to server 
US=tcpip('134.28.45.11',4567);
fopen(US);
set(US, 'TimeOut', 1);

%% Choose .xml Profile - B Mode Imaging
fprintf(US,'setParametersXMLFile\n/home/tuhh/git/supra_shearwave/config/configCephasonics.xml\n');
out = fscanf(US);
disp(out);
%image_capture("1")

%% Get Current Position 

current_joint_angles = UR.getJointPositions;

current_hom_matrix = UR.getPositionHomRowWise;

coordinates = current_hom_matrix(:,4);
current_coordinates = Coordinates(coordinates(1),coordinates(2),coordinates(3));

current_speeed = UR.getSpeed;

current_status = UR.getStatus;

start = [0.5522   -0.0703    0.8307  277.8749;
        0.7945   -0.2574   -0.5499  -99.8553;
        0.2525    0.9637   -0.0863  131.4913];

 %%
 UR.moveToHomRowWise(start);
%% Move to Joint Angles

new_joint_angles = [135  -75  125  -45 90   15]';

new_home_matrix = UR.forwardCalc(new_joint_angles);

possible = UR.isPossible(new_home_matrix, UR.getStatus);

if possible ==true
    UR.moveToJointPositions(new_joint_angles);
end

%% Move back to initial position

UR.moveToJointPositions(current_joint_angles);


%% Move to co-ordinates
current_hom_matrix = UR.getPositionHomRowWise;

coordinates = current_hom_matrix(:,4);
current_coordinates = Coordinates(coordinates(1),coordinates(2),coordinates(3));

x = current_coordinates.x + 100;
y = current_coordinates.y + 100;
z = current_coordinates.z + 0;

new_coordinates = Coordinates(x,y,z);

UR.moveToCoordinates(new_coordinates);

%% Move back to initial position

UR.moveToJointPositions(current_joint_angles);

%% Move to homogenous matrix 
current_hom_matrix = UR.getPositionHomRowWise;
new_hom_matrix = current_hom_matrix +1;

possible = UR.isPossible(new_hom_matrix,  UR.getStatus());

if possible==true
    UR.moveToHomRowWise(new_hom_matrix);
end


%% Move back to initial position

UR.moveToJointPositions(current_joint_angles);

%% Move in a straight line
current_hom_matrix = UR.getPositionHomRowWise;
coordinates = current_hom_matrix(:,4); 
straight_line = get_straight_line(coordinates', (coordinates + [20; 20; -40])');
for i = 1:length(straight_line)
   point = straight_line(i,:);
   plot3(point(1), point(2), point(3), "o")
   hold on
   new_cordinates =  Coordinates(point(1),point(2),point(3)); 
   UR.moveToCoordinates(new_coordinates);
end

%% Move back to initial position

UR.moveToJointPositions(current_joint_angles);


%% Move in a square
current_hom_matrix = UR.getPositionHomRowWise;
coordinates = current_hom_matrix(:,4);
square = get_square_coordinates(coordinates(1),coordinates(2),coordinates(3), 100);
for i= 2:length(square)
    point_1 =  square(i-1,:);
    point_2 =  square(i,:);
    straight_line = get_straight_line(point_1, point_2);
    for p = 1:length(straight_line)
        point = straight_line(p,:);
        plot3(point(1),point(2),point(3),'o-')
        hold on;
        new_cordinates =  Coordinates(point(1),point(2),point(3)); 
        UR.moveToCoordinates(new_coordinates);
    end
end


%% Move back to initial position

UR.moveToJointPositions(current_joint_angles);

%% Move in a circle
current_hom_matrix = UR.getPositionHomRowWise;
coordinates = current_hom_matrix(:,4);
circle =  get_circle_coordinates(coordinates(1),coordinates(2),coordinates(3), 50);
for i= 2:length(circle)
   point =  circle(i,:);
   plot3(point(1),point(2),point(3),'o-')
   hold on;
   new_cordinates =  Coordinates(point(1),point(2),point(3)); 
   UR.moveToCoordinatesLIN(new_coordinates);
   
end
        
 %% Move back to initial position

UR.moveToJointPositions(current_joint_angles);

%% Move in  zigzag motion
current_hom_matrix = UR.getPositionHomRowWise;
coordinates = current_hom_matrix(:,4);
zigzag =  get_zigzag_coordinates(coordinates', 20, 80);
for i= 2:length(zigzag)
    point_1 =  zigzag(i-1,:);
    point_2 =  zigzag(i,:);
    straight_line = get_straight_line(point_1, point_2);
    for p = 1:length(straight_line)
        point = straight_line(p,:);
        plot3(point(1),point(2),point(3),'o-')
        hold on;
        new_coordinates =  Coordinates(point(1),point(2),point(3)); 
        UR.moveToCoordinates(new_coordinates);
    end
end

%% Move in  zigzag motion with LIN
current_hom_matrix = UR.getPositionHomRowWise;
save_pose = [current_hom_matrix];
coordinates = current_hom_matrix(:,4);
zigzag =  get_zigzag_coordinates(coordinates', 100, 10);
for i= 2:length(zigzag)
    save_pose = [save_pose; UR.getPositionHomRowWise];
    point =  zigzag(i,:);
    plot3(point(1),point(2),point(3),'o-')
    hold on;
    new_coordinates =  Coordinates(point(1),point(2),point(3)); 
    UR.moveToCoordinatesLIN(new_coordinates);
    
end

save_pose

%% Move in a square with LIN
current_hom_matrix = UR.getPositionHomRowWise;
coordinates = current_hom_matrix(:,4);
square = get_square_coordinates(coordinates(1),coordinates(2),coordinates(3), 50);
for i= 2:length(square)
    point =  square(i,:);
    plot3(point(1),point(2),point(3),'o-')
    hold on;
    new_coordinates =  Coordinates(point(1),point(2),point(3)); 
    UR.moveToCoordinatesLIN(new_coordinates);
    UR.waitUntilRobotMoves();
end
