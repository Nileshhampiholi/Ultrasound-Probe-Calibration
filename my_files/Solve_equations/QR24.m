function [X_normalised, Y_normalised] = QR24(robot_poses, marker_poses)
    AA =[];
    BB =[];
    
    for i = 1:4:size(robot_poses,1)
        
        robot_pose = robot_poses(i:i+3,:);
        marker_pose = marker_poses(i:i+3,:);
        
        rotation = robot_pose(1:3,1:3);   
        translation = robot_pose(1:3,4);
        

        A = [rotation.*marker_pose(1,1)    rotation.*marker_pose(2,1)   rotation.*marker_pose(3,1) zeros(3);
             rotation.*marker_pose(1,2)    rotation.*marker_pose(2,2)   rotation.*marker_pose(3,2) zeros(3);
             rotation.*marker_pose(1,3)    rotation.*marker_pose(2,3)   rotation.*marker_pose(3,3) zeros(3);
             rotation.*marker_pose(1,4)    rotation.*marker_pose(2,4)   rotation.*marker_pose(3,4) rotation ];
         
       A =[ A, - eye(12,12)];
       
       B = [zeros(9,1);
           -translation];
       
       AA = [AA; A];
       BB = [BB; B];
        
    end
    
    W = AA\BB;
    
    X = [ W(1:3) W(4:6) W(7:9) W(10:12);
          0      0      0      1 ];
    
    Y = [ W(13:15) W(16:18) W(19:21) W(22:24);
          0        0        0        1   ];  
      
    [U_x,~,V_x] = svd(X);
    X_normalised = U_x * V_x; 
    
    [U_y,~,V_y] = svd(Y);
    Y_normalised = U_y * V_y; 
     
end