function [poses_mark, poses_rob] = moveforcalib(T_init)

%% config
jAngles = getPositionJoints();


%% calc
for i=1:30
    
    
    
    %newAngles = [jAngles(1:3), jAngles(4)+randi([-10,10],1,1), jAngles(5)+randi([-10,10],1,1), jAngles(6)+randi([-10,10],1,1)];
    
    %new_pose = forward_kinematics(newAngles);
    
    %t = rand(3,1);
    %t = t/norm(t);
    %t = t*randi([-100,100],1);
    
   % new_pose = [new_pose(1:3,1:3),new_pose(1:3,4)+t];
    
    MoveMinChangeRowWiseStatus(new_pose);
    
    pause;
    
    poses_rob{i} = [new_pose;0,0,0,1]; 
    poses_mark{i} = [T];
    
   
    
    
end
   

end