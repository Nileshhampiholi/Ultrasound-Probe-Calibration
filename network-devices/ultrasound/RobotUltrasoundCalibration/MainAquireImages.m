clear all;
close all;

%% connect to robot
jTcpObj = connect('134.28.45.95');

%% Move to old INIT
%MoveMinChangeRowWiseStatus(jTcpObj, T_init2);
 
 %% GetPosition
TE_init = getPositionHomRowWise(jTcpObj)
TI_init = TE_init * Y_orth24;
TE_init2 = TE_init;


 
%% lower probe
TE_init(3,4) = TE_init(3,4)-5;
MoveMinChangeRowWiseStatus(jTcpObj, TE_init);

%% upper probe
TE_init(3,4) = TE_init(3,4)+5;
MoveMinChangeRowWiseStatus(jTcpObj, TE_init);

%% Calc random positions
%randomPointsInSphere(jTcpObj);
num = 100;
R = 0;
maxAngle = 15;
%rpyLim = [-maxAngle maxAngle -maxAngle maxAngle -maxAngle maxAngle];
rpyLim = [-0 0  -maxAngle maxAngle -0 0];
%newOrientations = calculateAngles(num,TE_init,R,rpyLim);
newOrientations = calculateAngles(num,TI_init,R,rpyLim);



%% move
for i=1:num
    %MoveMinChangeRowWiseStatus(jTcpObj, newOrientations(:,:,i));
    MoveMinChangeRowWiseStatus(jTcpObj, newOrientations(:,:,i)*invTfMat(Y_orth24));
   % R = input('s: skip, 0: cancle:','s');
   
    disp(['Pose: ' num2str(i)]);
  %  while exist(['D:\Users\stefa\anderes\Dropbox\Uni\Thesis\_Code\Ultraschall\UltraschallImages\_images\fileoutpos.txt_' num2str(i-1) '.jpg'], 'file') ~= 2
    % Do the job;
  %  end
    
    pause
    
    
    
    %if strcmp(R,'s')
    %   disp([num2str(i), ': skipped']);
    %elseif strcmp(R,'0')
    %    disp('cancle');
    %    break;
    %else
    %    disp([num2str(i), ': saved']);
    %end     
end

%% disconnect robot
disconnect(jTcpObj); 
disp('Disconnected');
