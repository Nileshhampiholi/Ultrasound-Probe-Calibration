function success = move_to_joint_angles(obj, new_joint_angles)
    success = false;
    new_home_matrix = obj.forwardCalc(new_joint_angles);

    possible = obj.isPossible(new_home_matrix, obj.getStatus);

    if possible ==true
        obj.moveToJointPositions(new_joint_angles);
        success = true;
    end
end
