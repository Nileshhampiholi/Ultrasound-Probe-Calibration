function check = isPossible(target_pos, configuration, jTcpObj)
% build
config = char(configuration);
config2 = [config(1,:) ' ' config(2,:) ' ' config(3,:)];
firstrow = num2str(target_pos(1,:));
secondrow = num2str(target_pos(2,:));
thirdrow = num2str(target_pos(3,:));

jtcp('write',jTcpObj,int8(['IsPossible ' firstrow ' ' secondrow ' ' thirdrow ' ', config2]));
pause(0.5)
mssg = char(jtcp('read',jTcpObj)); 
%disp(mssg)

check = strcmp(strtrim(mssg),'true');

end