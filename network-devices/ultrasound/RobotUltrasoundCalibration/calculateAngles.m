%% Calculate new function if a pose can't be read
function newOrientations = calculateAngles (N,centerPos,varargin)
%%
if nargin<3
    R = 100;
else
    R = varargin{1};
end

if nargin<4
    rpyLim = [-20 20 -20 20 -20 20];
else
    rpyLim = varargin{2};
end

minRoll = rpyLim(1);
maxRoll = rpyLim(2);
minPitch = rpyLim(3);
maxPitch = rpyLim(4);
minYaw = rpyLim(5);
maxYaw = rpyLim(6);

rotations = randomRotations(N, minRoll, maxRoll, minPitch, maxPitch, minYaw, maxYaw);
positions = randomSpherePoints(N,R,centerPos(1,4),centerPos(2,4),centerPos(3,4));

newOrientations = zeros(4,4,N);

reverseStr = '';
for i=1:N
    msg = sprintf('%d%s', round(i/N*100,0), '%%');
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg) - 1);
    newOrientation = getRot(centerPos)*rotations{i};
    translation = positions{i};
    H = [newOrientation translation; 0 0 0 1];
    newOrientations(:,:,i) = H;
end

end