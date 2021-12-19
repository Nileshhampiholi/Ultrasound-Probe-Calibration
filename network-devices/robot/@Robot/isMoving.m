function moving = isMoving(self)
%ISPOSSIBLE Summary of this function goes here
%   Detailed explanation goes here
pos1 = self.getJointPositions();
pause(0.5);
pos2 = self.getJointPositions();
moving = sum(abs(pos1-pos2)) > 1e-2;