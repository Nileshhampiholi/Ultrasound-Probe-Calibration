classdef ABB < Robot
    %ABB Summary of this class goes here
    %   Detailed explanation goes here
    properties (Constant)
        dh = DevanitHartenberg( ...
            sym('theta', [6 1]), ...
            [0.29; 0; 0; 0.302; 0; 0.075]*1000, ...
            [0; 0.27; -0.07; 0; 0; 0]*1000, ...
            [-pi/2; 0; pi/2; -pi/2; pi/2; 0])
    end
    
    methods (Access = public)
        %% Constructor
        function self = ABB(varargin)
            ip = NaN;
            port = 5006;
            if nargin == 1
                ip = varargin{1};
            elseif nargin == 2
                ip = varargin{1};
                port = varargin{2};
            elseif nargin > 2
                error('ABB::Wrong number of arguments.\nUsage: ABB([ip,port])');
            end
            self@Robot(ip,port);
            
            % Send the keyword to authorize the client
            self.sendReceive('Hello Robot');
        end
    end
end

