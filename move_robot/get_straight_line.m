function line_cordinates = get_straight_line(p1, p2)
    u = (p2-p1)/norm(p2-p1)   % unit vector, p1 to p2
    d = (0:norm(p2-p1))' 
    % displacement from p1, along u
    
    d*u
    xyz = p1 + d*u;
    % plot3(xyz(:,1),xyz(:,2),xyz(:,3),'o-')
    line_cordinates = [xyz; p2];
end