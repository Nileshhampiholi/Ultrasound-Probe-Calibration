function inverseKinematics(testCase)
%INVERSEKINEMATICS Summary of this function goes here
%   Detailed explanation goes here
matrix = testCase.robot.getPositionHomRowWise();
ref = testCase.robot.getJointPositions()';
config = testCase.robot.getStatus();

% Calculate the joint angles given a homogeneous matrix and a given config
thetas = UR5.safeInverseKinematics(matrix, config, testCase.robot.getJointPositions());

verifyEqual(testCase, ref(:), thetas(:), 'AbsTol', 1e-3, ...
    'inverseKinematics function does not work')

thetas2 = testCase.robot.backwardCalc(matrix, config)';

verifyEqual(testCase, ref(:), thetas2(:), 'AbsTol', 1e-3, ...
    'backwardCalc function does not work');
end

