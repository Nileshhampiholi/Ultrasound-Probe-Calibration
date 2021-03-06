function [X, Y] = QR24(M, N, varargin)
%QR24 calibrates tool/flange (needle/end-effector) and robot/world (robot/
%   camera)calibration 
%
%   Reference: Ernst, Floris, et al. "Non-orthogonal Tool/Flange and Robot/
%   World Calibration for Realistic Tracking Scenarios in Medical 
%   Applications." (2012).
%
%   QR24(M, N) 
%   M and N are the 4x4xn matrices corresponding to the robot poses and 
%   tracked locator poses respectively.
%   Note: A locator is a collection of markers which can be tracked by the
%   tracking camera.
%
%   QR24(M, N, factor)
%   M and N are the 4x4xn matrices corresponding to the robot poses and 
%   tracked locator poses respectively. A scalar 'factor' can be provided
%   for the translation parts of the M and N matrices.
%
%   QR24(M, N, factor, conf)
%   M and N are the 4x4xn matrices corresponding to the robot poses and 
%   tracked locator poses respectively. A scalar 'factor' can be provided
%   for the translation parts of the M and N matrices. A string 'conf' 
%   ('Minv' or 'Ninv') defines one of the two ways to configure your system 
%   of equations (specifically the A-matrix in Aw = b) as given by Eqn. 6 
%   of the referenced paper.
%
%       'Minv'      For inv(M_i)*Y*N_i = X
%
%       'Ninv'      For M_i*X*inv(N_i) = Y
%
%       Note: The above configurations can result in different error 
%       measures. For example, select 'Minv' when inverting tracking camera 
%       poses is more susceptible to errors 
%       i.e. norm(N_i, inv(N_i)) > norm(M_i, inv(M_i))
%
%   Returns:
%   =======
%
%   X       Tranformation from locator to end-effector.
%
%   Y       Tranformation from camera to robot.
%
%   Modified 28th May 2015
%   Omer Rajput - MTEC, TUHH.

if nargin == 2
    fctr = 1;
    conf = 'Minv';
elseif nargin == 3
    fctr = varargin{1};
    conf = 'Minv';
elseif nargin == 4
    fctr = varargin{1};
    conf = varargin{2};
else
    error('QR24:argChk', ['Wrong number of input arguments\n',...
                          'Usage: [X, Y, Q, b] = QR24(RobPoses, TrackedLocatorPoses) or \n', ...
                          '       [X, Y, Q, b] = QR24(RobPoses, TrackedLocatorPoses, factor)'])
end

if ~strcmp(conf, 'Minv') && ~strcmp(conf, 'Ninv')
    error('QR24:ConfChk', ['QR24 expects the ''conf'' parameter to ', ...
        'be either ''Minv'' (for system of equation inv(M)*Y*N = X) or ', ...
        '''Ninv'' (for system of equation M*X*inv(N) = Y)'])
end

if ndims(M) ~= 3 || ndims(N) ~= 3
    error('QR24:DimChk', ['QR24 expects the robot poses and ', ...
        'tracked locator poses (M and N) to be 4x4xn matrices ', ...
        'where n is the number of observations.'])
end

if size(M,3) ~= size(N,3)
    error('QR24:NumObsChk', ['QR24 expects equal number of the robot poses ', ...
        'and tracked locator poses (M and N).'])
end

% Number of observations provided
numObs = size(M,3);

% The relationship among the four tranformations is M_i*X = Y*N_i, 
% where i = 1, ..., n.
% X and Y contain 12 non-trivial elements each i.e. 24 variables to solve
%
% The system of equation for n observations, therefore, contains 12n
% equations in 24 variables.
%
% Expressing the system of equation in the form Aw = b as in Eqns. 4-6 in
% the referenced paper.
A = zeros(12*numObs, 24);
b = zeros(12*numObs,  1);

for i=1:numObs
    if strcmp(conf, 'Minv')
        Ni = N(:,:,i);
        Ni(1:3,4) = Ni(1:3,4) / fctr;

        R = invTfMat(M(:,:,i));
        t = R(1:3,4) / fctr;
        R = R(1:3,1:3);
    elseif strcmp(conf, 'Ninv')
        Ni = invTfMat(N(:,:,i));
        Ni(1:3,4) = Ni(1:3,4) / fctr;

        R = M(:,:,i);
        t = R(1:3,4) / fctr;
        R = R(1:3,1:3);
    end
    % 12 rows of the A matrix for i-th observation
    A12x24 = zeros(12,24);
    A12x24(:, 1:12) = [
                            R*Ni(1,1), R*Ni(2,1), R*Ni(3,1), zeros(3,3)
                            R*Ni(1,2), R*Ni(2,2), R*Ni(3,2), zeros(3,3)
                            R*Ni(1,3), R*Ni(2,3), R*Ni(3,3), zeros(3,3)
                            R*Ni(1,4), R*Ni(2,4), R*Ni(3,4), R          ];

    A12x24(:, 13:24) = -eye(12);
    
    A((i-1)*12+1:i*12,:) = A12x24;

    b((i-1)*12+1:i*12) = [zeros(9,1); -t];
end

%QR15
%A = [  R*Ni(1,4), R*Ni(2,4), R*Ni(3,4), R, -eye(3)];
%b = -t;


w = A\b;

if strcmp(conf, 'Minv')
    Y = [w(1:3), w(4:6), w(7:9), w(10:12) * fctr; 0 0 0 1];
    X = [w(13:15), w(16:18), w(19:21), w(22:24) * fctr; 0 0 0 1];
elseif strcmp(conf, 'Ninv')
    X = [w(1:3), w(4:6), w(7:9), w(10:12) * fctr; 0 0 0 1];
    Y = [w(13:15), w(16:18), w(19:21), w(22:24) * fctr; 0 0 0 1];
end
end
