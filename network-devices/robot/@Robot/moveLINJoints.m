function moved = moveLINJoints(self, newJointPositions)
if(all(size(newJointPositions) == [6,1]))
    newJointPositions = newJointPositions';
end
% Expects a 1x6 array for the newJointPositions
if (~all(size(newJointPositions) == [1,6]))
    error('moveToJointPositions: A 1x6 array for the newJointPositions! newJointPositions: %f', newJointPositions)
else
    self.enableLin();
    
    %self.setSpeed(2);
    
    msg = self.sendReceive(['MoveLINJoints ' sprintf('%0.6f ',newJointPositions')]);
    
    if (strcmp(strtrim(msg),'true'))
        moved = 1;
        if (self.waitForRobotMov)
            self.waitUntilRobotMoves();
        end
    else
        moved = 0;
        warning ('moveLINJoints unsuccessful. msg: %s', msg);
    end
    
    self.disableLin();
end
end

