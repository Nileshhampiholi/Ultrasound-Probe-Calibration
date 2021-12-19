function moved = moveLINRelEE(self, x,y,z)
% this function moves the robot' EE (relative to its own coordinate 
%system)with a translation specified by x,y,z. Only Panda!
% x,y,z
command = ['MoveLinRelEE ' sprintf('%0.6f ',[x y z]')];
msg = self.sendReceive(command);

if (strcmp(strtrim(msg),'true') || isempty(msg))
    moved = 1;
    if (self.waitForRobotMov)
        self.waitUntilRobotMoves();
    end
else
    moved = 0;
    warning ('MoveLINRelEE unsuccessful. msg: %s', msg);
end   
end




