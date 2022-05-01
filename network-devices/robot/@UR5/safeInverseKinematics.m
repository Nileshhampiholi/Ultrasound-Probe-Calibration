function thetas = safeInverseKinematics(H, config, currentJoints)
%SAFEINVERSEKINEMATICS Summary of this function goes here
%   Detailed explanation goes here

thetas = UR5.inverseKinematics(H, config);

for i=1:6
    if(abs(currentJoints(i) - thetas(i)) > 180)
        oldTheta = thetas(i);
        if(thetas(i) < 0)
            thetas(i) = thetas(i) + 360;
        else
            thetas(i) = thetas(i) - 360;
        end
        disp(sprintf('Joint %f corrected from %f to %f', i, oldTheta, thetas(i)));
    end
end

if(thetas(3) > 150)
    warning(sprintf('Joint 3 is out of bounds: %f. Bounds are [-360, 150].', thetas(3)))
    thetas(4) = currentJoints(4);
end

if(thetas(4) < -150 || thetas(4) > 44)
    warning(sprintf('Joint 4 is out of bounds: %f. Bounds are [-150, 44].', thetas(4)))
    thetas(4) = currentJoints(4);
end


if(thetas(5) < 1 || thetas(5) > 140)
    warning(sprintf('Joint 5 is out of bounds: %f. Bounds are [1, 140].', thetas(4)))
    thetas(5) = currentJoints(5);
end

end

