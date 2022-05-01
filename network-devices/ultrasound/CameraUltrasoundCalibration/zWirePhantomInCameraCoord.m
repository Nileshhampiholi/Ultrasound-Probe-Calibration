function [p, TAll] = zWirePhantomInCameraCoord(trkServerIP, varargin)
%ZWIREPHANTOMINCAMERACOORD Connects to the "TrackingServer"
%   ZWIREPHANTOMINCAMERACOORD(TRKSERVER)
%   Connects to the "TrackingServer" with IP address of TRKSERVERIP at port
%   5000.
%
%   ZWIREPHANTOMINCAMERACOORD(IPSTRVAR,NUMREPITION) Connects to the
%   "TrackingServer" with with IP address of TRKSERVERIP at port
%   5000. It repeats the measurement NUMREPITION times (Default: 5).
%
%   Returns the coordinates of the tip of stylus-marker-geometry in 'p' and
%   the transformations of the stylus-locator in 'TAll' relative to the 
%   camera coordinate system. 
% 
%   This function assumes that the tracking camera has been trained to
%   track the 'stylus' marker-geometry. The 'stylus' is a custom 3D-printed
%   object with four reflective markers located on it. 
%
%   The TrackingServer should be able to find the 'stylus'-marker-geometry
%   file at '[DeviceServerLocation]\data\Devices\AxiosCamBarB2\locators' or
%   '[DeviceServerLocation]\data\Devices\AtracsysFusionTrack500\locators'
%   in the PC (NESSA) where TrackingServer is running.
%   
%   Modified 22th Feb 2018
%   Omer Rajput - MTEC, TUHH.

% defaults
numRepition = 5;
trkServerPort = 5000;
markerGeometryName = 'stylus';

% handle input arguments
if nargin == 2
    numRepition = varargin{1};
elseif nargin == 3
    numRepition = varargin{1};
    trkServerPort = varargin{2};
elseif nargin == 4
    numRepition = varargin{1};
    trkServerPort = varargin{2};
    markerGeometryName = varargin{3};
elseif nargin ~= 1
    error('err:zWirePhantomInCameraCoord:wrongArguments', ...
        ['There was an unsupported number of input arguments\n',...
         'Usage: zWirePhantomInCameraCoord(''134.28.45.17''[, 5, 5000, ''stylus''])']);
end


% Open the TCP/IP-Connection
disp('Connecting to Tracking Server')
cam = TrackingLuebeck(trkServerIP,trkServerPort,markerGeometryName,'FORMAT_MATRIXROWWISE');

disp('Starting the measurements...');
disp(['Make sure that you have correctly placed the tip of the stylus',...
     ' at the location you want to measure.']);
disp('Press any key when you are ready for the first measurement...');
% A loop to aquire data continously
N = 4; % for 4 wire-end-points on the z-shape.
figure;hold on;pause;
p = zeros(4,N*numRepition);
TAll = zeros(16,N*numRepition);
for rep = 1:numRepition
    i=1;
    while (i<=N)
        % Send the command word to get the locator position. The locator has to
        % be loaded before.
        [T,timestamp,err] =  cam.getTransformMatrixReliable();
        %[T,timestamp] = GetLocatorTransformMatrix(t, 'stylus');
        absPtNum = i+(rep-1)*N;
        TAll(:,absPtNum) = T(:);
        % transform marker center point in camera coordinates
        p(:,absPtNum) = T * [0,0,0,1]';
        disp(['Timestamp: ' num2str(timestamp) ' - rep: ' num2str(rep) ', p' num2str(i) ': ' num2str(p(:,absPtNum)')])
        % plot the marker position
        plot3(p(1,absPtNum),p(2,absPtNum),p(3,absPtNum),'ko');
        title(['rep: ' num2str(rep) ', measurements so far ' num2str(absPtNum)]);
        % wait 0.001 seconds
        disp('Press any key to continue to the next measurement...')
        pause;
        i=i+1;
    end
end
hold off;

prompt = 'Do you want to save the measured data for later use? Y/N [N]: ';
str = input(prompt,'s');
if strcmpi(str,'y')
    mkdir('./','ultrasoundImagesAndPoses')
    save('ultrasoundImagesAndPoses/zWireEndPoints.mw','p','TAll');
end