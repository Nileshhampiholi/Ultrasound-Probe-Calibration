classdef UR5 < Robot
    %UR5 Summary of this class goes here
    %   Detailed explanation goes here
    properties (Constant)
        dh = DevanitHartenberg( ...
            sym('theta', [6 1]), ...
            [0.089159; 0; 0; 0.10915; 0.09465; 0.0823]*1000, ...
            [0; -0.42500; -0.39225; 0; 0; 0]*1000, ...
            [pi/2; 0; 0; pi/2; -pi/2; 0])
    end
    
    methods (Access = public)
        %% Constructor
        function self = UR5(varargin)
            ip = NaN;
            port = 5005;
            if nargin == 1
                ip = varargin{1};
            elseif nargin == 2
                ip = varargin{1};
                port = varargin{2};
            elseif nargin > 2
                error('UR5::Wrong number of arguments.\nUsage: UR5([ip,port])');
            end
            self@Robot(ip,port);
            % Send the keyword to authorize the client
            self.sendReceive('Hello Robot');
        end
    end    
    
    methods(Static)
      H = forwardEndeffector(thetas)
      jTgtNew = wrapJointAngles(jTgt, jRef)
      thetas = inverseKinematics(H, config)
      thetas = inverseKinematicsWrapAng(H, config, thetasCurr)
      thetas = safeInverseKinematics(H, config, currentJoints)
      basic_path_planningUR5()
    end
end

