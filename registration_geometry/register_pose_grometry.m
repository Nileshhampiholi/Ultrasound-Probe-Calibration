function [tfrom,rms_error, transformed_image_points, er, x_y_z_phantom] = register_pose_grometry(image_centriods)

    %% Start end points of of N fudicial 

    %  P2|\   |P4                    %  P1|   /|P3
    %    | \  |                      %    |  / |
    %    |  \ |                      %    | /  |
    %  P1|   \|P3                    %  P2|/   |P4

%     P1 = [40     10    90                     
%           40     10    80                       
%           40     10    70                       
%           40     10    60];                     
% 
% 
%     P2 = [40    90    90;
%           40    90    80;
%           40    90    70;
%           40    90    60];
% 
%     P3 = [70    10    90
%           70    10    80
%           70    10    70
%           70    10    60 ];
% 
%     P4 = [70    90    90
%           70    90    80
%           70    90    70
%           70    90    60];
    P1 = [0     0    -10                     
          0     0    -20                       
          0     0    -30                       
          0     0    -40];                     


    P2 = [0    80    -10;
          0    80    -20;
          0    80    -30;
          0    80    -40];

    P3 = [30     0    -10
          30     0    -20
          30     0    -30
          30     0    -40 ];

    P4 = [30    80    -10
          30    80    -20
          30    80    -30
          30    80    -40];
 

    % Seprate the points of the middle strand 
    image_middle =  image_centriods(5:8,:);

    %% Compute distance ratio to get the codinate of the points in phantom sapce
    image_distance_ratio = diag(pdist2(image_centriods(1:4,:),image_centriods(5:8,:))) ./  diag(pdist2(image_centriods(1:4,:),image_centriods(9:12,:)));

    %% Compute the middle strand points in phantom cordinate frame 

    % Difference between start end points of the middle wire 
    start_end_difference= [ P4(1,1:2)-P1(1,1:2) ; 
                            P4(2,1:2)-P1(2,1:2) ;
                            P4(3,1:2)-P1(3,1:2) ;
                            P3(4,1:2)-P2(4,1:2) ];
    end_point  = [ P1(1,1:2) ;
                   P1(2,1:2) ;
                   P1(3,1:2) ;
                   P2(4,1:2) ];

    % Compute the x,y cordinate of the middle wire points for all 4 layers 
    x_y_phantom = image_distance_ratio.* start_end_difference + end_point;


    % Add the z codinate same as the end point of the of middle wire 
    x_y_z_phantom = [x_y_phantom, [P4(1,3); P4(2,3); P4(3,3);P4(4,3)]];

    %% Compute the trasformation between the image points and the matched points in phantom codinate system        
    [estR, estTr, ~,rms_error,~] = rot3dfit(x_y_z_phantom, image_middle);

    while (round(det(estR')) ==1)

        [estR, estTr, ~,rms_error,~] = rot3dfit(x_y_z_phantom, image_middle+[zeros(4,3)+randn(4,1)*0.009 ]);

    end

    tfrom = [estR', estTr';0 0 0 1];


    %% transform the points for plotting 
    transformed_image_points = image_middle * tfrom(1:3,1:3) + repmat(tfrom(1:3,4)', 4, 1);   
    
    % Localizatoíon error 
    er = mean(diag(pdist2(x_y_z_phantom, transformed_image_points)));  
     
end