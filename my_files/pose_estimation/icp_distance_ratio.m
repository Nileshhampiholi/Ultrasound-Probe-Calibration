
function [transfrom,final_transform, error] = distance_ratio_phantom(point_cloud_phantom_full,image_centriods)
    %% Sperate point cloud into 12 threads 

    % left strands
    one_left = point_cloud_phantom_full(1:12:end,:);
    two_left =  point_cloud_phantom_full(2:12:end,:);
    three_left =  point_cloud_phantom_full(3:12:end,:);
    four_left = point_cloud_phantom_full(4:12:end,:);

    % middle strands
    one_middle = point_cloud_phantom_full(5:12:end,:);
    two_middle =  point_cloud_phantom_full(6:12:end,:);
    three_middle =  point_cloud_phantom_full(7:12:end,:);
    four_middle = point_cloud_phantom_full(8:12:end,:);


     % right strands 
    one_right = point_cloud_phantom_full(9:12:end,:);
    two_right =  point_cloud_phantom_full(10:12:end,:);
    three_right =  point_cloud_phantom_full(11:12:end,:);
    four_right = point_cloud_phantom_full(12:12:end,:); 



    %% Compute distance ratio of phantom      
    % number of points in one thread
    % sz = length(one_left)^2;
    % distance ratio of very point with exery other point doest work well 
    % distance_ratio_1 = reshape(pdist2(one_left,one_middle), sz,1) ./ reshape(pdist2(one_left,one_right), sz,1);
    % distance_ratio_2 = reshape(pdist2(two_left,two_middle), sz,1) ./ reshape(pdist2(two_left,two_right), sz,1);
    % distance_ratio_3 = reshape(pdist2(three_left,three_middle), sz,1) ./ reshape(pdist2(three_left,three_right), sz,1);
    % distance_ratio_4 = reshape(pdist2(four_left,four_middle), sz,1) ./ reshape(pdist2(four_left,four_right), sz,1);

    % 
    % distance_ratio_1 = pdist2(one_left,one_middle) ./ pdist2(one_left,one_right);
    % distance_ratio_2 = pdist2(two_left,two_middle) ./ pdist2(two_left,two_right);
    % distance_ratio_3 = pdist2(three_left,three_middle) ./ pdist2(three_left,three_right);
    % distance_ratio_4 = pdist2(four_left,four_middle) ./ pdist2(four_left,four_right);

    % In plane distance ratio
    distance_ratio_1 = diag(pdist2(one_left,one_middle)) ./ diag(pdist2(one_left,one_right));
    distance_ratio_2 = diag(pdist2(two_left,two_middle)) ./ diag(pdist2(two_left,two_right));
    distance_ratio_3 = diag(pdist2(three_left,three_middle)) ./ diag(pdist2(three_left,three_right));
    distance_ratio_4 = diag(pdist2(four_left,four_middle)) ./ diag(pdist2(four_left,four_right));


    %% Image blob centriods 
    % image_distance_ratio = pdist2(image_centriods(1:4,:),image_centriods(5:8,:)) ./  dpdist2(image_centriods(1:4,:),image_centriods(8:12,:));

    image_distance_ratio = diag(pdist2(image_centriods(1:4,:),image_centriods(5:8,:))) ./  diag(pdist2(image_centriods(1:4,:),image_centriods(9:12,:)));

    %% Average Distance ratio of image points and phantom points 
    % avg_image_ratio= mean(image_distance_ratio(1:3));
    % avg_phantom_rATIO= (distance_ratio_1+distance_ratio_2+distance_ratio_3) /3;
    % [~, index] = min(abs(avg-  avg_image))
    % [~, index_4] = min(abs(distance_ratio_4-  image_distance_ratio(4)));
    % avg_index = mean(index, index_4);



    %% Get index of the min error w r t distace ratio 
    [~, index_1_middle] = min(abs(distance_ratio_1-  image_distance_ratio(1)));
    [~, index_2_middle] = min(abs(distance_ratio_2-  image_distance_ratio(2)));
    [~, index_3_middle] = min(abs(distance_ratio_3-  image_distance_ratio(3)));
    [~, index_4_middle] = min(abs(distance_ratio_4-  image_distance_ratio(4)));

    
    %% Use distatance to find left and right strand points 
    middle_1 =  one_middle(index_1_middle,:);
    middle_2 =  two_middle(index_2_middle,:);
    middle_3 =  three_middle(index_3_middle,:);
    middle_4 =  four_middle(index_4_middle,:);
    
    distance_left_1 = pdist2(one_left, middle_1);
    distance_left_2 = pdist2(two_left, middle_2);
    distance_left_3 = pdist2(three_left, middle_3);
    distance_left_4 = pdist2(four_left, middle_4);
    
    distance_right_1 = pdist2(one_right, middle_1);
    distance_right_2 = pdist2(two_right, middle_2);
    distance_right_3 = pdist2(three_right, middle_3);
    distance_right_4 = pdist2(four_right, middle_4);
    
    
    dist = get_distances(image_centriods);
    
    [~,index_left_1] = min(abs(distance_left_1-  dist(1,1)));
    [~,index_left_2] = min(abs(distance_left_2-  dist(2,1)));  
    [~,index_left_3] = min(abs(distance_left_3-  dist(3,1)));
    [~,index_left_4] = min(abs(distance_left_4-  dist(4,1)));
    
    [~,index_right_1] = min(abs(distance_right_1-  dist(1,3)));
    [~,index_right_2] = min(abs(distance_right_2-  dist(2,3)));  
    [~,index_right_3] = min(abs(distance_right_3-  dist(3,3)));
    [~,index_right_4] = min(abs(distance_right_4-  dist(4,3)));
    
    index_left = mean([index_left_1 index_left_2 index_left_3 index_left_4]);
    index_right = mean([index_right_1 index_right_2 index_right_3 index_right_4]);
    
    %% Incase of using every point to every point distance ratio 
    %  x = 2;
    % index_1 = num2str(index_1);
    % one =  [str2double(index_1(1:end-3));str2double(index_1(end-2:end))];
    % 
    % index_2 = num2str(index_2);
    % two =  [str2double(index_2(1:end-3));str2double(index_2(end-2:end))];
    % 
    % index_3 = num2str(index_3);
    % three =  [str2double(index_3(1:end-3));str2double(index_3(end-2:end))];
    % 
    % index_4 = num2str(index_4);
    % four =  [str2double(index_4(1:end-3));str2double(index_4(end-2:end))];
