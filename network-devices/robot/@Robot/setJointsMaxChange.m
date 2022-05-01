function setJointsMaxChange( self, jointsChange )
%SETJOINTSMAXCHANGE Summary of this function goes here
%   Detailed explanation goes here

msg = self.sendReceive(['SetJointsMaxChange ' num2str(jointsChange)]);

if(~strcmp(strtrim(msg),'true'))
    error(['Could not set up max joints change to ' num2str(jointsChange)]);
end
end

