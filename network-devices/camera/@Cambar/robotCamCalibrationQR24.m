function [ EndeffToMark, RobToTrack ] = robotCamCalibrationQR24(self,robot)
%RobotCamCalibrationQR24 Calculates tool/flange and robot/world calibration
%   At first, random points selected from inside a sphere with radius r
%   and +/- d degrees in yaw, pitch, roll
%   X stands for the trans.matrix from Endeffector to Marker
%   Y stands for the trans.matrix from Robot to trackingsystem
%   Now the translational part is in meters!

% Typically, the robot's end effector is moved to random
% points selected from inside a sphere with radius r.
% Additionally, a random rotation of up to +/- d degrees in
% yaw, pitch and roll is added to the pose.

%% Waiting for user input
prompt = 'Mount the needle on the roboter and hit enter when you are ready';
input(prompt);

%% Defining rotation and translation
% Number of random points
% 
% R = 50;
N = 50;
% dmin = -pi/4;
% dmax = pi/4;

startingJoints = robot.getJointPositions();
centerPos = robot.getPositionHomRowWise();
%% Calculation of the Transformationmatrices
name = 'NeedleRNMOrig';
self.loadLocator(name);

% http://stackoverflow.com/questions/466972/array-of-matrices-in-matlab
robPose = zeros(4,4,N); % array of matrices, so we just create a 3d array
markPose =  zeros(4,4,N);

robot.setSpeed(100);

% elevator = Elevator();
% elevator.play(sprintf('Moving to %d random joint configurations ...', N));

jointPositions = calculateAngles(robot,N,centerPos);

% Preallocating
A = zeros(12*N,24);
b = zeros(12*N);
i=1;
while i<=N
    fprintf('%f\n', i/N);
    
    %configuration = robot.getStatus();
    newJointAngles = jointPositions{i};
    
    %  nextPos or robot.getPositionHomRowWise() for the robPose ???
    %  better be safe, use getPositionHomRowWise for getting the pose
    % nextPos = UR5.forwardEndeffector(newJointAngles);
    
    robot.moveToJointPositions(newJointAngles);
    
    % Get the transformation-matrix: Tracking to marker
    [transformMatrix,~]  = self.getLocatorTransformMatrix(name);
    
    
    if (sum(transformMatrix(:))~=1)
        markPose(:,:,i) = transformMatrix;
        % line below belongs @the TODO
        robPose(:,:,i) = [robot.getPositionHomRowWise(); 0 0 0 1];
        
        %% Converting the translational part from mm to m
        tmp = robPose(:,:,i);
        tmp(1:3,4) = tmp(1:3,4)/1000;
        robPose(:,:,i) = tmp;
        
        tmp2 =  markPose(:,:,i);
        tmp2(1:3,4) = tmp2(1:3,4)/1000;
        markPose(:,:,i) = tmp2;
        
        %% Fill in the elements for the calibration
        % Construct A and b for solving the linear (overdetermined) equation
        Ri = getRot(robPose(:,:,i));
        Ni_inv = inv(markPose(:,:,i));
        trans = getTrans(robPose(:,:,i));
        A_fir = [ Ri*Ni_inv(1,1), Ri*Ni_inv(2,1), Ri*Ni_inv(3,1), zeros(3);
            Ri*Ni_inv(1,2), Ri*Ni_inv(2,2), Ri*Ni_inv(3,2), zeros(3);
            Ri*Ni_inv(1,3), Ri*Ni_inv(2,3), Ri*Ni_inv(3,3), zeros(3);
            Ri*Ni_inv(1,4), Ri*Ni_inv(2,4), Ri*Ni_inv(3,4), Ri ];
        A(1+(i-1)*12 : 12+(i-1)*12, : ) = [ A_fir, -eye(12)];
        b(1+(i-1)*12 : 12+(i-1)*12  )    = [zeros(9,1); -trans];
        i = i + 1;
    else
        %% Rejecting the robot pose and create a new one
        % If the actual marker position was not visible for the camera,
        % then set the jointPositions{i} with a new angle config
        fprintf('All zero T : Calculating new Pose\n');
        jointPositions{i} = calculateAngles(robot,1,centerPos);
    end
end
save('C:\Users\Rajput\Desktop\rnm_grp1\matlab\poses.mat','robPose','markPose')
% elevator.stop('Done.');

%% Solve the linear Equation system using QR-factorisation and calculate error

