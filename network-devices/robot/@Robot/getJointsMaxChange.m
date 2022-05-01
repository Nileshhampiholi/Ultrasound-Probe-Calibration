function jointsChange = getJointsMaxChange( self )
%GETJOINTSMAXCHANGE Summary of this function goes here
%   Detailed explanation goes here
msg = self.sendReceive('GetJointsMaxChange');
C = textscan(msg, '%f');
jointsChange = C{:};
end

