function [TAll,timestamps,visFlag,errs] =  getNTransformsReliable(self, N, varargin )
%getNTransformsReliable Returns always a transformmatrix which was
%                               read by the cameras
%   Can be used everytime when we have to calibrate by hand
maxTries = 5;
if nargin == 3
    maxTries = varargin{1};
elseif nargin ~= 2
    error('Wrong number of arguments!\nUsage: [TAll,timestamps, visFlag, errs] =  cam.getNTransformsReliable( N[, maxTries] )');
end
TAll = zeros(4,4,N);
timestamps = zeros(N,1);
errs = zeros(N,1);
for idx = 1:N
    [TAll(:,:,idx), visFlag, timestamps(idx), errs(idx)] = self.getTransformMatrixReliableLimTries(maxTries);
    if ~visFlag
        break;
    end
end

