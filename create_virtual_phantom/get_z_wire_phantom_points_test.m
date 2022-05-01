function z_wire_phantom_points = get_z_wire_phantom_points(start_at_000)
  
    %% Define start end points of N fudicials 
    figure(4)
    if start_at_000
         start_points = [
                        0     0    -10
                        0     0    -20
                        0     0    -30
                        0     0    -40                   

                        30     0    -10
                        30     0    -20
                        30     0    -30
                        0      0    -40    

                        30     0    -10
                        30     0    -20
                        30     0    -30
                        30     0    -40
                       ];   
             end_points = [  
                        0    80    -10
                        0    80    -20
                        0    80    -30
                        0    80    -40

                        0    80    -10
                        0    80    -20
                        0    80    -30
                        30     80    -40

                        30    80    -10
                        30    80    -20
                        30    80    -30
                        30    80    -40
                     ];

       
    else
        
%         X = [0 0 1 1 0 0 1 1 1 1 1 1 0 0 0 0 0]';
%         Y = [0 1 1 0 0 0 0 0 0 1 1 1 1 1 1 0 0]';
%         Z = [0 0 0 0 0 1 1 0 1 1 0 1 1 0 1 1 0]';
% 
%         X1 = [X X*180];
%         Y1 = [Y Y*100];
%         Z1 = [Z Z*100];
%         %Single plot command for all 'cube lines'
%         plot3(X1,Y1,Z1, 'linewidth',2);
%         hold on;
%         
% 
% 
%         X = [0 0 1 1 0 0 1 1 1 1 1 1 0 0 0 0 0]';
%         Y = [0 1 1 0 0 0 0 0 0 1 1 1 1 1 1 0 0]';
%         Z = [0 0 0 0 0 1 1 0 1 1 0 1 1 0 1 1 0]';
% 
%         X1 = [X (X*160.+10)];
%         Y1 = [Y (Y*80.+10)];
%         Z1 = [Z Z*100];
%         %Single plot command for all 'cube lines'
%         plot3(X1,Y1,Z1, 'linewidth',2);
%         hold on;
         end_points = [  
                        40    90    90
                        40    90    80
                        40    90    70
                        40    90    60

                        40    90    90
                        40    90    80
                        40    90    70
                        70    90    60

                        70    90    90
                        70    90    80
                        70    90    70
                        70    90    60
                     ];

         start_points = [
                        40     10    90
                        40     10    80
                        40     10    70
                        40     10    60                   

                        70     10    90
                        70     10    80
                        70     10    70
                        40     10    60    

                        70     10    90
                        70     10    80
                        70     10    70
                        70     10    60
                       ];                
    end
    
    %% Numeer of points in each strand 
    num = 1000;
    wire_points =linspaceNDim(start_points, end_points, num);
    
    %% Create a point cloud of num *12 and plot 
    point_cloud = [];
    for i = 1:num
        point_cloud = vertcat(point_cloud, wire_points(:,:,i));
        plot3(wire_points(:,1,i), wire_points(:,2,i), wire_points(:,3,i), 'b.', 'MarkerSize', 3)
        hold on;
    end
 
   plot3([start_points(:,1) ;end_points(:,1)],...
          [start_points(:,2) ;end_points(:,2)],...
          [start_points(:,3) ;end_points(:,3)],...
          'r.', 'MarkerSize',10);
    hold on 
   if ~start_at_000
       [x, z] = meshgrid(linspace(35,75,100), linspace(50,100,100)); % Generate x and y data
       y = ones(size(x, 1))*40; % Generate z data
       s =  surf(x, y, z, "FaceColor", [0 1 1], 'FaceAlpha', 0.6, 'EdgeColor', 'none'); 
   end
   xlabel('X in mm', 'FontSize', 24)
   ylabel('Y in mm','FontSize',  24)
   zlabel('Z in mm', 'FontSize', 24)
   set(findall(gcf, '-property','FontSize'), 'FontSize', 15)
   

%    legend('Z- Wire', 'FontSize', 24)
%    title('Ultrasound Caliberation Phantom (Z- Wire Phantom)', 'FontSize', 24, 'fontweight','bold')
%   
%       
   z_wire_phantom_points = point_cloud;
   
   writematrix(z_wire_phantom_points, 'D:\Poject Arbeit\create_virtual_phantom\wire_phantom.csv');
end
