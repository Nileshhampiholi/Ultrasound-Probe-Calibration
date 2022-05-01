function moved = moveLINToHomRowWise(self, targetMatrix)

% This function goes to certain pose given by targetMatrix(hom.
% coordinates) with the actual configuration.a
if( size(targetMatrix) ~= [3, 4] )
    error( 'moveLINToHomRowWise: A 3x4 matrix is required!');
else
    self.enableLin();   
    %self.setSpeed(2);
    command = ['MoveLINHomRowWise ' sprintf('%0.6f ',targetMatrix')];
    msg = self.sendReceive(command);
    
    if (strcmp(strtrim(msg),'true') || isempty(msg))
        moved = 1;
        if (self.waitForRobotMov)
            self.waitUntilRobotMoves();
        end
    else
        moved = 0;
        warning ('moveToHomRowWise unsuccessful. msg: %s', msg);
    end
    
    self.disableLin();
end

end
