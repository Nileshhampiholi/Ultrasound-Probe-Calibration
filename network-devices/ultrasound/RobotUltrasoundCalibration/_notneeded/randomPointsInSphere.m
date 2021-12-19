function randomPointsInSphere( jTcpObj )
%randompoints testrandompoints on simulator
%   Simply goes to randomly generated positions

centerPos = getPositionHomRowWise(jTcpObj);

R = 15;
N = 20;
dmin = -pi/32;
dmax = -dmin;
positions = randomSpherePositions(centerPos, R, N, dmin, dmax);
failed = 0;

failedPositions = createArrays(0, [4 4]);
for i=1:N
    configuration = getStatus(jTcpObj);
    if(isPossible(positions{i},configuration,jTcpObj))
       % positions{i}
        pause
        i
        MoveMinChangeRowWiseStatus(jTcpObj, positions{i});
    else
        failed = failed + 1;
        failedPositions{failed} = positions{i};
    end
end
failedCount = size(failedPositions);
failedCount

end
