function zigzag = get_zigzag_coordinates(start, x_change, y_change, direction)
    zigzag = start;
    if direction ==0
        for i = 1:10
            if rem(i, 2) == 0 
               zigzag =  [zigzag; zigzag(i, :)  + [x_change 0 0]];
            end
       
            if rem(i, 2) ~= 0
                zigzag =  [zigzag;  zigzag(i,:)+ [-x_change y_change 0]];    
            end   
        end
    end
    
    if direction==1
        for i = 1:10
            if rem(i, 2) ~= 0 
               zigzag =  [zigzag; zigzag(i, :)  + [0 y_change 0]];
            end
       
            if rem(i, 2) == 0
                zigzag =  [zigzag;  zigzag(i,:)+ [x_change -y_change 0]];    
            end   
        end
    end
end