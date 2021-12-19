%clear all
%close all

% Tutorial 5 Task 3

function [] =  basic_path_planningUR5()

% Discretization of the work space for the UR5
x = -850:1:850;
y = -850:1:850;
z = -850:1:850;
[X,Y,Z] = meshgrid(x,y,z);


% TODO: find out the joint angles limits

% Joint angle limit according to the task
limTheta1 = [-10, 10];
limTheta2 = [-10, 10];
limTheta3 = [-10, 10];
limTheta4 = [-10, 10];
limTheta5 = [-10, 10];
limTheta6 = [-10, 10];

% Description of the obstacle by its vertices
obstacle = [0 0 0; 100 0 0; 0 100 0; 100 100 0; 0 0 100; 100 0 100; 0 100 100; 100 100 100];

% Description of the obstacle through its convex hull in order to check
% whether the points are within the convex hull or not.
convHullObsticle = convhulln(obstacle);

figure
set(gca,'FontSize',18)
hold on
title('Representation of the obstacle','Fontsize',24);

xlabel('x in cm');
ylabel('y in cm');
zlabel('z in cm');

xlim([min(x),max(x)])
ylim([min(y),max(y)])
zlim([min(z),max(z)])
grid on
fill3(obstacle(:,1),obstacle(:,2),obstacle(:,3),'red')

% Discretization of the configuration space
t1 = limTheta1(1):1:limTheta1(2);
t2 = limTheta2(1):1:limTheta2(2);
t3 = limTheta3(1):1:limTheta3(2);
t4 = limTheta4(1):1:limTheta4(2);
t5 = limTheta5(1):1:limTheta5(2);
t6 = limTheta6(1):1:limTheta6(2);
[theta1, theta2,theta3, theta4,theta5] = ndgrid(t1,t2,t3,t4,t5);

% Solution of the forward calculation (direct kinematics) all points of the
% discretization of the configuration space
% Note: link lengths are hard-coded in the function
ptsE = forwardEndeffector(theta1, theta2,theta3, theta4,theta5);

% pause;
hold on
plot3(ptsE(:,1)',ptsE(:,2)',ptsE(:,3)','.b','Markersize',3)
hold off

% Logical Array endeffectorInObstacle indicates whether the end effector is
% within the convex hull of the end effector or not
endeffectorInObstacle = reshape(inhull(ptsE,obstacle),size(theta1,1),size(theta1,2));

%  we cant plot the config space since we have 6 joint parametes

figure
set(gca,'FontSize',18)
hold on
title('Obstacle in configuration space','Fontsize',24);
xlabel('\Theta_1 in °');
ylabel('\Theta_2 in °');
xlim(limTheta1)
ylim(limTheta2)
grid on
ptsC = [reshape(theta1,numel(theta1),1),reshape(theta2,numel(theta2),1)];
plot(ptsC(endeffectorInObstacle,1)',ptsC(endeffectorInObstacle,2)','.b','Markersize',10)

end