%     matched = [ one_left(index_left_1,:)
%                 two_left(index_left_2,:)
%                 three_left(index_left_3,:)
%                 four_left(index_left_4,:)
%                 one_middle(index_1_middle,:)
%                 two_middle(index_2_middle,:)
%                 three_middle(index_3_middle,:)
%                 four_middle(index_4_middle,:)
%                 one_right(index_right_1,:)
%                 two_right(index_right_2,:)
%                 three_right(index_right_3,:)
%                 four_right(index_right_4,:)
%                 ];
 
    %% Get the matched points using index of the min error matching 
      matched = [   one_left(index_1_middle,:)
                    two_left(index_2_middle,:)
                    three_left(index_3_middle,:)
                    four_left(index_4_middle,:)
                    one_middle(index_1_middle,:)
                    two_middle(index_2_middle,:)
                    three_middle(index_3_middle,:)
                    four_middle(index_4_middle,:)
                    one_right(index_1_middle,:)
                    two_right(index_2_middle,:)
                    three_right(index_3_middle,:)
                    four_right(index_4_middle,:)
                ];

    %% Apply ICP to the matched points to get trasfromation 
    [Ricp, Ticp, ~, ~] = icp(matched', image_centriods', 30);

    % Transform data-matrix using ICP result
    Dicp = Ricp * image_centriods' + repmat(Ticp, 1, 12);
    dist = pdist2(matched, Dicp');
    relevant = diag(dist);
    dist = mean(relevant);
    
    transfrom = rigid3d(Ricp, Ticp');
  
    error = dist;
    final_transform = Dicp';
end