for i=1:N
    
    % solve matrix equation for i points
    Acalc(1+(i-1)*12 : 12+(i-1)*12 , : )  = A(1+(i-1)*12 : 12+(i-1)*12 , : );
    bcalc(1+(i-1)*12 : 12+(i-1)*12  ) = b(1+(i-1)*12 : 12+(i-1)*12  );
    
    berr = bcalc';
    [Q,R] = qr(Acalc);
    z = Q'*berr;
    w = R\z;
    
    x_vec = w( 1:12 );
    y_vec = w( 13:24);
    EndeffToMark = [reshape(x_vec,3,4) ; 0 0 0 1];
    RobToTrack = [reshape(y_vec,3,4) ; 0 0 0 1];
    
    % solve for at least for at least 3 points
    % otherwise: Calibrationmatrix is close to singular or badly scaled
    % For i (has to be >= 3) poses calibrate the rot. and trans. e
    % error of all N pairs of camera and robotposes
    if i >= 3
        for j=1:N
            A_res = inv(EndeffToMark) * inv(robPose(:,:,j)) * RobToTrack * markPose(:,:,j);
            
            [U,~,V] = svd(A_res);
            A_err = U*V';
            % Calculating the mean translational error in Millimeter
            transErr(j,i) =  1000*sqrt(A_err(1,4)^2 + A_err(2,4)^2 + A_err(3,4)^2);
            R = vrrotmat2vec(A_err(1:3,1:3));
            roterr(j,i) = abs(R(4)*180/pi);
        end
    end
end

%% Plot the results
grid on;
hold on;
figure;

%subplot(2,1,1);
%boxplot(transErr,'notch', 'on');
boxplot(transErr);
ylabel('Average translation error in millimeters');

figure;
boxplot(roterr);
ylabel('Average rotation error in degree');

%% Converting the recent trans. matrices back to millimeters
% (since every trans. matrix will be in millimeters )
EndeffToMark(1:3,4) = EndeffToMark(1:3,4)*1000;
RobToTrack(1:3,4) = RobToTrack(1:3,4)*1000;
format long; % make sure the matrices will be printed properly

%% Write the results into a data
d = datetime('today');
date = datestr(d);

fulltime = clock();

timestamp = strcat(date,',',num2str(fulltime(4)),'.',num2str(fulltime(5)));

filename = strcat('robCamCalib',timestamp,'.txt');
fileID = fopen(filename,'wt');
fprintf(fileID,' trans.matrix from Endeffector to Marker \n');

for ii = 1:size(EndeffToMark,1)
    fprintf(fileID,'%g\t',EndeffToMark(ii,:));
    fprintf(fileID,'\n');
end

fprintf(fileID,'\n');
fprintf(fileID,'trans.matrix from Robot to trackingsystem \n');
for ii = 1:size(RobToTrack,1)
    fprintf(fileID,'%g\t',RobToTrack(ii,:));
    fprintf(fileID,'\n');
end

fprintf(fileID,'Mean translational error %f mm\n',mean(transErr(:,N)) );
fprintf(fileID,'Variance translational error %f mm\n',var(transErr(:,N)) );
fprintf(fileID,'Rotation error %f degree\n', mean(roterr(:,N)) );

fclose(fileID);

robot.moveToJointPositions(startingJoints);

end

%% Calculate new function if a pose can't be read
function jointPositions = calculateAngles (robot,N,centerPos)
%%
R = 125000;

% points = randomSpherePoints(centerPos(1:4),centerPos(2:4),centerPos(3:4),r,n);

minPitch = -30;
maxPitch = 30;
minRoll = 0;
maxRoll = 0;
minYaw = -30;
maxYaw = 30;



rotations = randomRotations(N, minRoll, maxRoll, minPitch, maxPitch, minYaw, maxYaw);
positions = randomSpherePoints(R,N,centerPos(1,4),centerPos(2,4),centerPos(3,4));


%positions = randomSpherePositions(centerPos, R, N, dmin, dmax);

jointPositions = createArrays(N, [1 6]);

reverseStr = '';
configuration = robot.getStatus();
for i=1:N
    msg = sprintf('%d%s', round(i/N*100,0), '%%');
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg) - 1);
    
    %     while(~robot.isPossible(positions{i},configuration))
    %         AA = randomSpherePositions(centerPos, R, 1, dmin, dmax);
    %         positions{i} = AA{1};
    %     end
    %     thetas = UR5.safeInverseKinematics(positions{i}, configuration, robot.getJointPositions());
    %     min6 = -180;
    %     max6 = -180;
    %     thetas(6) = (min6-max6)*rand()+max6;
    %     min5 = -58;
    %     max5 = 62;
    %     thetas(5) = (min5-max5)*rand()+max5;
    %     min4 = -180;
    %     max4 = 44;
    %     thetas(4) = (min4-max4)*rand()+max4;
    newOrientation = getRot(centerPos)*rotations{i};
    translation = positions{i};
    H = [newOrientation translation];
    thetas = UR5.safeInverseKinematics(H, configuration, robot.getJointPositions());
    jointPositions{i} = thetas;
    
end

end