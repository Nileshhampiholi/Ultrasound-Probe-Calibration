function [T,timestamp, visFlag] = getLocatorTransformMatrix(self, name)
% GetLocatorTransformMatrix  Gets the transform matrix of the locator
% 'name'.
% TCP/IP object associated with the CambarServer needs to be provided.
%   T = GetLocatorTransformMatrix(jTcpObj, 'stylus')

pause(0.1);

msg = self.sendReceive(['GetLocatorPosition ' name]);

C = strsplit(msg,' ');
visFlag = strcmp(C{2},'1');
% Format:
% 1. timestamp
% 2. visible-flag
% 3. 4x4 position ,matrix of the locator:
%   R00, R01, R02, X, R10, R11, R12, Y, R20, R21, R22, Z, 0, 0, 0, 1
T = [str2double(C{3}),str2double(C{4}),str2double(C{5}),str2double(C{6});
    str2double(C{7}),str2double(C{8}),str2double(C{9}),str2double(C{10});
    str2double(C{11}),str2double(C{12}),str2double(C{13}),str2double(C{14});
    0, 0, 0, 1];
timestamp = str2double(C{1});
end