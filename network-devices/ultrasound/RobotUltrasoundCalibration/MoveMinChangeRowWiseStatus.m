function MoveMinChangeRowWiseStatus(jTcpObj, target_pos)

% build
firstrow = num2str(target_pos(1,:));
secondrow = num2str(target_pos(2,:));
thirdrow = num2str(target_pos(3,:));


%% send
mssgInt8 = int8(['MoveMinChangeRowWiseStatus ' firstrow ' ' secondrow ' ' thirdrow ' noToggleHand noToggleElbow noToggleArm']);
send(jTcpObj, mssgInt8);



end