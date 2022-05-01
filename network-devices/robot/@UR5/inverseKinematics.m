function thetas = inverseKinematics(H, config)
%inverseKinematics Gets joint angles of UR5 according to homogeneous matrix H.
%   H is the homogeneous matrix, which represents the transformatiion from
%   frame 0 to frame 6. Config is the lefty|righty, up|down and flip|noflip
%   configuration. It is necessary in order to get a unique solution of
%   joints.

% Devanit-Hartenberg values for the UR5 given in millimeters since the robserver
% is using millimeters.
% alphas are already in A matrices
d = UR5.dh.ds;
a = UR5.dh.as;

% Solving the inverse kinematics is to find theta1. To do so, we must first
% find the location of the 5th coordinate frame with respect to the base
% frame, P0to5.
% We can do so by translating by d6 in the negative z direction from the 6th
% frame.

P0to5 = ([H; [0 ,0 ,0, 1] ] * [0;0;-d(6);1]) - [0;0;0;1] ;

cos_term_t0 = d(4) / sqrt(P0to5(1)^2 + P0to5(2)^2);

if (abs(cos_term_t0)>1)
    cos_term_t0 = 1;
end

% The two solutions for theta1 correspond to the shoulder being either "left" or "right".
if config.lefty
    thetas(1) = atan2( P0to5(2),P0to5(1)) - acos( cos_term_t0 ) + pi/2;
else
    thetas(1) = atan2( P0to5(2),P0to5(1)) + acos( cos_term_t0 ) + pi/2;
end
% Knowing theta1, we can now solve fortheta5. The solutions correspond to the wrist being "down"
% and "up".
% Two possible solutions for theta 5 (disregarding theta1)
if config.flip
    thetas(5) = acos(( H(1,4) * sin(thetas(1)) - H(2,4)*cos(thetas(1)) -  d(4) ) / d(6));
else
    thetas(5) = -acos(( H(1,4) * sin(thetas(1)) - H(2,4)*cos(thetas(1)) -  d(4) ) / d(6));
end

A0to1Inv = [
    cos(thetas(1)), sin(thetas(1)), 0, 0;
    0, 0, 1, -d(1);
    sin(thetas(1)), -cos(thetas(1)), 0, 0;
    0, 0, 0, 1];

A4to5 = [ cos(thetas(5)) , 0  , -sin(thetas(5)), 0;
    sin(thetas(5)) , 0  , cos(thetas(5)) , 0;
    0             , -1  , 0     , d(5) ;
    0             ,  0  , 0     ,1 ];

A6to1 = inv( A0to1Inv * [H; [0 ,0 ,0, 1] ]);

% theta6 is not well-defined when sin(theta5) = 0 or when z_x,z_y = 0. We can
% see from Figure 5 that these conditions are actually the same. In this configuration joints 2,
% 3, 4, and 6 are parallel. As a result, there are four degrees of freedom to determine the position
% and rotation of the end-effector in the plane, resulting in an infnite number of solutions. In
% this case, a desired value for q6 can be chosen to reduce the number of degrees of freedom
% to three.

thetas(6) = atan2(-A6to1(2,3)/sin(thetas(5)) , A6to1(1,3)/sin(thetas(5)) );

A5to6 = [ cos(thetas(6)) , -sin(thetas(6))  , 0, 0;
    sin(thetas(6))   , cos(thetas(6))  , 0 , 0;
    0               , 0             , 1  , d(6) ;
    0               ,  0            , 0    ,1 ];

% We can now consider the three remaining joints as forming a planar 2R manipulator. First
% we will find the location of frame 3 with respect to frame 1.
%
% A1to4 = A1to6 * A6to4

A1to6 = A0to1Inv * [H; [0 ,0 ,0, 1] ];

A1to4 = A1to6 / (A4to5 * A5to6);

loc1to3 = (A1to4 * [0;-d(4);0;1]) - [0;0;0;1];

% Elbow up/ down
if config.up
    thetas(3) = acos( ( dot(loc1to3,loc1to3) - a(2)^2 -a(3)^2) / (2*a(2)*a(3)) );
else
    thetas(3) = -acos( ( dot(loc1to3,loc1to3) - a(2)^2 -a(3)^2) / (2*a(2)*a(3)) );
end
if(~isreal(thetas(3)))
    thetas(3) = 0;
    warning('Singularity in thetas(3) for H: %s \n config: %s \n loc1to3: %s', mat2str(H), char(config), mat2str(loc1to3));
end

thetas(2) = -atan2( loc1to3(2), -loc1to3(1)) + asin( a(3)*sin(thetas(3))/ norm(loc1to3) );

if(~isreal(thetas(2)))
    thetas(2) = 0;
    warning('Singularity in thetas(2) for H: %s \n config: %s \n loc1to3: %s', mat2str(H), char(config), mat2str(loc1to3));
end

% Notice that there are two solutions for 2 and 3. These solutions are known as \elbow up"
% and \elbow down."

% A3to4 = A3to1*A1to4

A1to2 = [ cos(thetas(2)) , -sin(thetas(2))  , 0, -a(2)*cos(thetas(2));
    sin(thetas(2)) , cos(thetas(2))  , 0 , -a(2)*sin(thetas(2));
    0               , 0 , 1     , 0 ;
    0               ,  0 , 0    , 1 ];

A2to3 = [ cos(thetas(3)) , -sin(thetas(3))  , 0, -a(3)*cos(thetas(3));
    sin(thetas(3)) , cos(thetas(3))  , 0 , -a(3)*sin(thetas(3));
    0               , 0 , 1     , 0 ;
    0               ,  0 , 0    , 1 ];

A3to4 = (A1to2 * A2to3) \ A1to4;

if(isreal(A3to4))
    thetas(4) = atan2(A3to4(2,1) , A3to4(1,1));
else
    thetas(4) = 0;
    warning('Singularity in theta(4) for H: %s \n config: %s \n A3to4: %s', mat2str(H), char(config), mat2str(A3to4));
end

thetas = thetas' * 180 / pi;
end

