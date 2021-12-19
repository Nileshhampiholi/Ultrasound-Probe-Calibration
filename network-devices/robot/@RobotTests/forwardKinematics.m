function forwardKinematics(testCase)
%FORWARDKINEMATICS Summary of this function goes here
%   Detailed explanation goes here
joints = testCase.robot.getJointPositions();
ref = testCase.robot.getPositionHomRowWise();

matrix = testCase.robot.forwardCalc(joints);

verifyEqual(testCase, ref(:), matrix(:), 'AbsTol', 1e-3, ...
    'forwardCalc function does not work');

end

