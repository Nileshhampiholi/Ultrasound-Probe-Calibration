classdef UR3 < Robot
    %UR3 Summary of this class goes here
    %   Detailed explanation goes here
    properties (Constant)
        dh = DevanitHartenberg( ...
            sym('theta', [6 1]), ...
            [0.1519; 0; 0; 0.11235; 0.08535; 0.0819]*1000, ...
            [0; -0.24365; -0.21325; 0; 0; 0]*1000, ...
            [pi/2; 0; 0; pi/2; -pi/2; 0])
    end
    
    methods (Access = public)
        %% Constructor
        function self = UR3(varargin)
            ip = NaN;
            port = 5003;
            if nargin == 1
                ip = varargin{1};
            elseif nargin == 2
                ip = varargin{1};
                port = varargin{2};
            elseif nargin > 2
                error('UR3::Wrong number of arguments.\nUsage: UR3([ip,port])');
            end
            self@Robot(ip,port);
            % Send the keyword to authorize the client
            self.sendReceive('Hello Robot');
        end
    end    
end

