function [  ] = disconnect( jTcpObj); 
%DISCONNECT Summary of this function goes here
%   Detailed explanation goes here

%%
% If 'Quit' used, then you will need to start rob6server again
% jtcp('write',jTcpObj,int8('Quit'));
jTcpObj = jtcp('close',jTcpObj);
end

