function [distances]= get_distances(centriods)

    strand = [];
    for j=1:4
        ab = pdist2(centriods(j,:),centriods(j+4,:),'euclidean');
        ac = pdist2(centriods(j,:), centriods(j+8,:),'euclidean');
        bc = pdist2(centriods(j+4,:),centriods(j+8,:),'euclidean');
        strand = [strand; ab ac bc];
    end
    distances = strand;
  
end 

