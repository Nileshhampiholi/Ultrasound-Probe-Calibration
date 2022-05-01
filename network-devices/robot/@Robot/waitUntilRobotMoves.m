function waitUntilRobotMoves(self)
while(self.isMoving())
    if self.verbose
        disp('Waiting for robot to finish moving...');
    end
    pause(0.1);
end
end