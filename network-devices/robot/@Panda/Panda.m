classdef Panda < Robot
    %UR3 Summary of this class goes here
    %   Detailed explanation goes here
    properties (Constant)
    end
    
    methods (Access = public)
        %% Constructor
        function self = Panda(varargin)
            ip = NaN;
            port = 5003;
            if nargin == 1
                ip = varargin{1};
            elseif nargin == 2
                ip = varargin{1};
                port = varargin{2};
            elseif nargin > 2
                error('UR3::Wrong number of arguments.\nUsage: Panda([ip,port])');
            end
            self@Robot(ip,port);
            % Send the keyword to authorize the client
            self.sendReceive('Hello Robot');
        end
    end    
end

