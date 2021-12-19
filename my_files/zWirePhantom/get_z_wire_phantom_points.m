
function z_wire_phantom_points = get_z_wire_phantom_points(center)
    center = [0 0 0] + center;
    cubesize = 50;
    %Vertices for Line Cube. Order matters
    X = [0 0 1 1 0 0 1 1 1 1 1 1 0 0 0 0 0]' *3;
    Y = [0 1 1 0 0 0 0 0 0 1 1 1 1 1 1 0 0]';
    Z = [0 0 0 0 0 1 1 0 1 1 0 1 1 0 1 1 0]'* 2;
    
    X1 = [X X*cubesize+center(1)];
    Y1 = [Y Y*cubesize+center(2)];
    Z1 = [Z Z*cubesize+center(3)];
    %Single plot command for all 'cube lines'
    plot3(X1,Y1,Z1, 'linewidth',2);
    hold on;
     
    
    end_points = [  
                    10    50    90
                    10    50    80
                    10    50    70
                    10    50    60
                                        
                    10    50    90
                    10    50    80
                    10    50    70
                    40    50    60
                                      
                    40    50    90
                    40    50    80
                    40    50    70
                    40    50    60
                 ];
     
     start_points = [
                    10     0    90
                    10     0    80
                    10     0    70
                    10     0    60                   
                   
                    40     0    90
                    40     0    80
                    40     0    70
                    10     0    60
                                       
                    40     0    90
                    40     0    80
                    40     0    70
                    40     0    60
                   ];
  
    wire_points =linspaceNDim(start_points, end_points, 1000);
    point_cloud = [];
       
    for i = 1:1000
        point_cloud = vertcat(point_cloud, wire_points(:,:,i));
        plot3(wire_points(:,1,i), wire_points(:,2,i), wire_points(:,3,i), 'b.', 'MarkerSize', 3)
        hold on;
    end
    
   plot3([start_points(:,1) ;end_points(:,1)],...
          [start_points(:,2) ;end_points(:,2)],...
          [start_points(:,3) ;end_points(:,3)],...
          'r.', 'MarkerSize',10);
   xlabel('X', 'FontSize', 24)
   ylabel('Y','FontSize', 24)
   zlabel('Z', 'FontSize', 24)
   legend('Z- Wire', 'FontSize', 24)
   title('Ultrasound Caliberation Phantom (Z- Wire Phantom)', 'FontSize', 24, 'fontweight','bold')
  
      
   z_wire_phantom_points = point_cloud;
   
   writematrix(z_wire_phantom_points, 'wire_phantom.csv');
end
