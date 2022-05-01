function moveToJointPositions(testCase)
%MOVETOJOINTPOSITIONS Summary of this function goes here
%   Detailed explanation goes here

getBackPosition = testCase.robot.getJointPositions();


joints = [-21 -78 -110 -34 102 25];
testCase.robot.moveToJointPositions(joints);
testCase.robot.waitForPosition(joints);

ref = testCase.robot.getJointPositions();

verifyEqual(testCase, ref(:), joints(:), 'AbsTol', 1e-3, ...
    'moveToJointPositions function does not work');

testCase.robot.moveToJointPositions(getBackPosition);
testCase.robot.waitForPosition(getBackPosition);

end

