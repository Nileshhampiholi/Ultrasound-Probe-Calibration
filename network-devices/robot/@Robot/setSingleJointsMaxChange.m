function setSingleJointsMaxChange( self, joint, maxchange )
%setSingleJointsMaxChange Sets the maximal rotation angle per movement of a single join.
%   Detailed explanation goes here

msg = self.sendReceive(['SetSingleJointMaxChange ' ...
    sprintf('%d %0.6f ',joint,maxchange) ]);


if(~strcmp(strtrim(msg),'true'))
    error(['Could not set up max joints change to ' num2str(jointsChange)]);
end

end

