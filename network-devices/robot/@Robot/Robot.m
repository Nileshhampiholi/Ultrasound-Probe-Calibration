classdef (Abstract) Robot < NetworkDevice
    %ROBOTG Summary of this class goes here
    %   Detailed explanation goes here
        
    properties
        waitForRobotMov = true;
        lastPose = [eye(3) zeros(3,1)];
    end
%     methods(Static)
%         % Disconnects from server.
%         bye(self)
%         % Gets current configuration.
%         getStatus(self)
%         % Gets current joints configuration.
%         getJointPositions(self)
%         % Gets current homogeneous matrix.
%         getPositionHomRowWise(self)
%         % 
%         moveToJointPositions(self, newJointPositions)
%         %
%         backwardCalc(self,matrix)
%         %
%         forwardCalc(self,thetas)        
%         %
%         moveToHomRowWise(self, targetMatrix)
%         %
%         setSpeed(self, speed)
%         %
%         speed = getSpeed(self)
%         %
%         isPossible(self, matrix, configuration)
%         %
%         setVerbosity(self, verbosity)
%         %
%         getJointsMaxChange(self)
%         %
%         setJointsMaxChange(self, jointsChange)
%         %
%         waitForPositionHom(self, target)
%         % 
%         enableLin(self)
%         % 
%         enableLin(self)
%     end
    
    methods (Access = protected)
        function self = Robot(ip,port)
            self@NetworkDevice(ip,port);
        end
        % Disconnects from robot.
        function disconnect(self)
            self.sendReceive('Quit');
        end
    end
    
    methods (Static)
        % Prompt for IP
        function ip = promptForIP()
            valid = false;
            while(~valid)
                prompt = sprintf(['Pick the environment you are working in:\n' ...
                    '1. Virtual Machine (%s)\n2. Lab (%s)\n3. Local (%s)\n4. Virtual Machine (%s)\n'], ...
                    char(IPaddresses.Robot_VM), char(IPaddresses.Robot_Lab), char(IPaddresses.Robot_Local), char(IPaddresses.Robot_VM2));
                choice = input(prompt);
                switch(choice)
                    case 1
                        ip = IPaddresses.Robot_VM;
                        valid = true;
                    case 2
                        ip = IPaddresses.Robot_Lab;
                        valid = true;
                    case 3
                        ip = IPaddresses.Robot_Local;
                        valid = true;
                    case 4
                        ip = IPaddresses.Robot_VM2;
                        valid = true;
                    otherwise
                end
            end
        end
    end
end

