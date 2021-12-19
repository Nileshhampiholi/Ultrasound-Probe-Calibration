function [ scaleMat,tfMatImageToProbe ] = getUSCalibrationResults()
%getUSCalibrationResults returns the results of US calibtation.

filePath = input('Please enter the path to the .mat file with scaleMat\n','s');
myVars = {'scaleMat', 'tfMatImageToProbe'};
S = load(filePath, myVars{:});
scaleMat = S.scaleMat
tfMatImageToProbe = S.tfMatImageToProbe

% Expecting xmmPerPx = 0.0819 and ymmPerPx = 0.0833 diag matrix
% scaleMat = diag([xmmPerPx ymmPerPx]);
% tf = [[   -0.2958   -0.9552   -0.0135  -44.6195];
%     [   -0.9536    0.2944    0.0637   71.3635];
%     [    0.0569   -0.0317    0.9979   17.9848];
%     [         0         0         0    1.0000]];
end