function [homMatrix, config] = forwardCalc(self, thetas)
%forwardCalc Calculates the homogeneous matrix given certain angles.
%   Detailed explanation goes here
sendMsg = ['ForwardCalc ' sprintf('%0.6f ', thetas)];
recvMsg = self.sendReceive(sendMsg);
if(strcmp(strtrim(recvMsg),'false'))
    warning('Joint configuration not possible: %s', mat2str(thetas));
    homMatrix = NaN;
    config = '';
else
    C = textscan(recvMsg,'%f %f %f %f %f %f %f %f %f %f %f %f\n%s %s %s');
    homMatrix = reshape([C{1:12}],4,3)';
    config = Configuration(char(C{13}),char(C{14}),char(C{15}));
end
end

