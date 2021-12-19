function square_coordinates = get_square_coordinates(x,y,z, l) 
    l = l/2;
    square_coordinates =[x y z];
    for i=1:2
        for j=1:2
            if i==1 && j==1
                square_coordinates =[square_coordinates; x-l y-l z];
            elseif i==1 && j==2
                square_coordinates =[square_coordinates; x-l, y+l, z];
            elseif i==2 && j==1
                square_coordinates =[square_coordinates; x+l, y-l, z];
            elseif i==2 && j==2
                square_coordinates =[square_coordinates; x+l, y+l, z];
            end            
        end
    end
    for i= 1: length(square_coordinates)
        if i ==1
            square_coordinates = [square_coordinates; square_coordinates(2,:)];
        end
        if i == 4
            temp = square_coordinates(4,:);
            square_coordinates(4,:) = square_coordinates(5,:);
            square_coordinates(5,:) = temp;
        end
    end   
end