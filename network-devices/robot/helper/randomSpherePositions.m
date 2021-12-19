function positions = randomSpherePositions(centerPos, R, N, dmin, dmax)
%RANDOMSPHEREPOSITIONS Summary of this function goes here
%   Detailed explanation goes here
positions = createArrays(N, [4,4]);

for i=1:N
    %% Generate the random poses in the sphere
    randAngle = (dmax-dmin)*rand()+ dmin; % Generate random angle
    % Generate random translation inside a sphere
    theta = (pi - 0) * rand()   + 0;
    phi =   (pi - (-pi))*rand() + (-pi);
    r =     (R-0)*rand()        + 0;
    
    roll = [cos(randAngle) -sin(randAngle) 0; sin(randAngle) cos(randAngle) 0; 0 0 1];
    pitch = [cos(randAngle) 0 sind(randAngle);0 1 0;  -sin(randAngle) 0 cos(randAngle)];
    yaw = [1 0 0; 0 cos(randAngle) -sin(randAngle) ;  0 sin(randAngle) cos(randAngle)];
    translate = [ r*sin(theta)*cos(phi);r*sin(theta)*sind(phi);r*cos(theta);1];
    
    rotationmat = roll*pitch*yaw;
    rotation = [rotationmat; 0 0 0];
    transformmat = [ rotation, translate];
    
    positions{i} =  centerPos * transformmat;
end

end

