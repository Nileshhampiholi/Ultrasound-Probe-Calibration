function [ jTcpObj ] = connect(IP_ADDRESS)
%CONNECT Summary of this function goes here
%   Detailed explanation goes here

%% Open the TCP/IP-Connection
%IP_ADDRESS = '134.28.45.95';
jTcpObj = jtcp('request', IP_ADDRESS, 5003,'serialize',false);
pause(0.1)
mssg = char(jtcp('read',jTcpObj)); 
disp(mssg);

%% Send the keyword to authorize the client
send(jTcpObj, int8('Hello Robot'));

end

