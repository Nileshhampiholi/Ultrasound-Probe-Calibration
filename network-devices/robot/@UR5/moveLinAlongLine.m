function moveLinAlongLine( self, start, destination, ratio)
%MOVELINALONGLINE Summary of this function goes here
%   Detailed explanation goes here
nextH = getEntryPointCoordFrame(destination, start, ratio);
% currentH = self.getPositionHomRowWise();
currentConfig = self.getStatus();

% Start pose
joints = self.getJointPositions();
nextJoints = UR5.safeInverseKinematics(nextH, currentConfig, joints);
self.moveToJointPositions(nextJoints);

% End pose
% Linearly move the joints along the line
nextJoints = UR5.safeInverseKinematics([getRot(nextH) destination'], currentConfig, self.getJointPositions());
self.moveLINJoints(nextJoints);
end

