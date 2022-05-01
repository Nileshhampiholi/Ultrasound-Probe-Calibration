function moveAlongLine( testCase )
%MOVEALONGLINE Summary of this function goes here
%   Detailed explanation goes here
start = [233 -439 217];
destination = [-26 -475 124];

testCase.robot.moveLinAlongLine(start, destination, 0.5);

end

