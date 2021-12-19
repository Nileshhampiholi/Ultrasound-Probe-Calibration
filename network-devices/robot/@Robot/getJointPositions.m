function jointPositions = getJointPositions(self)
msg = self.sendReceive('GetPositionJoints');
if (size(msg) == -1)
    error('No joint positions received!');
else
    splitted = strsplit(msg,'\n');
    joints = splitted(end-1);
    C = textscan(joints{1},'%f');
    jointPositions = C{:};
end
end
