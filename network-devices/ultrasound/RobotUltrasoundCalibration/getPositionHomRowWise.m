function T = getPositionHomRowWise(jTcpObj)

%% getPosition
mssg = send(jTcpObj,int8('GetPositionHomRowWise'));
mssgSplit = strsplit(mssg,' ');

% Format: joint angles 1-6
if isnan (str2double(mssgSplit)) 
    disp('Fehler bei RobServer Verbindung! Falsche IP-Adresse oder Server neustarten!');
else
    T = [reshape(str2double(mssgSplit),4,3)'; [0 0 0 1]];
end
