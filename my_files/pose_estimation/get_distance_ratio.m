function [d] = get_distance_ratio(p1,p2, p3)

    ab =  pdist([p1,p2],'euclidean');
    ac =  pdist([p1,p3],'euclidean');
    d = ab/ac;
end