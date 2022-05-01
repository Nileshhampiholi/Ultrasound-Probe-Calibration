function [ mssg  ] = send( jTcpObj,mssgInt8 )
%SEND Summary of this function goes here
%   Detailed explanation goes here

%%
jtcp('write',jTcpObj,mssgInt8);
pause(0.1)
mssg = char(jtcp('read',jTcpObj)); 
disp(mssg);

end

