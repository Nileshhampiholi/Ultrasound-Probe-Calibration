function jointAngles = getPositionJoints()
global IP_ADDRESS;

%% Open the TCP/IP-Connection
jTcpObj = jtcp('request', IP_ADDRESS, 5005,'serialize',false);
mssg = char(jtcp('read',jTcpObj));
%disp(mssg);

%% Send the keyword to authorize the client
jtcp('write',jTcpObj,int8('Hello Robot'));
mssg = char(jtcp('read',jTcpObj));
disp(mssg);

jtcp('write',jTcpObj,int8('GetPositionJoints'));
pause(0.1)
mssg = char(jtcp('read',jTcpObj)); disp(mssg)
mssgSplit = strsplit(mssg,' ');

% If 'Quit' used, then you will need to start rob6server again
% jtcp('write',jTcpObj,int8('Quit'));
jTcpObj = jtcp('close',jTcpObj);

% Format: joint angles 1-6
if isnan (str2double(mssgSplit))
    disp('Fehler bei RobServer Verbindung! Falsche IP-Adresse oder Server neustarten!');
else
    jointAngles = str2double(mssgSplit);
end
