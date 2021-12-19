function moved = movePTPHomRowWiseDirect(self, targetMatrix)

% This function goes to certain pose given by targetMatrix(hom.
% coordinates) with the actual configuration.

if( size(targetMatrix) ~= [3, 4] )
    error( 'MovePTPHomRowWiseDirect: A 3x4 matrix is required!');
else
    command = ['MovePTPHomRowWiseDirect ' sprintf('%0.6f ',targetMatrix')];
    msg = self.sendReceive(command);
    
    if (strcmp(strtrim(msg),'true') || isempty(msg))
        moved = 1;
        if (self.waitForRobotMov)
            self.waitForPositionHom(targetMatrix, true);
        end
    else
        moved = 0;
        warning ('MovePTPHomRowWiseDirect unsuccessful. msg: %s', msg);
    end
    
    
end


end
