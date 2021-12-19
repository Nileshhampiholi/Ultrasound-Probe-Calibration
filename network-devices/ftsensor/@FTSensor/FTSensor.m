classdef FTSensor < NetworkDevice
    %FTSensor Summary of this class goes here
    %   Detailed explanation goes here
    %   FTSensor(ip,port)

    
    properties 
    end
    
    methods (Access = public)
        % Constructor
        function self = FTSensor(ip,port)
            self@NetworkDevice(ip,port);
            pause(0.01);
        end
    end
    
    methods (Access = private)
        %% Disconnects from robot.
        function disconnect(self)
            jtcp('close',self.client);
        end
    end
end

