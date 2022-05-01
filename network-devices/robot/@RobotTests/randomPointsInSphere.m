function randomPointsInSphere( testCase )
%randompoints testrandompoints on simulator
%   Simply goes to randomly generated positions

currentJoints = testCase.robot.getJointPositions();

currentJoints(1:3) = [0 -100 105];

testCase.robot.moveToJointPositions(currentJoints);

centerPos = testCase.robot.getPositionHomRowWise();

R = 50;
N = 10;
dmin = -pi/4;
dmax = pi/4;
positions = randomSpherePositions(centerPos, R, N, dmin, dmax);
failed = 0;

failedPositions = createArrays(0, [4 4]);
for i=1:N
    configuration = testCase.robot.getStatus();
    if(testCase.robot.isPossible(positions{i},configuration))
        newJointAngles = UR5.safeInverseKinematics(positions{i},configuration,testCase.robot.getJointPositions());
        testCase.robot.moveToJointPositions(newJointAngles);
    else
        failed = failed + 1;
        failedPositions{failed} = positions{i};
    end
end
failedCount = size(failedPositions);
verifyTrue(testCase, failedCount(2)==0, MatrixDiagnostics(failedPositions));

configuration = testCase.robot.getStatus();

for i=1:N
    msg = sprintf('%d%s', round(i/N*100,0), '%%');
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg) - 1);
    
    if(~robot.isPossible(positions{i},configuration))
        AA = randomSpherePositions(centerPos, R, 1, dmin, dmax);
        positions{i} = AA{1};
    end
    thetas = UR5.safeInverseKinematics(positions{i}, configuration, testCase.robot.getJointPositions());
    thetas(6) = -180;
    thetas(5) = -115*rand() + 50;
    thetas(4) = -187*rand();
    jointPositions{i} = thetas;
    
end
end
