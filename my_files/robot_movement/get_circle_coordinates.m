function circle_points = get_circle_coordinates(x,y,z,r)
    circle_points = [x y z];   
    for t= 0:5:180
        circle_points = [circle_points; (r*cos(t) + x)   (r*sin(t) + y) z]; 
    end

end