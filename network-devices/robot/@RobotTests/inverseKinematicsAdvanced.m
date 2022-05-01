function inverseKinematicsAdvanced(testCase)
%INVERSEKINEMATICS Summary of this function goes here
%   Detailed explanation goes here

target = [-0.9992   -0.0310    0.0243 -107.1500;
   -0.0392    0.7220   -0.6907 -517.5207;
    0.0039   -0.6912   -0.7227  520.0779;];

configurations = [
    Configuration('flip','up','lefty');
    Configuration('flip','up','righty');
    Configuration('flip','down','lefty');
    Configuration('flip','down','righty');
    Configuration('noflip','up','lefty');
    Configuration('noflip','up','righty');
    Configuration('noflip','down','lefty');
    Configuration('noflip','down','righty');
];

for i=1:8
    testInverseCalc(testCase, target, configurations(i));
end

end

function testInverseCalc(testCase, refH, refConfig)
thetas = UR5.safeInverseKinematics(refH, refConfig, testCase.robot.getJointPositions());
[H, config] = testCase.robot.forwardCalc(thetas);

verifyEqual(testCase, H(:), refH(:), 'AbsTol', 1e-1, ...
    sprintf('H and refH do not match. \n H: %s \n refH: %s', mat2str(H), mat2str(refH)));
verifyEqual(testCase, char(refConfig), char(config), ...
    sprintf('config and refConfig do not match. \n config: %s \n refConfig: %s', char(config), char(refConfig)));
end
