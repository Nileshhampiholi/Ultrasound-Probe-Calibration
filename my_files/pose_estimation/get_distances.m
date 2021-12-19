function [distances]= get_distances(centriods)

    strand = [];
    for j=1:4

        % x = [image_centriods(j:j+1,:) ];
        % plot(x(:,1), x(:,2),'x')
        % hold on 
        % pause
        ab = pdist2(centriods(j,:),centriods(j+4,:),'euclidean');
        ac = pdist2(centriods(j,:), centriods(j+8,:),'euclidean');
        bc = pdist2(centriods(j+4,:),centriods(j+8,:),'euclidean');
        strand = [strand; ab ac bc];
    end
    distances = strand;
  
end 

