function [trasfromation, point_cloud_image_transfromed, min_error] = icp_plane_wise(point_cloud_phantom_full, point_cloud_image,n)
  
    
    
    % Variables to storetrasfromations and mean error
    error = [];
    transfrom = [];
    previous_error = 100;
    
    % Iterate along the point cloud plane wiese 
    for i= 1:12:size(point_cloud_phantom_full, 1)
        % Creat point cloud of just one plane 
        point_cloud_phantom = point_cloud_phantom_full(i:i+11, :)';

        % apply icp
        [Ricp, Ticp, ~, ~] = icp(point_cloud_phantom, point_cloud_image', 30);

        % Transform data-matrix using ICP result
        Dicp = Ricp * point_cloud_image' + repmat(Ticp, 1, n);

        % Transformations 
        tform = rigid3d(Ricp, Ticp');
        transfrom = [transfrom; tform];

        % Compute distance error between trasfromed image points and phantom
        % points  and copute the mean 
        dist = pdist2(point_cloud_phantom', Dicp');
        relevant = diag(dist);
        dist = mean(relevant);
        
        error = [error; dist];
      
%         if dist >  previous_error
%             break;
%         end
%          previous_error = dist;
        
        
    end
    
    
    [min_error, index] = min(error);
    
%     figure(3)
%     plot(1:length(error), error, '--ro')
%     grid on 
%     hold on 
%     plot(index,min_error, 'b.', 'MarkerSize', 25)
%     legend("Mean Estiamtion Error", "Min Error",'FontSize', 18)
%     xlabel("Iterations",'FontSize', 18)
%     ylabel("Mean pose estimation error", 'FontSize', 18)
%     hold off

    tform = transfrom(index);
    final_transform  = tform.Rotation * point_cloud_image' + repmat(tform.Translation', 1, n);
    trasfromation = transfrom(index);
    point_cloud_image_transfromed = final_transform';

end