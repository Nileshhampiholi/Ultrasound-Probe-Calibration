function save_pose = move_capture(number, UR, US, file_name)
    save_pose = [];
    for i= 1:number
        current_hom_matrix = UR.getPositionHomRowWise;
        save_pose = [save_pose; current_hom_matrix];
        coordinates = current_hom_matrix(:,4); 
        current_coordinates = Coordinates(coordinates(1),coordinates(2),coordinates(3));
        image_capture(US, file_name);
        
        x = current_coordinates.x + 1.5;
        y = current_coordinates.y - 1.5;
        z = current_coordinates.z + 0;

        new_coordinates = Coordinates(x,y,z);

        UR.moveToCoordinates(new_coordinates);
        pause(2)
    end

end