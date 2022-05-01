function configuration = getStatus(jTcpObj)

jtcp('write',jTcpObj,int8('GetStatus'));
pause(0.1)
mssg = char(jtcp('read',jTcpObj)); 
%disp(mssg)
configuration = strsplit(mssg,' ');
end

